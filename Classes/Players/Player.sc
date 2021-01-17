/*

Play a function, symbol, or event inside a Player.

Player sends playSource message to its sourcePlayer variable, which decides what to do depending on its Class and the class of the source to be played.

If the sourcePlayer is Nil, it creates a SynthPlayer or PatternPlayer, depending on the class of the source.

If the source is a PatternPlayer or SynthPlayer, it either returns itself, or a new PatternPlayer or SynthPlayer, depending on the class of the source.

Decision table for playSource method according to types of receiver and argument:

+---------------+----------+-------------------------+-------------------|
| receiver      | argument | method/action triggered | result returned   |
+---------------+----------+-------------------------+-------------------|
| Nil           | Function | makeSource              | new SythPlayer    |
| Nil           | Symbol   | makeSource              | new SynthPlayer   |
| Nil           | Event    | makeSource              | new PatternPlayer |
| SynthPlayer   | Function | clearPreviousSynth      | old SynthPlayer   |
| SynthPlayer   | Symbol   | clearPreviousSynth      | old SynthPlayer   |
| SynthPlayer   | Event    | clearPreviousSynth      | new PatternPlayer |
| PatternPlayer | Function | stop pattern            | new SynthPlayer   |
| PatternPlayer | Symbol   | stop pattern            | new SynthPlayer   |
| PatternPlayer | Event    | merge into pattern      | old PatternPlayer |
+---------------+----------+-------------------------+-------------------|

// ================================================================
// Part 1: Create a new SourcePlayer and play it.
// The Class of the source chooses the class of the SourcePlayer.
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
	
	sourcePlayer = sourcePlayer.playSource(this, (Function/Symbol/Event) source);
	must return a kind of SourcePlayer

	(Nil/SynthPlayer/PatternPlayer) playSource : Player:player, (Function/Symbol/Event):source
	Case analysis and pseudocode for the above combinations follows here: 

	2. Nil : playSource : player, (Function/Symbol/Event):source;
	source.playSource player
	See Function, Symbol, SynthDef, Event playSource below.

	3. SynthPlayer : playSource : player, (Function/Symbol/Event):source;
	always release your player.
	if source is kind of Event, create PatternPlayer and play it and return it.
	Else play function or symbol in self, and return self

	4. PatternPlayer : playSource  : player, (Function/Symbol/Event):source;
	never release your player.
	if source is kind of Event, merge it into your source and into your player
	and return self.
	Else  
	play function or symbol in self, and return self

	5. Function : playSource -> SynthDef playSource
	this.asSynthDef.playSource

	6. Symbol : playSource -> SynthDef asSourceplayer
	this.asSynthDef.playSource

	7. SynthDef : playSource
	create SynthPlayer and play it

	8. Event : playSource
	create PatternPlayer and play it
*/

