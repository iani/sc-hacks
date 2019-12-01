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

AbsWait : Singleton {
	/*
		convert absolute wait time from start of piece
		to relative wait time, and call wait on relative time.
	*/
	var previousTime = 0;

	abswait { | abstime = 1 |
		var reltime;
		abstime = abstime max: previousTime; // prevent abstime before previousTime;
		reltime = abstime - previousTime;
		previousTime = abstime;
		postf("will wait till % seconds (%)\n", abstime, abstime.longFormatTime);
		reltime.wait;
		postf("waited % seconds. Time now:%\n", reltime, abstime.longFormatTime);
	}
}

+ SimpleNumber {
	abswait {
	/*
		convert absolute wait time from start of piece
		to relative wait time, and call wait on relative time.
	*/
		AbsWait.abswait(this);
	}
}

+ Array {
	secs { // convert from minutes, seconds to seconds
		^this[0] * 60 + this[1]
	}
	abswait { // abswait for [minutes, seconds]
		this.secs.abswait;
	}	
}