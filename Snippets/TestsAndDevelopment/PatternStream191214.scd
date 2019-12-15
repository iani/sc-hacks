//:demo pattern.stream 14 Dec 2019 22:07
{ SinOsc.ar(\freq.kr(1500), 0, 0.5).stereo } +> \test;
//:
Pwhite(1000, 2000, inf).stream(\test, dt: 0.25);
//:
Pwhite(1000, 2000, inf).stream(\test,
	{ | val, player |
		player.set(\freq, val);
		postf("the value was: %\n", val);
	}, [1.5, 0.2.pn(6), 0.1.pn(8)].prand;
);
//: