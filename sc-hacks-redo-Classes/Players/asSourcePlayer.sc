/* 21 Aug 2017 02:00

*/

// ================================================================
// Part 1: Create a new SourcePlayer and play it.
// The Class of the source chooses the class of the SourcePlayer.


+ Nil {
	asSourcePlayer { | player, source |
		^source.asSourcePlayer(player)		
	}
}

+ Function {

	asSourcePlayer { | player |
		^SynthPlayer(player, this);
	}
}

+ Event {
	asSourcePlayer { | player |
		^PatternPlayer(player, this); // does not release previous pattern player
	}
}

+ Symbol {
	asSourcePlayer { | player |
		^SynthPlayer(player, this); // like function
	}
}

// ================================================================
// Part 2: Release or modify an existing SourcePlayer,
// and return a new instance of different class if required.

+ SynthPlayer {
	// Always first clear previous synth, stopping self.
	// Then:
	// If argSource is Event, then stop self and return PatternPlayer.
	// Else play source in self.
		
	
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
}

+ PatternPlayer {
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
}