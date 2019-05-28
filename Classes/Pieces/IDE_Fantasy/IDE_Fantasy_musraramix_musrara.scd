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

IDE_Fantasy.boot;
IDE_Fantasy start: \musrara;
*/

/*

| ! | Number | Seconds | Action                   | Daphnis | Chloe | Priest |
|---+--------+---------+--------------------------+---------+-------+--------|
|   |      1 |      60 | Intro of characters      | x       | x     | x      |
| # |      2 |      60 | Daphnis meets Chloe      | x       | x     | -      |
| # |      3 |      60 | Priest at the Village    | -       | -     | x      |
| # |      4 |      60 | Priest meets Chloe       | -       | x     | x      |
| # |      5 |      60 | Priest prays for Chloe   | -       | -     | x      |
| # |      6 |     120 | Chloe dressed as Daphnis | x       | x     | x      |
| # |      7 |      60 | Chloe solo               | x-      | x     | -      |
| # |      8 |      60 | Chloe transforms (Echo)  | x       | x     | x      |
| # |      9 |      60 | Chloe as daphnis         | x       | x     | -      |
|---+--------+---------+--------------------------+---------+-------+--------|
|   |        |     600 |                          |         |       |        |
|   |        |      10 |                          |         |       |        |
#+TBLFM: $2=@-1 + 1::@2$2=1::@11$3=vsum(@I..@II)::@12$3=@-1 / 60
*/

//:
{
	var clients, sendColors, colors;
	1.wait;
	Nymphs.getClients;
	1.wait;
	clients = Nymphs.godotClients.values.asArray;
	postf("GODOT client names: %\nclient ips:%\n",
		Nymphs.godotClients.keys.asArray,
		Nymphs.godotClients.values.asArray
	);
	sendColors = { | colors |
		clients do: {  | addr |
			addr.sendMsg('/background', *colors);
			postf("% sent: %\n", addr, colors);
		};
		
	};
	colors = Pseq([
		[0.0, 0.0, 0.0], // 1
		[0.3, 0.3, 0.0], // 2
		[0.0, 0.0, 0.3], // 3
		[0.0, 0.3, 0.3], // 4
		[0.2, 0.3, 0.5], // 5
		[0.2, 0.3, 0.0], // 6
		[0.0, 0.3, 0.0], // 7
		[0.3, 0.3, 0.0], // 8
		[0.3, 0.0, 0.0], // 9
	], inf).asStream;
	"STARTING".postln;
	loop {
		0.5.wait;
		sendColors.(colors.next);
		0.5.wait;
	}
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