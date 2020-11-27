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
	classvar <>verbose = false; // track 2 ways to calculate dt
	var <name, <startTime = 0, <stopTime, <totalTime;
	//	var <lastTime; // the last time waited // NOT NEEDED IN NEW APPROACH
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
		postf("Resetting %\n", this);
		startTime = Process.elapsedTime;
		// lastTime = 0; // At start of the timing process. 0 seconds elapsed
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
		this.stopBroadcasting; // stop previous broadcasting routine if running
		broadcaster = {
			var dt;
			inf do: { | i |
				dt = Process.elapsedTime - startTime;
				//                    mins        secs
				// { name.changed(\time, dt div: 60, dt % 60); }.defer;
				{ name.changed(\time, dt) }.defer;
				1.wait;
			}			
		}.fork
	}

	stopBroadcasting {
		broadcaster.stop;
		name.changed(\stopped);
		"The Timer stopped".postln;
	}

	await { | abstime = 1 |
		/*
			convert absolute wait time from start of piece
			to relative wait time, and call wait on relative time.
		*/
		var dt; // how much time do I have to wait relative to previous wait?
		// this approach will not work if there are t.wait statements
		// in the executed snippet:
		// dt = (abstime max: lastTime) - lastTime; // always wait till now or later
		// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		// try alternate approach for dt
		// "====== ALTERNATIVE APPROACH: calculating dt from start of piece!".postln;
		// this approach also works if there are relative wait statements
		// in the code of the executed snippet (t.wait):
		dt = abstime - (Process.elapsedTime - startTime);
		if (verbose) { this.postDetails(dt, abstime) };
		// lastTime = abstime; // this is no longer needed
		postf("Timer waiting % seconds till %\n", dt, abstime);
		dt.wait;
	}

	postDetails { | argDt, abstime |
		// ================================================================
		// COMPARING TWO APPROACHES: Calculate remainder
		// 1. from previous time waited
		// 2. from beginning of piece and now
		// no longer using approach 1:
		// postf("lastTime was %, time requested is %, dt is %\n",
		// lastTime, abstime, argDt);
		postf("start %, now %, elapsed %, requested %, dt %\n",
			startTime.round(0.00001), Process.elapsedTime.round(0.00001), 
			(Process.elapsedTime - startTime).round(0.00001), abstime,
			(abstime - (Process.elapsedTime - startTime)).round(0.00001)
		);
	}

	gui {
		{
			name.tr_(width: 400).v(
				HLayout(
					StaticText()
					.font_(GuiDefaults.font)
					.string_("mins"),
					NumberBox()
					.font_(GuiDefaults.font)
					.addNotifier(name, \time, { | val, n |
						{ n.listener.value = val div: 60; }.defer;
					}),
					StaticText()
					.font_(GuiDefaults.font)
					.string_("secs"),
					NumberBox()
					.font_(GuiDefaults.font)
					.addNotifier(name, \time, { | val, n |
						{ n.listener.value = val % 60; }.defer;
					})
				)
			)
		}.defer;
	}
}

+ SimpleNumber {
	await { | name = \time |
	/*
		convert absolute wait time from start of piece
		to relative wait time, and call wait on relative time.
		*/
		// WRONG!!!!! - ????????:
		// AbsWait.await(this);
		Time(name).await(this);
	}
}

+ Array {
	secs { // convert from minutes, seconds to seconds
		^this[0] * 60 + this[1]
	}
	await { // abswait for [minutes, seconds]
		this.secs.await;
	}
}