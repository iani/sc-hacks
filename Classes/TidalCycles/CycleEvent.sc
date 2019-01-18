/*
Play a single Event.
*/

CycleEvent {
	var <event;

	*new { | event |
		^this.newCopyArgs(event);
	}

	play { | parentCycle |
		event.dur = parentCycle.period;
		event.play;
	}
	
}