/// 28 Feb 2018 16:09
//: where is the dust instance created by SuperDust?
// Look in currentEnvironment
currentEnvironment;// not this then...
//: Note: Must run SuperDirtHack.start first, to initialize SuperDirt and load the buffers.
SuperDirt.default; 
//:
SuperDirtHack.default;
//: Lets find out how to access and play buffers from SuperDirt.
SuperDirt.default.buffers;
//:
SuperDirt.default.buffers.keys;
//:
SuperDirt.default.buffers.values;
//:
SuperDirt.default.buffers.values.flat.size;
//:
SuperDirt.default.buffers.values.flat do: _.postln;
//:
SuperDirt.default.buffers[\toys].size;
//:+
SuperDirt.default.buffers[\dr] do: { | b | b.postln.play; 5.wait };
"DONE".postln;
//:+
SuperDirt.default.buffers[\breaks157] do: { | b | b.postln.play; 5.wait };
"DONE".postln;
//:+
SuperDirt.default.buffers.values do: { | b | b.size.postln; 0.25.wait };
"DONE".postln;
//:+
SuperDirt.default.buffers keysValuesDo:  { | name, bufs | name.post; ' '.post; bufs.size.postln; 0.25.wait };
"DONE".postln;
//: Conclusion:
/* 
Buffers are accessed by name and then index, where index defaults to 0.
See: DirtEvent:splitName, DirtEvent:getBuffer
*/
