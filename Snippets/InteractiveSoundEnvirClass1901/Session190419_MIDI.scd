// 19 Apr 2019 16:26 - MIDI
// Do the next 2 steps one after the other
// (not at the same time)
//:Connect to existing midi devices
MIDIClient.init;
//:Connect MIDI INPUT to all midi devices
MIDIIn.connectAll;
//:Print all incoming midi messages
MIDIFunc.trace(true);
//:Switch midi printing off after you have seen what you need.
MIDIFunc.trace(false);
//:Function for MIDI in on channel 0, number 1
f = MIDIFunc.cc({ | ... args |
	"This is what midi ctl 1 on channel 0 sent me:".postln;
	args.postln;
	// ctl number, channelNumber 
},   1,             0);
//:remove previous midi cc function to overwrite
f.free;
//:Function for MIDI in on channel 0, number 1
f = MIDIFunc.cc({ | value |
	"This is what midi ctl 1 on channel 0 sent me:".postln;
	\freq <+.test ((value / 127) * 10000 + 200);
	// ctl number, channelNumber 
},   1,             0);
//:Make the above function survive command-period (stop)
f = MIDIFunc.cc({ | value |
	//:	"This is what midi ctl 1 on channel 0 sent me:".postln;
	\freq <+.test ((value / 127) * 10000 + 200);
	// ctl number, channelNumber 
},   1,             0).permanent;
//:
{ SinOsc.ar(\freq.kr(440), 0, 0.1) } +> \test;