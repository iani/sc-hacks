/*
	==== Player: hold an envir and a sourcePlayer that plays in that envir.
	The sourcePlayer can be: 
	Nil (the Player is not playing)
	SynthPlayer (the Player plays a SynthDef as Synth)
	PatternPlayer (the Player plays an Event as EventPattern -> EventStream -> EventStreamPlayer)

	==== Older notes: (from SynthPlayer)	 
	Hold a synthdef or synthdef-making func and make synths from it.
	Create new synths when requested.
	Connect the synths to the envir that they play in, so that they change
	their (set) their parameters (controls) in response to changes in the environment's values.
	Also create notification connections for starting/stopping synths from patterns played
	in the environment.

	==== New implementation:

	1. Player: play : 
	arg (Function/Symbol/Event) source 
	var (Nil/SynthPlayer/PatternPlayer )sourcePlayer
	
	sourcePlayer = sourcePlayer.asSourcePlayer(this, (Function/Symbol/Event) source);
	must return a kind of SourcePlayer

	(Nil/SynthPlayer/PatternPlayer) asSourcePlayer : Player:player, (Function/Symbol/Event):source
	Case analysis and pseudocode for the above combinations follows here: 

	2. Nil : asSourcePlayer : player, (Function/Symbol/Event):source;
	source.asSourcePlayer player
	See Function, Symbol, SynthDef, Event asSourcePlayer below.

	3. SynthPlayer : asSourcePlayer : player, (Function/Symbol/Event):source;
	always release your player.
	if source is kind of Event, create PatternPlayer and play it and return it.
	Else play function or symbol in self, and return self

	4. PatternPlayer : asSourcePlayer  : player, (Function/Symbol/Event):source;
	never release your player.
	if source is kind of Event, merge it into your source and into your player
	and return self.
	Else  
	play function or symbol in self, and return self


	5. Function : asSourcePlayer -> SynthDef asSourcePlayer
	this.asSynthDef.asSourcePlayer

	6. Symbol : asSourcePlayer -> SynthDef asSourceplayer
	this.asSynthDef.asSourcePlayer

	7. SynthDef : asSourcePlayer
	create SynthPlayer and play it

	8. Event : asSourcePlayer
	create PatternPlayer and play it


*/

Player {
	var <envir, <name, <sourcePlayer;

	*new { | envir, name = \default |
		^this.newCopyArgs (envir.asEnvironment (true), name);
	}

	play { | source |
		sourcePlayer = sourcePlayer.asSourcePlayer(this, source);
	}

}

+ Nil {
	asSourcePlayer { | player, source |
		^source.asSourcePlayer(player)		
	}
}

SourcePlayer {
	var <player, <envir, <source;

	*new { | player, source | // plays immediately:
		^this.newCopyArgs(player, player.envir).play(source);
	}
}

PatternPlayer : SourcePlayer {
	asSourceplayer { | argPlayer, argSource |
		switch (argSource.class,
			Event, {
				this.play(argSource)				
			},{
				this.release;
				^SynthPlayer(argPlayer, argSource); // plays immediately
			}
		)
	}

	play { | argSource |
		

	}
}

SynthPlayer : SourcePlayer {
	var <controlNames, <hasGate = false, <event;	

	asSourceplayer { | argPlayer, argSource |
		// if still waiting to start synth after def, then skip this play!
		if (player.notNil and: { player.isPlaying.not}) {
			"Waiting for created synth to start after loading synthdef.".postln;
			postf("Cancelled playing of new source: %.\n", argSource);
			^this
		};
		this clearPreviousSynth: argSource; // release previous synth,
		// and clear previous synthdef if appropriate.
		// Then create either new PatternPlayer or new synth.
		switch (argSource.class,
			Event, {
				^PatternPlayer(argPlayer, argSource); // plays immediately
			},{
				this.play(argSource)
			}
		)
	}

	clearPreviousSynth { | argSource |
		// if previous synth is playing, release it.
		// if argSource is different than current def,
		// and current def is temp, then remove def when synth ends.
		var defName;
		if ( // 4 conditions must be met:
			source.notNil and: // there is a source to remove
			{ argSource.notNil } and: // a new source has been provided
			{ argSource != source } and: // new source is different than the previous source
			{ source.name.asString [..3] == "temp"}) { // the previous source is temporary
				defName = source.name;
				source = nil;  // def will be removed.  Store this.
			};
		if (player.isNil) { // if no synth plays, then remove source immediately
			defName !? { SynthDef removeAt: defName }
		} {   // else remove source after end of released synth
			player.objectClosed; // remove previous connections to other objects
			player.onEnd (this, { // create just this one connection to synthdef
				defName !? { SynthDef removeAt: defName }
			}); // since connection is set, do release:
			player.release (envir [\fadeTime] ? 0.02);
			player = nil; // since released, ready to play next one, and
			// avoid re-releasing this already released synth.
		};
	}
	
	play { | argSource |
		// If a function or symbol is provided, then make def, then synth,
		// else use old def or default def.
		// Note: previous synth has been cleared and synthdef removed,
		// or scheduled for removal after previous synth stops.
		var target, server, outbus, args, busses;
		// first just create the synth ...
		switch (argSource.class,
			// Here decide from argSource's class: if argSource is Function or Symbol,
			// then obtain def from them and use it.
			// Else provide a def by guessing.
			Function, {
				target = envir [\target].asTarget;
				server = target.server;
				// TODO: check if args already contain \out - outbus
				#args, busses = this.source_(
					argSource.asSynthDef (
						fadeTime: envir [\fadeTime] ? 0.02,
						name: SystemSynthDefs.generateTempName
					).add
				);
				synth = Synth.basicNew(source.name, server);
				outbus = envir [\outbus] ? 0;
				source.doSend (
					server, // TODO: remove \out, outbus from args and check
					synth.newMsg(target, [\i_out, outbus, \out, outbus] ++ args,
						envir [\addAction] ? \addToHead);
				);
			},
			Symbol, {
				#args, busses = this.source_(
					(SynthDescLib.at (argSource) ?? { SynthDescLib at: \default}).def
				);
				synth = Synth (
					source.name, args, target, envir [\addAction] ? \addToHead
				)
			},
			{  // Guessing part: If no appropriate source was provided,
				// then provide one by guessing:
				source ?? {
					#args, busses = this.source_(
						SynthDescLib.at (argSource) ?? { SynthDescLib at: \default}
					).def;
				};
				synth = Synth (
					source.name, args, target, envir [\addAction] ? \addToHead
				)
			};
		);
		// ... then connect it to the environment and map the busses, when started
		this.connectSynth (synth, busses);
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
}

+ EventStream {
	receiveEvent { | inEvent, patternPlayer |
		inEvent keysValuesDo: { | key value |
			event[key] = value;
			streamEvent[key] = value.asStream;
		}		
	}
}


+ Synth {
	receiveEvent { | event |
		this.release;
		^Pattern
	}
	
}
+ Function {

	asSourcePlayer { | player |
		^player.playFunction(this); // always releases
	}

	
}

+ Event {
	asSourcePlayer { | player |
		^player.playEvent(this); // does not release previous pattern player
	}
	
}

+ Symbol {
	asPlayer { | player |
		^player.playSymbol(this); // like function
	}
}

SynthPlayer : SHPlayer {
	var <def, <controlNames, <hasGate = false;

	init {
		this.addNotifier (envir, name, { | command |
			this perform: command;
		});
	}

	isPlaying { ^synth.isPlaying }

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
		var target, server, outbus, args, busses;
		#args, busses = this.makeSynthArgs;
		switch (func.class,
			Function, {
				target = envir [\target].asTarget;
				server = target.server;
				this.def = func.asSynthDef (
					fadeTime: envir [\fadeTime] ? 0.02,
					name: SystemSynthDefs.generateTempName
				).add;
				synth = Synth.basicNew(def.name, server);
				outbus = envir [\outbus] ? 0; // TODO: remove \out, outbus from args and check
				def.doSend (
					server, // TODO: remove \out, outbus from args and check
					synth.newMsg(target, [\i_out, outbus, \out, outbus] ++ args,
						envir [\addAction] ? \addToHead);
				);
			},
			Symbol, {
				this.def = (SynthDescLib.at (func) ?? { SynthDescLib at: \default}).def;
				synth = Synth (
					def.name, args, target, envir [\addAction] ? \addToHead
				)
			},
			{
				def ?? {
					this.def = (SynthDescLib.at (func) ?? { SynthDescLib at: \default}).def;
				};
				synth = Synth (
					def.name, args, target, envir [\addAction] ? \addToHead
				)
			};
		);
		this.connectSynth (synth, busses);
	}

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

	connectSynth { | argSynth, busses |
		/* argSynth created by this.play
			1. Store it
			2. When it is really started, then:
			2.1 Connect to environment parameters according to controlNames
			2.2 Connect extra actions: restart, release, free, etc.
			2.3 Initialize auto-removal on end.
		*/
		synth = argSynth;
		synth.onStart (this, {
			this.changed(\started);
			/* If busses exist, then start the synth's gated envelope after mapping them */
			if (busses.size > 0) {
				busses keysValuesDo: { | key, value |
					// postf("mapping synth: %, param: % to bus: %\n", this, key, value);
					synth.map(key, value);
				};
				synth.set(\gate, 1);
			};
			(controlNames add: \gate) do: { | param |
				synth.addNotifier (envir, param, { | val, notification |
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
			synth.onEnd (this, {
				this.changed(\stopped);
				synth.objectClosed;
				synth = nil;
			});
		});
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