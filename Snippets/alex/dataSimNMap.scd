//:
var addr = NetAddr.localAddr;

Pwhite(0.4, 0.6, inf).stream(\test,
	{ | val, player |
		addr.sendMsg('/minibee/data', 1, val);
		//	postf("the value for freq was: %\n", val);
	}//, [1.5, 0.2.pn(6), 0.1.pn(8)].prand;
	0.1
);

//:
var addr = NetAddr.localAddr;

Ptuple({
	Pwhite(0.4, 0.6, inf);	
} ! 3, inf).stream(\test,
	{ | val, player |
		addr.sendMsg('/minibee/data', 1, *val);
	},
	0.1
);

//:
var addr = NetAddr.localAddr;

Ptuple({
	Pseq((1.0, 1.01..100), inf);	
} ! 3, inf).stream(\test,
	{ | val, player |
		addr.sendMsg('/minibee/data', 1, *val);
	},
	0.01
);

//:

Mapper.setSpec(\sensor1, \x, { |val| val.sin.linlin(-1, 1, 1, 100)});
//:

var addr = NetAddr.new("127.0.0.1", 51000);
OSCFunc({ |msg|
	var x, y, z;
	#x, y, z = msg[2..]; //
	addr.sendMsg('/sensor1',
		Mapper.map(x, \sensor1, \x).postln;
	)
}, '/minibee/data', argTemplate: [1]);

//:

"i start here".postln;
1.wait;
"onesec late".postln;
3.wait;
"three sec later".postln;
10.await;
"this is running at tenth sec abs time".postln;

 