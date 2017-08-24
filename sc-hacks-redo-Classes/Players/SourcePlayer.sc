
SourcePlayer {
	var <player, <envir, <source;

	*new { | player, source | // plays immediately:
		^this.newCopyArgs(player, player.envir).playSource(source);
	}
}

PatternPlayer : SourcePlayer {

	play { | argSource |
		

	}
}

SynthPlayer : SourcePlayer {
	var <controlNames, <hasGate = false, <event;	

	playSource { | argSource |
		var outbus, target, server;
		// if still waiting to start synth after def, then skip this play!
		if (player.notNil and: { player.isPlaying.not}) {
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
			def.notNil and: // there is a def to remove
			{ funcOrDef.notNil } and: // a new def has been provided
			{ funcOrDef != def} and: // new def is different than the previous def
			{ def.name.asString [..3] == "temp"}) { // the previous def is temporary
				defName = def.name;
				def = nil;
			};
		if (synth.isNil) { // if no synth plays, then remove def immediately
			defName !? { SynthDef removeAt: defName }
		} {   // else remove def after end of released synth
			synth.objectClosed;
			synth.onEnd (this, {
				defName !? { SynthDef removeAt: defName }
			});
			synth.release (envir [\fadeTime] ? 0.02);
			synth = nil
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
				target = envir [\target].asTarget;
				server = target.server;
				// TODO: check if args already contain \out - outbus
				#args, busses = this.source_(
					argSource.asPlayerSynthDef (
						fadeTime: envir [\fadeTime] ? 0.02,
						name: SystemSynthDefs.generateTempName
					).add
				);
				player = Synth.basicNew(source.name, server);
				outbus = envir [\outbus] ? 0;
				source.doSend (
					server, // TODO: remove \out, outbus from args and check
					player.newMsg(target, [\i_out, outbus, \out, outbus] ++ args,
						envir [\addAction] ? \addToHead);
				);
			},
			Symbol, {
				#args, busses = this.source_(
					(SynthDescLib.at (argSource) ?? { SynthDescLib at: \default}).def
				);
				player = Synth (
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
				player = Synth (
					source.name, args, target, envir [\addAction] ? \addToHead
				)
			};
		);
		// Connect created synth to the environment and map the busses, when started
		this.connectPlayer (player, busses);
	}

	source_ { | def |
		var parName;
		source = argDef;
		hasGate = false;
		controlNames = def.allControlNames reject: { | a |
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
		player = argSynth;
		player.onStart (this, {
			this.changed(\started);
			/* If busses exist, then start the synth's gated envelope after mapping them */
			if (busses.size > 0) {
				busses keysValuesDo: { | key, value |
					// postf("mapping synth: %, param: % to bus: %\n", this, key, value);
					player.map(key, value);
				};
				player.set(\gate, 1);
			};
			(controlNames add: \gate) do: { | param |
				player.addNotifier (envir, param, { | val, notification |
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
			player.onEnd (this, {
				this.changed(\stopped);
				player.objectClosed;
				player = nil;
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

	isPlaying { ^synth.isPlaying }
}

SynthPlayer : SHPlayer {
	var <def, <controlNames, <hasGate = false;

	

	

	

	def_ { | argDef |
		var parName;
		def = argDef;
		controlNames = def.allControlNames reject: { | a |
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
		// hasGate = controlNames includes: 'gate';
		// def.add; // done separately in makeSynth
	}

	makeSynthArgs {
		// create array of arguments to initialize new synth, from environment.
		var args, busses, numCtls, val;
		numCtls = controlNames.size + 1 * 2;
		args = Array.new(numCtls);
		busses = Array.new(numCtls);
		controlNames do: { | name |
			val = envir[name];
			switch(val.class,
				Nil, { },
                Bus, { busses add: name; busses add: val },
                { args add: name; args add: val }
            );
		};
		args add: \gate;
		if (busses.size > 0) {
			args add: 0
		}{
			args add: 1
		};
		^[args, busses];
		
	}

	stop { | releaseTime |
		synth ?? { ^this };
		synth.objectClosed;
		if (hasGate) {
			synth release: (releaseTime ? envir [\fadeTime] ? 0.02);
		}{
			synth.free;
		};
		synth = nil;
	}

	// mainly for calls via EventPattern:
	tie {
		// Do not change synth status.  Param changes effect legato
	}

	null { // synonym of tie
		// Do not change synth status.  Param changes effect legato
	}
	
	mute {
		
	}

	unmute {
		
	}

	trigger {
		
	}

	release {
		
	}

	clear { // ? just use remove instead?
		
	}

	remove { // clear and remove from Registry
		
	}

	// ================================================================
	// GUI - experimental
	gui { | specs |
		// create gui for this player.
		/* // simple usage example: 
			\default +> \testgui1 gui: [\freq, \amp]; // uses current envir
			\default +>.env2 \testgui1 gui: [\freq, \amp]; // uses env2 as envir
		*/
		if (specs.size == 0) {
			name.sliders(*controlNames.collect(this.getGuiSpec(_)));
		}{
			name.sliders(*specs);
		};
	}

	getGuiSpec { | argName |
		var spec;
		spec = Registry.at(\synthPlayers, this, \specs, argName);
		spec ?? { spec = argName.asSpec ?? { \amp.asSpec }};
		^[argName, spec.storeArgs];
	}
}

