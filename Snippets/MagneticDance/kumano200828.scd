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
	[\y3, 2, 0.47, 0.53, 3],
	[\z3, 3, 0.47, 0.53, 3],
	[\x4, 1, 0.47, 0.53, 4], // using sensor module 3
	[\y4, 2, 0.47, 0.53, 4],
	[\z4, 3, 0.47, 0.53, 4]
);
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
//:================================================================
//:trying out some new synthdefs - from ikeda/takano
//:The original synthdef
{
	var env;
	env = Env.adsr;
	\amp.kr(1) *
	EnvGen.kr(env, \gate.kr(1), doneAction: 2) *
	Pan2.ar(
		SinOsc.ar(
			Resonz.ar(
				StandardL.ar(
					SampleRate.ir/50, 1),2000,0.1)*4000)
		, \pos.kr(0), \level.kr(1))
} +> \peb1;
//:peb1 with controls added
{
	var env;
	env = Env.adsr;
	\amp.kr(1) *
	EnvGen.kr(env, \gate.kr(1), doneAction: 2) *
	Pan2.ar(
		SinOsc.ar(
			Resonz.ar(
				StandardL.ar(
					SampleRate.ir/
					(\srdiv.kr(0.5) * 100 + 10)
					, 1),
				(\stdlfreq.kr(0.2) * 5000 + 10),
				\stdlbwr.kr(0.01) * 100 + 0.01)
			* (\resinmul.kr(0.1) + 50000 + 500)
		, \pos.kr(0), \level.kr(0.01))
} +> \peb1;
//:play the above softer
\level <+.peb1 0.01;
//:change + map some param values
//:change srdiv
\srdiv <+.peb1 0.05;
//:map srdiv
\peb1.map(\srdiv, \x1);
//:test changing sdlfreq
\stdlfreq <+.peb1 0.09;
//:map sdlfreq
\peb1.map(\stdlfreq, \y1);
//:test changing stdlbwr
// before adding scaling expression
\stdlbwr <+.peb1 10;
\stdlbwr <+.peb1 100;
\stdlbwr <+.peb1 0.01;
//:map stdlbwr
\peb1.map(\stdlfreq, \z1);
//:test changing resinmul
\resinmul <+.peb1 300;