/* 23 Aug 2020 06:36
Very simple class for playing samples in a cycle of beats.

Runs always.  Counts beats. 
*/

Cyc {
	classvar <>period = 0.25, periodPat;
	classvar <>beat = 0, beatPat;
	classvar <>verbose = false; // true;
	*initClass {
		StartUp add: { this.start };
		CmdPeriod add: { this.start };
	}

	*start {
		AppClock.sched(0, {
			this.nextbeat;
			period.next; // works also with streams
		});
	}

	*nextbeat {
		if (verbose) { postf("testing Cyc. beat is: %\n", beat) };
		this.changed(\beat, beat);
		beat = beat + 1;
	}
	
	*reset {
		beat = 0;
	}
}