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
	var <envir, <name, <sourcePlayer;
	var busses;

	*new { | envir, name = \default |
		^this.newCopyArgs (envir, name);
	}

	play { | source |
		// play a function, symbol, or event.
		// For definitions, see file playSource.sc
		sourcePlayer = sourcePlayer.playSource(this, source);
	}

	busses {
		busses ?? { busses = ( )};
		^busses;
	}

	getBus { | controlName = \in, numChannels = 1 |
		// should be named getAudioBus ?
		var bus;
		^this.busses.atFail(
			controlName,
			{
				bus = PersistentBus.audio(numChannels);
				busses[controlName] = bus;
				bus;
			}
		)		
	}
}
