//:*
~addr = NetAddr("25.55.137.13", 14000);
// ~addr.sendMsg('/background', 0.1, 0.1, 0.9, 1);

// ~addr.sendMsg('/scriptLabel', "Scene 1: Daphnis meets Chloe");
// ~addr.sendMsg('/pi1', 3, 0, 0, 0, 0, 0, 0, 0);

//~addr.sendMsg('/pi2', 0, 0, 0, 0, 0, 0, 0, 0);
// //:+

(-30..30) do: { | i |
      ~addr.sendMsg('/pi2', i * 2, 0, 0, 0, 0, 0, 0, 0, 0);
      i.postln;
      0.1.wait;
}

//:PI5 ================
/*
pi5 : orange
pi5 index 0 = horizontal position x
pi5 index 1 = vertical position y
pi5 index 2 = depth position z


x range: -50 * 2 - 10 * 2
y range:  -15 * 2 - 15 * 2.
z range: -20 - 20

*/
// ONLY ADJUST X FOR PI1 PI2:
//:PI1:

x = -10 x 2 - 50 x 2
//:
~data = nil;
//:Record data to find ranges
~data;
OSCFunc({ | msg |
	~data = ~data add: msg;
}, '/pi5');
//:
~data[1];
~data.flop[1]
//:
~data.size;
//:
~data.flop[1].maxItem;
~data.flop[1].minItem;
//:
var coords;
coords = ~data.flop;
~maxmin = (1..3) collect: { | i |
	[coords[i].reject({ | x | x < -50 }).minItem, coords[i].reject({ | x | x > 50 }).maxItem]
}
//:
~data.flop[2].plot;