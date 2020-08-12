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
//:

Synth("default");

//:
Server.default.waitForBoot({ "BOOTED".postln })
//:================================================================
// Comparing with sync, sendMsgSync examples from doc
// Can the same effect be obtained without Routine and Condition?
// (I think it can.)
//:================================================================
//:Original code from https://doc.sccode.org/Classes/Server.html#-sendMsgSync
Routine.run {
    var c;

    // create a condition variable to control execution of the Routine
    c = Condition.new;

    s.bootSync(c);
    \BOOTED.postln;

    s.sendMsg("/b_alloc", 0, 44100, 2);
    s.sendMsg("/b_alloc", 1, 44100, 2);
    s.sendMsg("/b_alloc", 2, 44100, 2);
    s.sync(c);
    \b_alloc_DONE.postln;
};
//:adding OSCFunc trace:
Routine.run {
    var c;

    // create a condition variable to control execution of the Routine
    c = Condition.new;

    s.bootSync(c);
    \BOOTED.postln;
	OSCFunc.trace(true);
    s.sendMsg("/b_alloc", 0, 44100, 2);
    s.sendMsg("/b_alloc", 1, 44100, 2);
    s.sendMsg("/b_alloc", 2, 44100, 2);
    s.sync(c);
    \b_alloc_DONE.postln;
	0.1.wait;
	OSCFunc.trace(false);
};
//:using code from NetAddr:makeSyncResponder
/* Instead of using condition to wait, we put the 
action to be synced in the sync responder.
The plan is to make condition and routine obsolete,
while using the responder to trigger the next actions.
*/
/*
	makeSyncResponder { arg condition;
		var id = UniqueID.next;
		var resp = OSCFunc({|msg|
			if (msg[1] == id) {
				resp.free;
				condition.test = true;
				condition.signal;
			};
		}, '/synced', this);
		condition.test = false;
		^id
	}

*/
Routine.run {
    var c, id, resp;

    // create a condition variable to control execution of the Routine
    c = Condition.new;

    s.bootSync(c);
    \BOOTED.postln;
	OSCFunc.trace(true);

	id = UniqueID.next;
	resp = OSCFunc({|msg|
		if (msg[1] == id) {
			resp.free;
			//	condition.test = true;
			// condition.signal;
			\b_alloc_DONE.postln;
		};
	}, '/synced');
	
    s.sendMsg("/b_alloc", 0, 44100, 2);
    s.sendMsg("/b_alloc", 1, 44100, 2);
    s.sendMsg("/b_alloc", 2, 44100, 2);
    // s.sync(c);
    // \b_alloc_DONE.postln;
	s.sendMsg("/sync", id);
	0.1.wait;
	OSCFunc.trace(false);
}
