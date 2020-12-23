//:test watch method
BusOsc.watch(\test1,
	[\test, \pi1, 0, -10, 10]
);
//:+
var addr;
addr = NetAddr.localAddr;
loop {
	0.1.wait;
	addr.sendMsg(\pi1, -10.0 rrand: 10.0);
};
//:trying watch with sensestage osc message
BusOsc.watch(\thisissensestagetest,
	[\testbus1, '/minibee/data', 1, 0.5, 1.0],
	[\testbus2, '/minibee/data', 2, 0.5, 1.0],
	[\testbus3, '/minibee/data', 3, 0.5, 1.0]
);
//:trying watch1 with sensestage osc message
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\testbus1_x, 1, 0.0, 1.0, 1],
	[\testbus1_y, 2, 0.0, 1.0, 1],
	[\testbus1_z, 3, 0.0, 1.0, 1],
	[\testbus2_x, 1, 0.0, 1.0, 2],
	[\testbus2_y, 2, 0.0, 1.0, 2],
	[\testbus3_z, 3, 0.0, 1.0, 2]
);
//:recalibrate 1 trying watch1 with sensestage osc message
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\testbus1_x, 1, 0.3, 0.75, 1],
	[\testbus1_y, 2, 0.3, 0.75, 1],
	[\testbus1_z, 3, 0.3, 0.75, 1],
	[\testbus2_x, 1, 0.3, 0.75, 2],
	[\testbus2_y, 2, 0.3, 0.75, 2],
	[\testbus3_z, 3, 0.3, 0.75, 2]
);
//:recalibrate 2 trying watch1 with sensestage osc message
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\testbus1_x, 1, 0.47, 0.53, 1],
	[\testbus1_y, 2, 0.47, 0.53, 1],
	[\testbus1_z, 3, 0.47, 0.53, 1],
	[\testbus2_x, 1, 0.47, 0.53, 2],
	[\testbus2_y, 2, 0.47, 0.53, 2],
	[\testbus3_z, 3, 0.47, 0.53, 2]
);
//:Test mapping from above with sound
{ WhiteNoise.ar(\amp.kr()).stereo } +> \test1;
//:
\test1.ppp.set(\amp, 0.14)
//:
\test1.ppp.map(\amp, \testbus1_x.bus);
//:
{ GrayNoise.ar(0.1).stereo } +> \x;