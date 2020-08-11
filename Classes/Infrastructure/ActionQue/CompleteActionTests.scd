/* 11 Aug 2020 19:31
It says completionMessage.
Can it be a function? Always?  Is it always evaluated 
after completion of the server load action?

*/
OSCFunc.trace(true);
OSCFunc.trace(false);
c//the function is evaluated to get the completion message - before loading
//: [/done, /b_alloc, n] 
Buffer.alloc(Server.default, 100, completionMessage: { | b |
	postf("allocated: %", b)});
//: [/done, /b_alloc, n] 
Buffer.alloc(Server.default, 1000000, completionMessage: \blabhlab);
//: [/done, /b_allocRead, n]
Dialog.openPanel({ | path |
	Buffer.read(Server.default, path);
})
//: [/done, /d_recv ]
SynthDef("tet", {
	Out.ar(0, SinOsc.ar(400, 0, 0.2))
}).add;
//:================================================================
// going deeper: watching individual buffer and def numbers in
// messages received from the server
OSCFunc({ | ... args | args.postln; }, '/done').permanent = true;
//:
Buffer.alloc(Server.default, 100);
