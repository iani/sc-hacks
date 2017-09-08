// 24 Jun 2017 17:23 experimental.

// Play a pattern in the currentEnvironment - just setting its values
// From eventPatternEplay.sc

+ Symbol {
	eplay { | event, envir |
		//this.pattern;
		/* // this always crashes with infinite loop. no reason known.
		var previousPattern, newPattern;
		envir = envir.asEnvironment;
		event = event ?? { () };
		previousPattern = this.pattern (envir);
		if (previousPattern.isPlaying) { previousPattern.stop };
		event [\type] = \envEvent;
		event [\test] = { "testing".postln; 1 };
		event [\test2] = { ~envir.postln; 1 };
		postf ("my envir arg is now: %\n", envir);
		postf ("is it equal to currentenvir? %\n", envir === currentEnvironment);
		"it is. and I will put it in the event - prepare for crash".postln;
		event [\envir] = envir;
		event.postln;
		previousPattern.play (event);
		*/

		var previousPattern, newPattern;
		envir = envir.asEnvironment;
		event = event ?? { () };

		previousPattern = this.pattern (envir, event);
		previousPattern.postln;
		previousPattern.isPlaying.postln;
		if (previousPattern.isPlaying) {
			"will now stop previous pattern".postln;
			previousPattern.stop;
		};


		event [\envir] = envir;
		event [\type] = \envEvent;
		//		newPattern = EventPattern (()).play;		

		{ newPattern = EventPattern (event).play }.defer (3);
		/*
			newPattern = Registry (envir, this, {
		 	EventPattern (event).play;
		});
		// newPattern = this.pattern.play (event); // infinite loop crash! why?
		event.addNotifier (newPattern, \stopped, {
			newPattern.objectClosed;
		});
		event.addNotifier (newPattern, \userStopped, {
			newPattern.objectClosed;
		});		
		^newPattern;
		*/
	}
}
