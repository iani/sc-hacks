/* 23 Aug 2020 06:36
Very simple class for playing samples in a cycle of beats.

Runs always.  Counts beats. 
*/

Cyc {
	classvar <>period, periodPat;
	classvar <>beat, beatPat;
	classvar <>verbose = false; // true;
	classvar <thisPeriod, <thisBeat; // give insight to the present state
	*initClass {
		this.periodPat = 0.25;
		this.beatPat = Pseries();
		StartUp add: { this.start };
		CmdPeriod add: { this.start };
	}

	*periodPat_ { | pattern |
		periodPat = pattern;
		period = pattern.asStream;
	}

	*beatPat_ { | pattern |
		beatPat = pattern;
		beat = pattern.asStream;
	}
	
	*start {
		AppClock.sched(0, {
			this.nextbeat;
			thisPeriod = period.next; // works also with streams
		});
	}

	*nextbeat {
		this.changed(\beat, thisBeat = beat.next);
		if (verbose) {
			postf("Cyc: period: %, beat: %\n", thisPeriod, thisBeat)
		};
	}
	
	*reset {
		beat = 0;
	}
}