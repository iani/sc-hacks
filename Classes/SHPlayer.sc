/*
Hold a synthdef or synthdef-making func and make synths from it.
Create new synths when requested.
Connect the synths to the envir that they play in, so that they change
their (set) their parameters (controls) in response to changes in the environment's values.
Also create notification connections for starting/stopping synths from patterns played
in the environment.
*/

SHPlayer {
	var <envir, <name;
	
	*new { | envir, name = \default ... args |
		// Note: creating a new instance now pushes the environment
		^this.newCopyArgs (envir.asEnvironment (true), name, *args).init
	}

	init {}
}

SynthPlayer : SHPlayer {
	var <def, <controlNames, <hasGate = false;
	var <synth;

	init {
		this.addNotifier (envir, name, { | command |
			this perform: command;
		});
	}

	play { | func |
		var outbus, target, server;
		// if still waiting to start synth after def, then skip this play!
		if (synth.notNil and: { synth.isPlaying.not}) {
				"Waiting for created synth to start".postln;
				^this
		};
		// stop previous synth, and remove def if appropriate:
		this clearPreviousSynth: func;
		// If a function or symbol is provided, then make def, then synth,
		// else use old def or default def:
		this makeSynth: func;
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

	makeSynth { | func |
		// If a function or symbol is provided, then make def, then synth,
		// else use old def or default def:
		var target, server, outbus;
		switch (func.class,
			Function, {
				target = envir [\target].asTarget;
				server = target.server;
				this.def = func.asSynthDef (
					fadeTime: envir [\fadeTime] ? 0.02,
					name: SystemSynthDefs.generateTempName
				);
				synth = Synth.basicNew(def.name, server);
				outbus = envir [\outbus] ? 0;
				def.doSend (
					server,
					synth.newMsg(target, [\i_out, outbus, \out, outbus] ++ this.makeSynthArgs,
						envir [\addAction] ? \addToHead);
				);
			},
			{
				def ?? {
					this.def = (SynthDescLib.at (func) ?? { SynthDescLib at: \default}).def;
				};
				synth = Synth (
					def.name, this.makeSynthArgs, target, envir [\addAction] ? \addToHead
				)
			};
		);
		this connectSynth: synth;
	}

	def_ { | argDef |
		var parName;
		def = argDef;
		controlNames = def.allControlNames reject: { | a | a.rate === \scalar }
		collect: { | cn |
			parName = cn.name;
			// only set value if no other synth has set it before.
			// avoid changing other synths parameters with your defaults:
			(envir [parName]) ?? { envir [parName] = cn.defaultValue };
			parName;
		};
		hasGate = controlNames includes: 'gate';
		def.add;
	}

	makeSynthArgs {
		// create array of arguments to initialize new synth, from environment.
		^controlNames.collect ({ | name |
			[name, envir[name]]
		}).select ({ | pair |
			pair [1].notNil;
		}).flat;
	}

	connectSynth { | argSynth |
		/* argSynth created by this.play
			1. Store it
			2. When it is really started, then:
			2.1 Connect to environment parameters according to controlNames
			2.2 Connect extra actions: restart, release, free, etc.
			2.3 Initialize auto-removal on end.
		*/
		synth = argSynth;
		synth.onStart (this, {
			controlNames do: { | param |
				synth.addNotifier (envir, param, { | val, notification |
					notification.listener.set (param, val);
				});
				synth.onEnd (this, {
					synth.objectClosed;
					synth = nil;
				});
			};
		})
	}

	stop {
		synth ?? { ^this };
		synth.objectClosed;
		if (hasGate) {
			synth release: (envir [\fadeTime] ? 0.02);
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
}

PatternPlayer : SHPlayer {
	var <>event;
	var <>player;

	init {
		event ?? { event = () }
	}

	isPlaying { ^player.isPlaying }
	stop { player.stop }

	play { | argEvent |
		event = argEvent ? event;
		if (player.isPlaying) { player.stop };
		player = EventPattern (event).play;
	}

	addKey { | key, object |
		event [key] = object;
		if (player.isPlaying) { player.addKey (key, object) }
	}

	addEvent { | argEvent |
		event putAll: argEvent;
		if (player.isPlaying) { player.addEvent (argEvent) }
	}

	setEvent { | argEvent |
		event = argEvent;
		if (player.isPlaying) { player.setEvent (argEvent) }
	}

	// experimental
	// From Event:eplay
	etype {
		event [\type] = \envEvent;
		event [\envir] = currentEnvironment;
	}
}

RoutinePlayer : SHPlayer {
	var <func, <clock;
	var <routine;

	init {
		func ?? {
			func = {
				loop {
					"routine playing default loop here".postln;
					1.wait;
				}
			}
		};
		clock = clock ? SystemClock;
	}	
	
	play { | argFunc, argClock |
		argFunc !? { func = argFunc };
		argClock !? { clock = argClock };
		if (routine.isPlaying) {
			routine.stop;
		};
		routine = func.fork (clock);
	}

	stop { routine.stop }
}