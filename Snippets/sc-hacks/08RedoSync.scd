//  8 Apr 2019 08:41
/*
Redo sync i.e. wait for message from server
*/
//:set up routine to wait for notification
{
	\something.yield;
	"Got past yield".postln;
	
}.fork.addNotifier(\someServer, \go, { | notification |
	notification.listener.next;
});
//:trigger next step in routine
\someServer changed: \go;
//:
SynthDef("test", {
	Out.ar(0, WhiteNoise.ar(0.01));
}).send(Server.default, '/blah')
//:
Buffer.alloc(Server.default, 44100 * 10);
//:Prepare server to notify routine
OSCFunc({
	//	Server.default.postln;
	// "Will have changed?".postln;
	Server.default.changed(\done);
}, '/done'); // do not add Server.default as address here!
//:check above - disabled
// Server.default addDependant: { | ... args | postf("server received: % \n", args); };
//:Prepare routine to listen to server
{
	loop {
		\something.yield;
		"one more done was received from server".postln
	}
}.fork.addNotifier(Server.default, \done, { | notification |
	notification.listener.next;
});
//:
SynthDef(Date.localtime.stamp.scramble, {
	Out.ar(0, WhiteNoise.ar(0.01));
}).send;
//