/* 191130
A simple timer for measuring how long a process has run 
from the Time() till Command Period.
Can be modified to run multiple timers, also to display
elapsed time for one or multiple processes.

Variants or subclasses can be written to implement further
features.
*/

Time : Singleton {
	var startTime = 0;
	var stopTime, totalTime;
	*new {
		^super.new.init;
	}

	init {
		startTime = Process.elapsedTime;
		this.addNotifier(CmdPeriod, \cmdPeriod, { this.stop });
	}

	stop {
		stopTime = Process.elapsedTime;
		totalTime = stopTime - startTime;
		postf("seconds: %, min:secs: %\n", totalTime, totalTime.formatTime);
		this.removeNotifier(CmdPeriod, \cmdPeriod);
	}
}