Player {
	classvar all;
	var <envir, <name, <sourcePlayer;

	*initClass {
		// Add custom event type to Event class, to work with playEnvEvent
		Class.initClassTree(Event);
		Event.parentEvents.default.eventTypes [\envEvent] = #{|server|
			
			var envir;
			~freq = ~detunedFreq.value;

			// msgFunc gets the synth's control values from the Event
			~amp = ~amp.value;
			~sustain = ~sustain.value;
			envir = ~envir;
			// TODO: Review this.  If freq is set as pattern, then
			// setting degree in next event will not set freq to nil.
			// see notes TODO below in method playEnvEvent!
			~getMsgFunc.valueEnvir.valueEnvir;
			currentEnvironment['_keys_'] do: { | key |
				envir[key] = currentEnvironment[key].next;
			};
		};
	}

	*named { | name |
		^this.all detect: { | p | p.name === name }
	}
	
	*all { // return all Player instances
		^all ?? { this.getAll }
	}

	*getAll {
		all = Nevent.all.collect({|e| e.players.values.asArray }).flat;
		^all;
	}

	*new { | envir, name = \default |
		^this.newCopyArgs (envir, name)
	}

	getHistory {
		^Registry(\PlayerSnippets, name, {
			[
				SnippetHistory(
					name,
					PlayerSnippet(name, "\\default", PathName(this.autoPath(name)))
				)
			]
		});
	}

	autoPath { | argName |
		^this.class.autoPath(argName)
	}
	
	*autoPath { | argName |
		^PlayerSnippetList.rootDir +/+ "Auto" +/+ argName ++ ".scd"
		
	}
	persist {
		// make this player restart whenever groups are re-created.
		this.addNotifier(OrderedGroup, \groups, { this.play });
	}

	auto {
		// make this player restart when user calls Main:run
		// In emacs bindings this is with keyboard command C-c C-r
		this.addNotifier(Player, \run, { this.play });	
	}

	setSource { | source |
		// Create a sourceplayer from the source and store it in sourcePlayer.
		// But do not start the sourcePlayer;
		// Under development!
		sourcePlayer = source.makeSource(this);
		// debugging:
		// postf("My new sourceplayer is : %\n", sourcePlayer);
		// postf("My new sourceplayer's source is : %\n", sourcePlayer.source);
	}

	play { | source |
		// play a function, symbol, or event.
		// For definitions, see file playSource.sc
		var clock, beats;
		clock = envir[\clock];
		beats = envir[\beats] ?? { [\beat] };
		// TODO: review beats mechanism.
		if ( envir[\beats].isNil ) {
			sourcePlayer = sourcePlayer.playSource(this, source);	
		}{
			beats do: { | beat |
				this.addNotifier(clock, beat, {
					sourcePlayer = sourcePlayer.playSource(this, source);
				})
			};
			clock.play;
		}	
	}

	// allways restart after CmdPeriod
	fix {
		// delay 0.1 to ensure all necessary groups already exist.
		this.addNotifier(CmdPeriod, \cmdPeriod, {
			{ this.play; }.defer(0.1)
		});
	}

	// undo a fix
	unfix {
		this.removeNotifier(CmdPeriod, \cmdPeriod);
	}

	// fix - unfix all players
	*fix { all do: _.fix; }
	*unfix { all do: _.unfix; }
	
	playEnvEvent { | event |
		/*  Play event in a different way than a standard EventPattern:
			Prepare event to be played by changing keys in envir
			instead of creating its own synth events. */
		var keys;
		keys = event.keys.asArray;
		// provide freq if it is deduced from other keys via default event playing functions:
		
		// if (keys includes: \degree or: { keys includes: \note}) { keys add: \freq };
		// also erase freq or note if degree or note are provided -
		// to reset freq to original default func.

		// TODO: freq and note should be set to nil also in
		// the eventstreamplayer's event, if one is already playing in the player
		if (keys includes: \degree) {
			event.put(\freq, nil);
			event.put(\note, nil);
			keys add: \freq;
		};
		if (keys includes: \note) {
			event.put(\freq, nil);
			keys add: \freq;
		};
		
		event.put('_keys_', keys); // only these are updated in environment when playing.
		event.put(\type, \envEvent); // tell the event to play as envEvent.
		event.put(\envir, envir); // give access to self whne playing.
		this.play(event);
	}
	
	map { | param, index |
		// if sourcePlayer is a SynthPlayer and is playing, then
		// map param to bus of index.
		sourcePlayer !? { sourcePlayer.map(param, index) }
	}

	clear {
		// empty process of PatternPlayer
		sourcePlayer !? { sourcePlayer.clear }
	}

	push { envir.push; postf("pushed: %\n", this) }
	
	isPlaying {
		^sourcePlayer.isPlaying;
	}

	process {
		// If available, return the synth or EventStreamPlayer stored in sourcePlayer.
		// Else return nil.
		if (sourcePlayer.isNil) {
			^nil
		}{
			^sourcePlayer.process
		}
	}

	stop {
		sourcePlayer !? { sourcePlayer.stop }
	}

	toggle { | source |
		if (this.isPlaying) { this.stop } { this /* .push */ .play(source) };
	}

	put { | key, value |
		// used by Nevent:updateBusIndex.  SynthPlayer ignores this.
		sourcePlayer !? { sourcePlayer.put(key, value); }
	}

	setTarget { | orderedGroup |
		sourcePlayer !? { sourcePlayer.setTarget(orderedGroup); }
	}

	printOn { | stream |
		if (stream.atLimit) { ^this };
		stream << envir.name << "|" << name;
		envir.printItemsOn(stream);
	}

	// ================================================================
	// Synchronisation with clocks
	addClock { | playerClock |
		this.clock(playerClock ?? { PlayerClock() });
	}

	clock_ { | playerClock |
		envir[\clock] = playerClock;
	}

	clock { ^envir[\clock] }

	release { /// | fadeTime | not available see SynthPlayer
		//		postf("% releasing at %\n", this, fadeTime);
		sourcePlayer.release; // (fadeTime);
	}
}

+ Nil {
	playSource { | argPlayer, argSource | ^argSource.makeSource(argPlayer).play(argSource) }
}

+ Nil { makeSource { | player | ^SynthPlayer(player) } }
+ Function { makeSource { | player | ^SynthPlayer(player).setSource(this) } }
+ Symbol { makeSource { | player | ^SynthPlayer(player).setSource(this) } }
+ Event { makeSource { | player | ^PatternPlayer(player) } }

+ SynthPlayer {
	playSource { | argPlayer, argSource |
		switch (argSource.class,
			Event, {
				this.release;
				^PatternPlayer(argPlayer).play(argSource);
			},{
				this.play(argSource);				
			}
		)
	}
}

+ PatternPlayer {
	/* // moved to class code
	playSource { | argPlayer, argSource |
		switch (argSource.class,
			Event, {
				this.play(argSource)				
			},
			Nil, {
				process.play;
			},{
				this.release;
				^SynthPlayer(argPlayer).play(argSource);
			}
		)
	}
	*/
}
