//  6 Oct 2017 20:22
// implement Symbol <+ MIDI
//:
MIDIFunc.trace(true);
//:
MIDIFunc.trace(false);
a = MIDIFunc.cc({ | ... args | args.postln;},
	1, 0
);
//:
a.free;
//:
