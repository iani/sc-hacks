// 13 Aug 2020 09:07
//:trace messages from server
OSCFunc.trace(true, true);
// test if booting happens reliably:
Que add: { Synth(\default) };
//:
Que.sendSync;
//:
Que.new.id;
//:
Que.new.prNext;

//:
{ | i | { Synth(\default, [freq: i * 100 + 1000, amp: 0.8]) }.sync; } ! 1;
//:
{ | i | { Synth(\default, [freq: i * 100 + 1000, amp: 0.8]) }.sync; } ! 2;
//:
{ | i | { Synth(\default, [freq: i * 100 + 1000, amp: 0.8]) }.sync; } ! 5;	
//: test if adding an action without server async will not block
Que add: { "just testing".postln; };
//: test adding an action several times.
3 do: { | i |
	Que add: { postf("Testing. Iteration count is: %\n", i + 1) };
}
//:
{ postf("Testing. Iteration count is: %\n", 1)}.sync;

//: test adding an action several times, large number of iterations.
300 do: { | i |
	Que add: { postf("Testing. Iteration count is: %\n", i + 1) };
}
//:Buffer.readSync tests
var path;
path =
"/home/iani/.local/share/SuperCollider/downloaded-quarks/Dirt-Samples/808/*.WAV"
.pathMatch.first;
~buffer = Buffer.readSync(Server.default, path);
// postf("buffer before sync: %\n", ~buffer);
// { postf("BUFFER AFTER SYNC: %\n", ~buffer) }.sync;
{ ~buffer.play }.sync;

//:
// 
Server.default.sendMsg('/sync', 1);
Que.sendSync;

{ OSCFunc.trace(false) }.defer(0.1);

//:
//:
Server.default.sendMsg('/sync', 1);
Que.sendSync;
//:
~buffer;
//:

//:
~buffer.play;
//:
var path;
path =
"/home/iani/.local/share/SuperCollider/downloaded-quarks/Dirt-Samples/808/*.WAV"
.pathMatch.first;
~buffer2 = Buffer.readSync(Server.default, path);
~buffer2 // .play;
//:
var path;
path =
"/home/iani/.local/share/SuperCollider/downloaded-quarks/Dirt-Samples/808/*.WAV"
.pathMatch.first;
~buffer2 = Buffer.readSync(Server.default, path);
{ ~buffer2.play }.sync;
//:
~buffer2.play;
//:
Server.default.addr.sendMsg('b_query', 0);