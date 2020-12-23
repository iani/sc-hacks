//:First tries with Touch Designer - with Thomas Vallianatos
/* 10 Dec 2019 15:26

*/
//:+Simulating data to find command and parameter ranges.
var addr;
addr = NetAddr("192.168.29.28", 10000);
inf do: { | i |
	addr.sendMsg('/project1/oscin1'.postln, *Array.rand(3, 0, 0.99).postln).postln;
	//	addr.sendMsg('/project1/oscin1'.postln, *Array.rand(3, 0, 127).postln).postln;
	// addr.sendMsg('master/level', 1.0.rand).postln;
	// addr.sendMsg('master/red', 1.0.rand).postln;
	// addr.sendMsg('master/green', 1.0.rand).postln;
	// addr.sendMsg('master/blue', 1.0.rand).postln;
	0.250.wait;
};

//:+Simulating data to find command and parameter ranges.
var addr, stream;
addr = NetAddr("192.168.29.28", 10000);
stream = Pseq((0, 0.01 .. 1), inf).asStream;
inf do: { | i |
	addr.sendMsg('/project1/oscin1'.postln, *(stream.next.dup(3).postln));
	//	addr.sendMsg('/project1/oscin1'.postln,
	// *Array.rand(3, 0, 0.99).postln).postln;
	//	addr.sendMsg('/project1/oscin1'.postln, *Arcray.rand(3, 0, 127).postln).postln;
	// addr.sendMsg('master/level', 1.0.rand).postln;
	// addr.sendMsg('master/red', 1.0.rand).postln;
	// addr.sendMsg('master/green', 1.0.rand).postln;
	// addr.sendMsg('master/blue', 1.0.rand).postln;
	0.0250.wait;
};

//:Forwarding data from sensestage to current ip + port of Thomas.
var addr;
addr = NetAddr("192.168.29.28", 10000);
OSCFunc({ | msg |
	// msg.postln;
	addr.sendMsg('/project1/oscin1', *(msg[2..4].postln));
}, "/minibee/data", argTemplate: [1])