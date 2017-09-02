
SourcePlayer {
	var <player, <envir, <source, <process;

	*new { | player, source | // plays immediately:
		^this.newCopyArgs(player, player.envir);
	}

	isPlaying { ^process.isPlaying }
}


PatternPlayer : SourcePlayer {
	
	play { | argSource |
		

	}
}

SynthPlayer : SourcePlayer {
	var <controlNames, <hasGate = false, <event;	

	play { | argSource |
		var outbus, target, server;
		postf("% play %\n", this, argSource);
		// if still waiting to start synth after def, then skip this play!
		postf("playSource argSource is: %\n", argSource);
		if (process.notNil and: { process.isPlaying.not}) {
			"Waiting for created synth to start".postln;
			^this
		};
		// stop previous synth, and remove def if appropriate:
		this clearPreviousSynth: argSource;
		// If a function or symbol is provided, then make def, then synth,
		// else use old def or default def:
		this makeSynth: argSource;
	}

	clearPreviousSynth { | funcOrDef |
		// if previous synth is playing, release it.
		// if funcOrDef is different than current def,
		// and current def is temp, then remove def when synth ends.
		var defName;
		if ( // 4 conditions must be met:
			source.notNil and: // there is a def to remove
			{ funcOrDef.notNil } and: // a new def has been provided
			{ funcOrDef != source } and: // new def is different than the previous def
			{ source.name.asString [..3] == "temp"}) { // the previous def is temporary
				defName = source.name;
				source = nil;
			};
		if (process.isNil) { // if no synth plays, then remove def immediately
			defName !? { SynthDef removeAt: defName }
		}{   // else remove def after end of released synth
			process.objectClosed;
			process.onEnd (this, {
				defName !? { SynthDef removeAt: defName }
			});
			process.release (envir [\fadeTime] ? 0.02);
			process = nil
		};
	}
	
	makeSynth { | argSource |
		// If a function or symbol is provided, then make def, then synth,
		// else use old def or default def.
		// Note: previous synth has been cleared and synthdef removed,
		// or scheduled for removal after previous synth stops.
		var target, server, outbus, args, busses;
		// Create synth according to source class
		switch (argSource.class,
			// Here decide from argSource's class: if argSource is Function or Symbol,
			// then obtain def from them and use it.
			// Else provide a def by guessing.
			Function, {
				"I will make a synth from a function".postln;
				target = envir [\target].asTarget;
				server = target.server;
				// TODO: check if args already contain \out - outbus
				#args, busses = this.source_(
					argSource.asPlayerSynthDef (
						fadeTime: envir [\fadeTime] ? 0.02,
						name: SystemSynthDefs.generateTempName
					).add
				);
				process = Synth.basicNew(source.name, server);
				outbus = envir [\outbus] ? 0;
				source.doSend (
					server, // TODO: remove \out, outbus from args and check
					process.newMsg(target, [\i_out, outbus, \out, outbus] ++ args,
						envir [\addAction] ? \addToHead);
				);
			},
			Symbol, {
				"I will make a synth from a symbol".postln;
				#args, busses = this.source_(
					(SynthDescLib.at (argSource) ?? { SynthDescLib at: \default}).def
				);
				process = Synth (
					source.name, args, target, envir [\addAction] ? \addToHead
				)
			},
			{  // If no appropriate source was provided, then provide one by guessing:
				// if no source is already stored, then get one from SynthDescLib
				source ?? {
					#args, busses = this.source_(
						SynthDescLib.at (argSource) ?? { SynthDescLib at: \default}
					).def;
				};
				// source was either present, or provided by the immediately preceding step:
				process = Synth (
					source.name, args, target, envir [\addAction] ? \addToHead
				)
			};
		);
		// Connect created synth to the environment and map the busses, when started
		this.connectPlayer (process, busses);
	}

	source_ { | argDef |
		var parName;
		"Hello. This is source_".postln;
		"I was just tiven the following as argDef:".postln;
		argDef.postln;
		
		source = argDef;
		hasGate = false;
		controlNames = source.allControlNames reject: { | a |
			if (a.name === \gate) { // gate supplied by makeSynthArgs!
				hasGate = true;
			}{
				a.rate === \scalar
			};
		} collect: { | cn |
			parName = cn.name;
			// only set value if no other synth has set it before.
			// avoid changing other synths parameters with your defaults:
			(envir [parName]) ?? {
				// storing params here is useful if a gui is opened later:
				// but could be replaced by getting the gui defaults from
				// customized specs stored for each def. (TODO:!)
				envir [parName] = cn.defaultValue;
				// envir.changed(parName, cn.defaultValue)
			};
			parName;
		};
		^this makeSynthArgs: controlNames;
	}

	makeSynthArgs { | argControlNames |
		// create array of arguments to initialize new synth, from environment.
		var args, busses, numCtls, val;
		numCtls = argControlNames.size + 1 * 2;
		args = Array.new(numCtls);
		busses = Array.new(numCtls);
		argControlNames do: { | name |
			val = envir[name];
			switch(val.class,
				Nil, { },
                Bus, { busses add: name; busses add: val },
                { args add: name; args add: val }
            );
		};
		if (hasGate) {
			args add: \gate;
			if (busses.size > 0 ) {
				// If busses are present, then trigger env after mapping to them.
				args add: 0
			}{
				// Else trigger env at synth creation time.
				args add: 1
			}
		};
		^[args, busses];		
	}

	connectPlayer { | argSynth, busses |
		/* argSynth created by this.play
			1. Store it
			2. When it is really started, then:
			2.1 Connect to environment parameters according to controlNames
			2.2 Connect extra actions: restart, release, free, etc.
			2.3 Initialize auto-removal on end.
		*/
		process = argSynth;
		process.onStart (this, {
			this.changed(\started);
			/* If busses exist, then start the synth's gated envelope after mapping them */
			if (busses.size > 0) {
				busses keysValuesDo: { | key, value |
					// postf("mapping synth: %, param: % to bus: %\n", this, key, value);
					process.map(key, value);
				};
				process.set(\gate, 1);
			};
			(controlNames add: \gate) do: { | param |
				process.addNotifier (envir, param, { | val, notification |
					// handle busses as well as numerical values;
					switch (val.class,
						Nil, {},
						Bus, {
							/*
								postf("MAPPING SYNTH %. PARAM: %, VAL: %\n", 
								notification.listener,
								param, val);
							*/
							notification.listener.map(param, val);								
						},{
							notification.listener.set (param, val);							
						}
					)
				});
			};
			process.onEnd (this, {
				this.changed(\stopped);
				process.objectClosed;
				process = nil;
			});
		});
	}
	/*
		// envir can do this to add control from self to this player by name.
	init {
		this.addNotifier (envir, name, { | command |
			this perform: command;
		});
	}
	*/

}



