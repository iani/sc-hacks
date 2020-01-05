// Trying new operator for shortcut
// connecting kr synths to sensors and busses.
//: Start the sensor to bus mapping
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\x1, 1, 0.47, 0.53, 1],
	[\y1, 2, 0.47, 0.53, 1],
	[\z1, 3, 0.47, 0.53, 1],
	[\x2, 1, 0.47, 0.53, 2], // using sensor module 3
	[\y2, 2, 0.47, 0.53, 2],
	[\z2, 3, 0.47, 0.53, 2],
	[\x3, 1, 0.47, 0.53, 3],
	[\y3, 2, 0.47, 0.53, 3],
	[\z3, 3, 0.47, 0.53, 3],
	[\x4, 1, 0.47, 0.53, 4], // using sensor module 3
	[\y4, 2, 0.47, 0.53, 4],
	[\z4, 3, 0.47, 0.53, 4]
);
//:* test osc tracking
NetAddr.localAddr.sendMsg('/minibee/data', 1, *Array.rand(3, 0.49, 0.5).postln);
0.05.wait;
//:test tone
{ SinOsc.ar(\freq.kr(400), 0, 0.01).stereo } +> \test;
//:test mapping
{ \x1.kr(0.5).urange(400, 2000) } @@>.test \freq;