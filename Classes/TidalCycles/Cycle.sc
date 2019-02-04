/* 
TydalCycle-style nested cyclic pattern scheduling in SuperCollider.
Implemented in several classes, incrementally, for clarity and educational purposes.
11 Jan 2019 12:10
*/


Beat {
	/*
		Top level cyclic beat.
		Schedules successive beats at a regular interval defined in variable period.
		At each beat, it sends "play" to each cycle element contained in variable "cycles".
		If the cycle element is a Cycle, it will play its next sub-element.
		If it is a CycleEvent, it will play the event.
	*/
	
	var <>period, <clock, <onsetTime;
	var <>cycles; // store here cycles to play them at each beat. 

	*new { | period, clock |
		^this.newCopyArgs(period, clock).init;
	}

	getPeriod {
		// used by Cycle to recursively update current period values
		^period;
	}

	init {
		period = period ? 1;
		clock = clock ?? { TempoClock(period, 0) };
		// start immediately
		this.play;
	}

	play {
		// first event plays immediately,
		// next events are schuled period seconds in the future.
		clock.sched(0, this.action);
	}

	action {
		^{
			postf("% starting cycles at: % beats\n", this, clock.beats);
			cycles do: _.play(this);
			period;
		}
	}
}

Cycle {
	/* Play a single period of a cycle.
		See CycleDrafts.sc for early drafts.
	*/

	var <subCycles; // array of Cycles or CycleEvents to be played 
	var <superCycle; // The Beat or Cycle that plays this cycle
	var period; /*  Duration of each event in this cycle
	  Calculated from superCycle.period / subCycles.size
	*/
	var <stream; // Stream of cycles produced from Pseq(subCycles, 1);
	var <playingCycle; // the currently playing subcycle.

	*new { | subCycles |
		^this.newCopyArgs(subCycles).init;
	}

	init {
		// create stream
		stream = Pseq(subCycles, 1).asStream;
	}
	
	play { | argSuperCycle |
		superCycle = argSuperCycle;
		this.getPeriod;
		this.sched;
	}
	
	getPeriod {
		// recursively update current period values
		^period = superCycle.getPeriod / subCycles.size;
	}

	sched {
		this.reset; // always start at the beginning of the stream
		superCycle.clock.sched(0, {
			playingCycle = stream.next;
			if (playingCycle.noNil) {
				playingCycle.play(this);
				period;
			}{} // nil stops scheduling
		})
	}
 
	reset { stream.reset }
	
}