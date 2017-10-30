//  6 Oct 2017 20:22
// implement Symbol <+ MIDI
//:
MIDIClient.init;
//:
MIDIIn.connectAll;
//:
MIDIFunc.trace(true);
//:
MIDIFunc.trace(false);
//:
a = MIDIFunc.cc({ | ... args | args.postln;},
	1, 0
);
//:
a.free;
//:
1.cc;
//:
1.cc.asMIDIFunc;
//:
\freq <+ 1.cc;
//:
nil.free;
//:
a = \unipolar.asSpec;
a.map(0.5)

