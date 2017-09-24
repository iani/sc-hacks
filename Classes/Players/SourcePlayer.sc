
SourcePlayer {
	var <player, <envir, <source, <process;

	*new { | player |
		^this.newCopyArgs(player, player.envir);
	}

	isPlaying { ^process.isPlaying }
}

PatternPlayer : SourcePlayer {

	play { | argSource | // argSource shoud be a kind of Event.
		var stream, event;
		// postf("playing PatternPlayer. player is: %, envir is: %\n", player, envir);
		
		if (source.isNil) {
			source = EventPattern(argSource);			
		}{
			source.addEvent(argSource);			
		};
		if (process.isNil) {
			source.put (\group, envir[\target].asTarget);
			envir.busses.keysValuesDo({ | key, value |
				source.put(key, value.index);
			});
			process = source.play;
		}{
			stream = process.originalStream;
			event = stream.event;
			stream.addEvent(argSource);
			stream.addEvent([\group, envir[\target].asTarget]);
			envir.busses.keysValuesDo({ | key, value |
				event.put(key, value.index);
			});
			if (process.isPlaying.not) { process.play };
		};		
	}

	release {
		process.stop; // later maybe add fadeOut ...
	}

	stop { process.stop }

	clear {
		// remove from source and EventPattern source and EventStreamPlayer process
		// all keys except for target nodes and busses.
		// TODO: implement clear for EventStreamPlayer and EventPattern.
		// process !? { process.clear }
		postf("% does not know how to clear yet\n", this);
	}

	put { | key, value |
		// used by Nevent:updateBusIndex.  SynthPlayer ignores this.
		// add a new key value pair to the source and if playing also to the process
		source !? { source.put(key, value) };
		process !? { process.put(key, value)};
	}

	setTarget { | orderedGroup |
		this.put(\group, orderedGroup.asTarget);
	}
}

SynthPlayer : SourcePlayer {
	var <controlNames, <hasGate = false, <event;	
	var <synthDefIsTemp = false;

	// isPlaying { ^process.notNil }

	play { | argSource |
		var outbus, target, server;
		// if still waiting to start synth after def, then skip this play!
		if (process.notNil and: { process.isPlaying.not}) {
			"Waiting for created synth to start".postln;
			^this
		};
		this.release; // stop previous synth;
		// If a function or symbol is provided, then make def, then synth,
		// else use old def or default def:
		this makeSynth: argSource;
	}

	stop { this.release }

	release { | newSource |
		/* New method to replace clearPreviousSynth.
			If newSource is provided, then emit notification to remove previous one
			if appropriate. */
		process !? {
			// Experimental: prevent /n_set Node xxxx not found at unynchronized end of synth.
			Notification.removeNotifiersOf(process);
			if (hasGate) {
				process.release (envir [\fadeTime] ? 0.02);
			}{
				process.free;
			}
		};
	}

	makeSynth { | argSource |
		// If a function or symbol is provided, then make def, then synth,
		// else use old def or default def.
		// Note: previous synth has been cleared and synthdef removed,
		// or scheduled for removal after previous synth stops.
		var target, server, outbus, args, busses, isTemp = false;
		// remove temp SynthDef if leftover from previous release.
		if (synthDefIsTemp and: { process.isNil } and: { argSource.notNil }) {
			SynthDef removeAt: source.name;
		};
		target = envir [\target].asTarget;
		server = target.server;
		// Create synth according to source class.
		switch (argSource.class,
			// Here decide from argSource's class: if argSource is Function or Symbol,
			// then obtain def from them and use it.
			// Else provide a def by guessing.
			Function, {
				isTemp = true;
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
				#args, busses = this.source_(
					(SynthDescLib.at (argSource) ?? { SynthDescLib at: \default}).def
				);
				process = Synth (
					source.name, args, target, envir [\addAction] ? \addToHead
				)
			},
			{   // Always recreate args and busses from current envir
				// To take current settings of envir into account (!)
				#args, busses = this.source_(
					// use source if it exists, else provide one by guessing:
					source ?? {
						(SynthDescLib.at (argSource) ?? { SynthDescLib at: \default}).def
					}
				);
				process = Synth (
					source.name, args, target, envir [\addAction] ? \addToHead
				)
			};
		);
		synthDefIsTemp = isTemp;
		// Connect created synth to the environment and map the busses, when started
		this.connectPlayer (process, busses, isTemp);
	}

	source_ { | argDef |
		var parName;
		
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

	connectPlayer { | argSynth, busses, isTemp = false |
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
			/* Furthermore make all controls of the synth listen to changes
				in the players environment */
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
			process.addNotifier(envir, \target, { | val |
				postf("INCOMPLETE. TESTING. Received target: %\n", val);
			});
			process.onEnd (this, { | notification |				
				if (process === notification.notifier) {
					this.changed(\stopped);
					process = nil;
				}
			});
			if (isTemp) {
				source.addNotifier(process, \n_end, { | notification |
					if (source !== notification.listener) {
						SynthDef removeAt: notification.listener.name;
					}
				});
			}
		});
	}

	put { | key, value |
		// used by Nevent:updateBusIndex.  SynthPlayer ignores this,
		// because they update their synths controls, if they are running, through
		// the the  Notifications created by connectPlayer method.
	}

	setTarget { | orderedGroup |
		if (process.isPlaying) {
			process.moveToHead(orderedGroup.group);
		}
	}
	clear {
		// empty process of PatternPlayer
		// SynthPlayer ignores this.
		// TODO: Possibly clear source?
		// source = nil; // ?????
			//	sourcePlayer !? { sourcePlayer.clear }
	}

	/*
		TODO: Rewrite this as release method.
		Check again for consistency in all use scenarios: 
		1. Release to stop the synth player but keep the current source for restarting.
		2. Release and clear the source (remove the SynthDef from the server!).
		   This is when: 
		   1. A new source has been provided and the old source is temp, so cleanup is needed.
		   2. This SynthPlayer will be discarded because it is replaced by a PatternPlayer.
	*/
	/*
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
			process.onEnd (source, {
				defName !? { SynthDef removeAt: defName }
			});
			process.release (envir [\fadeTime] ? 0.02);
			process = nil
		};
	}
	*/
}



