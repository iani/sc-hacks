/*
Drafts written before 18 Jan 2019 11:27 to develop Beat and Cycle classes.
*/

Cycle01 {
	// Early prototype. 
	// Just repeat a cycle
	// See subclasses for more.
	var <period, <clock;
	
	*new { | period, clock |
		^this.newCopyArgs(period, clock).init;
	}

	init {
		period = period ? 1;
		clock = clock ?? { TempoClock(period, 0) };
	}

	play { this.sched }

	sched {
		// first event plays immediately,
		// next events are schuled period seconds in the future.
		clock.sched(0, this.action);
	}

	action {
		^{
			postf("% starting cycles at: % beats\n", this, clock.beats);
			period;
		}
	}
}

Cycle02 : Cycle01 {
	// Permit unscheduling and playing of nested patterns.
	var <pattern;
	var <stream; // produces items to play
	var <nowPlaying; // currently playing element

	*new { | pattern, period, clock |
		^this.newCopyArgs(period, clock, pattern).init;
	}

	play { | argPattern |
		pattern = argPattern;
		stream = pattern.asStream;
		this.sched;
	}
	
	action {
		^{
			nowPlaying = stream.next;
			postf("% posts and plays next element in stream: %\n", this, nowPlaying);
			nowPlaying.play;
			if (nowPlaying.isNil) {
				nil;
			}{
				period;
			}
		}
	}
}

Cycle03 : Cycle02 {
	// Prepare playing nested cycles
	var <parent;
	
	cycle { | argParent |
		// calculate period from parent + size of own pattern
		// testing first without any extra code:
		parent = argParent;
		this.play;
	}
}