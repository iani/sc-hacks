/* 23 Aug 2020 06:36
Test simple Cycle class for playing samples in a cycle of beats.
*/
//:Prototype to test scheduling
var period = 0.25, beat = 0;
AppClock.sched(0, {
	postf("beat: %\n", beat);
	beat = beat + 1;
	period;
});
//:
Cyc.start;
Cyc.verbose = false;
//:
\test.addNotifier(Cyc, \beat, { | beat | postf("testing: %\n", beat % 12) });
//:
\test.removeNotifier(Cyc, \beat);
//:
SD.init;