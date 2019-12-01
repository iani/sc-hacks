/* 191130
A simple timer for measuring how long a process has run 
from the Time() till Command Period.

Broadcasts elapsed time since start via 
name.changed(minutes, seconds);

Variants or subclasses can be written to implement further
features.
//:
\test.addNotifier(\time, \time, { | mins, secs |
	[mins, secs].postln;
});
Time();
//:

*/

Time : Singleton {
	var <name, startTime = 0, stopTime, totalTime;
	var broadcaster; // broadcasting routine
	*new { | name = \time |
		^this.newCopyArgs(name.asSymbol).init;
	}

	init {
		startTime = Process.elapsedTime;
		this.addNotifier(CmdPeriod, \cmdPeriod, { this.stop });
		this.startBroadcasting;
	}

	stop {
		stopTime = Process.elapsedTime;
		totalTime = stopTime - startTime;
		postf("seconds: %, min:secs: %\n", totalTime, totalTime.formatTime);
		this.removeNotifier(CmdPeriod, \cmdPeriod);
		this.stopBroadcasting;
	}

	startBroadcasting {
		name.changed(\started);
		broadcaster = {
			var dt;
			inf do: { | i |
				dt = Process.elapsedTime - startTime;
				//                    mins        secs
				{ name.changed(\time, dt div: 60, dt % 60); }.defer;
				1.wait;
			}
			
		}.fork
		
	}

	stopBroadcasting {
		broadcaster.stop;
		name.changed(\stopped);
	}
}