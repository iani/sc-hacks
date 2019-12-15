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

Time {
	var <name, <startTime = 0, <stopTime, <totalTime;
	var <lastTime; // the last time waited
	var broadcaster; // broadcasting routine
	*new { | name = \time |
		^Registry(this, name, {
			this.newCopyArgs(name.asSymbol).init;
		})
	}

	elapsedTime {
		^Process.elapsedTime - startTime;
	}

	init {
		this.reset;
		this.addNotifier(CmdPeriod, \cmdPeriod, { this.stop });
	}

	reset {
		startTime = Process.elapsedTime;
		lastTime = 0; // At start of the timing process. 0 seconds elapsed
		this.startBroadcasting;
	}

	stop {
		stopTime = Process.elapsedTime;
		totalTime = stopTime - startTime;
		postf("seconds: %, min:secs: %\n", totalTime, totalTime.formatTime);
		this.removeNotifier(CmdPeriod, \cmdPeriod);
		this.stopBroadcasting;
		this.remove; // remove instance, forcing future instances to re-init
	}

	remove {
		Registry.remove(this.class, name);	
	}

	startBroadcasting {
		// this routine is only for watching the timer in displays etc.
		// it does not do any timing!
		name.changed(\started);
		broadcaster.stop; // stop previous broadcasting routine if running
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
		"The Timer stopped".postln;
	}

	abswait { | abstime = 1 |
		/*
		convert absolute wait time from start of piece
		to relative wait time, and call wait on relative time.
		*/
		var dt; // how much time do I have to wait relative to previous wait?
		dt = (abstime max: lastTime) - lastTime; // always wait till now or later
		lastTime = abstime;
		postf("Timer waiting % seconds\n", dt);
		dt.wait;
	}
}

// WRONG!!!! ????????
// AbsWait : Singleton {
	/*
		convert absolute wait time from start of piece
		to relative wait time, and call wait on relative time.
	*/
/*
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
*/

+ SimpleNumber {
	abswait { | name = \time |
	/*
		convert absolute wait time from start of piece
		to relative wait time, and call wait on relative time.
		*/
		// WRONG!!!!! - ????????:
		// AbsWait.abswait(this);
		Time(name).abswait(this);
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