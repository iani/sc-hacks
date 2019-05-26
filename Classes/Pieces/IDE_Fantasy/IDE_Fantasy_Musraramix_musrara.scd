// script run at musrara only

//testing
/*
loop {
	var addr, sendColors;
	addr = NetAddr("25.55.137.13", 14000);
	// addr.postln;
	sendColors = { | colors |
		addr.sendMsg('/background', *colors);
		postf("sent: %\n", colors);
	};

	1.wait;
	sendColors.(Array.rand(4, 0.0, 1.0));
	1.wait;
}.fork;
//:

NetAddr("25.55.137.13", 57120).sendMsg('/test');
*/


//:+
var clients;
Nymphs.getClients;
1.wait;
clients = Nymphs.godotClients.values.asArray;
loop {
	var addr, sendColors;
	// addr = NetAddr("25.55.137.13", 14000);
	// addr.postln;
	sendColors = { | colors |
		clients do: {  | addr |
			addr.sendMsg('/background', *colors);
			postf("% sent: %\n", addr, colors);
		};
		
	};

	1.wait;
	sendColors.(Array.rand(4, 0.0, 1.0));
	1.wait;
}.fork;
//:

NetAddr("25.55.137.13", 57120).sendMsg('/test');

//:*
/*
loop {
	var addr, sendColors;
	addr = NetAddr.localAddr;
	sendColors = { | colors |
		addr.sendMsg('/background', *colors);
		postf("sent: %\n", colors);
	};

	1.wait;
	sendColors.(Array.rand(4, 0.0, 1.0));
	1.wait;
}.fork;
*/