// script run at musrara only
/*
The scenes:

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
	var clients, sendColors;
	Nymphs.getClients;
	1.wait;
	clients = Nymphs.godotClients.values.asArray;
	postf("client names: %\nclient ips:%\n",
		Nymphs.godotClients.keys.asArray,
		Nymphs.godotClients.values.asArray
	);
	sendColors = { | colors |
		clients do: {  | addr |
			addr.sendMsg('/background', *colors);
			postf("% sent: %\n", addr, colors);
		};
		
	};
	"STARTING".postln;
	
		// addr = NetAddr("25.55.137.13", 14000);
		// addr.postln;

	60.wait;
	sendColors.(0.0, 0.3, 0.0);
	60.wait;
	sendColors.(0.0, 0.0, 0.3);

}.fork;
