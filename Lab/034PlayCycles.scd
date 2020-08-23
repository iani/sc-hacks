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
//:Test loading buffers with SD
SD.init;
//:
SD.buffers;
//:
SD.buffers[SD.buffers.keys.asArray.sort.first];
//
SD.buffers[SD.buffers.keys.asArray.sort.first].play;
//:+
10 do: {
	Synth("buf1",
		[bufnum: SD.buffers[SD.buffers.keys.asArray.sort.first].bufnum]
	);
	0.25.wait;
};
//:
Cyc.verbose = true;
//:
SD.first;
//:
~sdc = SDC(SD.first);
~sdc.play;
~sdc.add;
~sdc.cyclelength = 4;
~sdc.remove;
//:
SD.init;
//:
SD.gui;
//:
97.asAscii.asSymbol.asCompileString;
//:
~a;
//:
~a.toggle;
~b.toggle;
~b.offset = 1;
//;
Cyc.period = 0.1;
Cyc.period = 0.2;
Cyc.period = 0.25;
Cyc.period = 0.5;
Cyc.period = 1.5;
//;
~players do: {
	
	
};
//:
