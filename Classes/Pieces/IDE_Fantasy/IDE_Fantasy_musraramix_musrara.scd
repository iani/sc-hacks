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
	var clients, sendColors, scenes, minsec; //, durationArray, durations;
	var startTime;
	1.wait;
	Nymphs.getClients;
	1.wait;
	clients = Nymphs.godotClients.values.asArray;
	clients = clients add: NetAddr("127.0.0.1", 14000);
	postf("GODOT client names: %\nclient ips:%\n",
		Nymphs.godotClients.keys.asArray,
		Nymphs.godotClients.values.asArray
	);
	postln("\n=================== THE CLIENTS ARE: ===================\n");
	clients do: _.postln;
	"\n================= END OF CLIENT LIST ==================\n\n\n".postln;
	sendColors = { | colors |
		clients do: {  | addr |
			addr.sendMsg('/background', *colors);
			// postf("% sent: %, %\n", addr, '/background', colors);
		};
	};
	minsec = { | dur |
		dur = dur.round(0.1);
		format("% min, % sec", (dur / 60).floor.asInteger, dur % 60);
	};
	scenes = [
		[20, "1a dafnis", [0.9, 0.0, 0.0]], // 1a  meet dafnis solo
		[20, "1b chloe", [0.0, 0.9, 0.0]], // 1b  meet chloe solo
		[20, "1c priest", [0.0, 0.0, 0.9]], // 1c  meet priest solo
		[120, "2 dafnis meets chloe", [0.3, 0.3, 0.0]], // 2   dafnis meets chloe
		[60, "3 priest in village", [0.0, 0.0, 0.3]], // 3   priest enters solo
		[120, "4 priest meets chloe", [0.0, 0.3, 0.3]], // 4   priest meets chloe
		[60, "5 priest prays for chloe", [0.0, 0.0, 0.5]], // 5   priest prays for chloe
		[120, "6 chloe dressed as dafnis", [0.2, 0.3, 0.0]], // 6   chloe dressed as dafnis
		[120, "7 chloe alone", [0.0, 0.3, 0.0]], // 7   chloe solo
		[120, "8 chloe becomes dafnis", [0.3, 0.3, 0.0]], // 8   chloe transforms into dafnis
		[120, "9 chloe as dafnis", [0.3, 0.1, 0.0]], // 9   chloe as dafnis
	];
	//	durationArray = [20, 20, 20, 120, 60, 120, 60, 120, 120, 120, 120, 120,];
	// durations = Pseq(durationArray, inf).asStream;
	"STARTING\n".postln;
	startTime = Process.elapsedTime;
	scenes do: { | sceneEvent |
		var duration, scene, colors;
		#duration, scene, colors = sceneEvent;
		postf("Time: %, scene: %, duration: %, colors: %\n",
			minsec.(Process.elapsedTime - startTime),
			scene, duration, colors
		);
		sendColors.(colors);
		duration.wait;
	};
	"\n\n================================================================\n".postln;
	postf("THE END\nTotal time: %\n",
		minsec.(Process.elapsedTime - startTime)
	);
}.fork;
//:


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