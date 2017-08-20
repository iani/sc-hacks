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
	var <busses;

	*new { | envir, name = \default |
		^this.newCopyArgs (envir, name);
	}

	play { | source |
		// For definitions, see file asSourcePlayer.sc
		sourcePlayer = sourcePlayer.asSourcePlayer(this, source);
	}

	busses {
		busses ?? { busses = ( )};
		^busses;
	}

	getBus { | controlName = \in, numChannels = 1 |
		// should be named getAudioBus ?
		^this.setBus(
			controlName,
			this.busses.atFail(
				controlName,
				{ bus = PersistentBus.audio(numChannels) }
			)
		)		
	}
}
