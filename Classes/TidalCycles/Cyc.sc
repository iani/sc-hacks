/* 23 Aug 2020 06:36
Very simple class for playing samples in a cycle of beats.

Runs always.  Counts beats. 
*/

Cyc {
	classvar <>period = 0.25;
	classvar <>beat = 0;
	classvar <>verbose = true;
	*initClass {
		StartUp add: { this.start };
		CmdPeriod add: { this.start };
	}

	*start {
		AppClock.sched(0, {
			this.nextbeat;
			period;
		});
	}

	*nextbeat {
		if (verbose) { postf("testing Cyc. beat is: %\n", beat) };
		this.changed(\beatbeat);
		beat = beat + 1;
	}
	
	*reset {
		beat = 0;
	}

	
}