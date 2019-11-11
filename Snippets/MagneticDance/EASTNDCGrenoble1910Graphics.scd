/*
Graphics protocol:
/vden0 /vden1 density
/vrot0 /vrot1 rotation
/vcol0 /vcol1 color

*/
//:* Graphics test
var pat, addr;
pat = Ptuple({Pbrown(0.9, 1.0, 0.01, inf)} ! 6).asStream;
addr = NetAddr("127.0.0.1", 14000);
inf do: {
	var data;
	data = pat.next; // .postln;
	addr.sendMsg('/vden0', data[0].postln);
	//	addr.sendMsg('/vrot0', data[1].postln);
	addr.sendMsg('/vcol0', data[2].postln);
	addr.sendMsg('/vden1', data[0].postln);
	//	addr.sendMsg('/vrot1', data[1].postln);
	addr.sendMsg('/vcol1', data[2].postln);
	0.02.wait;
};
//:*
(0.0, 0.01 .. 1) do:
{ | i |
	NetAddr("127.0.0.1", 14000).sendMsg('/vrot1', i);
	NetAddr("127.0.0.1", 14000).sendMsg('/vrot0', 1);
	0.01.wait;
}
//:
var spec, vaddr;
spec = ControlSpec(-8, 8);
vaddr = NetAddr("127.0.0.1", 14000);
OSCFunc({ | msg |
	vaddr.sendMsg('/msg0',
		// spec.unmap(msg[1])
		msg[1]
	);
}, '/pi1');
