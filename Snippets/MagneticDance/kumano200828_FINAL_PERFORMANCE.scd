//:setup sensors
/* open gui and start writing to busses
x1-x4 ... z1-z4.

*/
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\x1, 1, 0.47, 0.53, 1],
	[\y1, 2, 0.47, 0.53, 1],
	[\z1, 3, 0.47, 0.53, 1],
	[\x2, 1, 0.47, 0.53, 2], // using sensor module 3
	[\y2, 2, 0.47, 0.53, 2],
	[\z2, 3, 0.47, 0.53, 2],
	[\x3, 1, 0.47, 0.53, 3],
	// [\y3, 2, 0.47, 0.53, 3],
	// [\z3, 3, 0.47, 0.53, 3],
	[\x4, 1, 0.47, 0.53, 4], // using sensor module 3
	// [\y4, 2, 0.47, 0.53, 4],
	// [\z4, 3, 0.47, 0.53, 4]
);
//: ================================================================
// ================ TESTS ================
//:test if bus values are being written
\x1.get; // bus value range is ca 0 .. 1.0
//:run first simple sound check.
{
	SinOsc.ar(\freq.kr(0.5) * \fmul.kr(5000) + \fadd.kr(100),
		0, \amp.kr(0.1)
	)
} +> \test;
//:test amplitude
\amp <+ 0.2;
//:map frequency to x1 bus written by minibee sensor above.
\test.map(\freq, \x1);
// ================================================================
// THE SYNTH FOR THE PERFORMANCE
// controls for noise, noisep, fadd, ldiv, fqmul, oscamp
{ | bus = 50 |
	Mix.fill(8, {
		var fb, env, fq, osc;
		fb = (LFSaw.ar(
			Latch.ar(
				WhiteNoise.ar(0.5).abs
				+ 0.5,
				InFeedback.ar(bus,1)),1)
			+ (\fadd.kr(0.05) * 5 + 0.1 ) //  add * 5 ??? 
		) / (\ldiv.kr(0.5) * 1.0 + 1.3);
		Out.ar(bus, fb);
		env = 1-fb;
		fq = Latch.ar(WhiteNoise.ar(
			\noise.kr(0.5) + 1 ** 15 + 10)
			+ (\noisep.kr(0.6) + 1 ** 15 + 10), fb);
		osc = SinOsc.ar(SinOsc.ar(fq*
			//5/3,
			(\fqmul.kr(0.5) * 10 + 5/3),
			0,
			env**2*
			// 10000,
			(\oscamp.kr(0.5) * 10000 + 10),
			fq),0,LPF.ar(env,100));
		Out.ar(0, \amp.kr(1)*Pan2.ar(osc, Latch.ar(WhiteNoise.ar(1),fb),0.05))})
} +> \peb;
//:MAPPING - MADE FOR WORK WITH 2 PLAYERS
// JUN: 4 SENSORS, 2 PER HAND
\peb.map(\noise, \x1); // VERTICAL UP-DOWN MOVEMENT SENSIBILITY
\peb.map(\noisep, \x2);
\peb.map(\fqmul, \y1); // WRIST ROTATION MOVEMENT SENSIBILITY
\peb.map(\oscamp, \y2);
// ASAYO: 2 SENSORS, 1 PER HAND.
\peb.map(\fadd, \x3); // VERTICAL UP-DOWN MOVEMENT SENSIBILITY
\peb.map(\ldiv, \x4);

//;test noise par
//:before scaling
\noise <+.peb 100; // 10 - 10000
\noisep <+.peb 50000; // 10 - 10000
//:after scaling
\noise <+.peb 0.5;
\noise <+.peb 0.01;
\noise <+.peb 0.99;
\noisep <+.peb 10.9;
\noisep <+.peb 0.01;
\noisep <+.peb 0.99;
\fadd <+.peb 0.0; // 0.1 - 5
\fadd <+.peb 0.; // 0.1 - 5
\ldiv <+.peb 0.9; // 0.3 - 10
\ldiv <+.peb 0.99; // 0.3 - 10

//:test wnmul, wnadd, fadd, ldiv
\wnmul <+.peb 10.0; // no effect? /// DO NOT USE
\wnadd <+.peb 0.0; // no effect? /// DO NOT USE
\fadd <+.peb 5; // 0.1 - 5
\ldiv <+.peb 0.3; // 0.3 - 10


//:================================================================
//:sound check
\default +> \check;
\freq <+.check 200;

//:
Server.default.record;

Server.default.stopRecording;
