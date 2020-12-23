//:demo pattern.stream 14 Dec 2019 22:07
{ SinOsc.ar(\freq.kr(1500), 0, \amp.kr(0.1)).stereo } +> \test;
//:
Pwhite(1000, 2000, inf).stream(\test, dt: 0.25);
//:
Pwhite(1000, 2000, inf).stream(\test,
	{ | val, player |
		player.set(\freq, val);
		postf("the value for freq was: %\n", val);
	}, [1.5, 0.2.pn(6), 0.1.pn(8)].prand;
);
//:add a second routine on the same environment, using a key.
// The previous routine, whih controls freq, keeps playing.
Pseq((0.01, 0.05 .. 0.5), inf).stream(\test,
	{ | val, player |
		player.set(\amp, val);
		postf("the value for amp was: %\n", val);
	}, 0.25, \amproutine
);