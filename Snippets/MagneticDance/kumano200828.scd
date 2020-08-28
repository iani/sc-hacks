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
			// * (\resinmul.kr(0.1) + 50000 + 500)
			* (\resinmul.kr(0.1) * 50000 + 500)
		)
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
\resinmul <+.peb1 1.0;
//:map resinmul
\peb1.map(\resinmul, \x2);
//:all the above mappings together
\peb1.map(\srdiv, \x1);
\peb1.map(\stdlfreq, \y1);
\peb1.map(\stdlfreq, \z1);
\peb1.map(\resinmul, \x2);
//:================ PEB
//: PEB ORIGINAL CODE
{ | bus = 50 |
	Mix.fill(8, {
		var fb, env, fq, osc;
		fb = (LFSaw.ar(
			Latch.ar(
				WhiteNoise.ar(0.5).abs
				+ 0.5,
				InFeedback.ar(bus,1)),1)+0.999)/2;
		Out.ar(bus, fb);
		env = 1-fb;
		fq = Latch.ar(WhiteNoise.ar(
			\noise.kr(1000))
			+ \noisep.kr(6000), fb);
		osc = SinOsc.ar(SinOsc.ar(fq*5/3,0,env**2*10000,fq),0,LPF.ar(env,100));
		Out.ar(0, \amp.kr(1)*Pan2.ar(osc,Latch.ar(WhiteNoise.ar(1),fb),0.05))})
} +> \pebproto ;
// next need to add controls for noise, noisep, fadd, ldiv
// adding these one by one to be able to start sound right away
//: PEB + noise param control
{ | bus = 50 |
	Mix.fill(8, {
		var fb, env, fq, osc;
		fb = (LFSaw.ar(
			Latch.ar(
				WhiteNoise.ar(0.5).abs
				+ 0.5,
				InFeedback.ar(bus,1)),1)
			+ (\fadd.kr(0.05) * 5 + 0.1 )
		) / (\ldiv.kr(0.5) * 10 + 0.3);
		Out.ar(bus, fb);
		env = 1-fb;
		fq = Latch.ar(WhiteNoise.ar(
			\noise.kr(0.5) * 10000 + 10)
			+ (\noisep.kr(0.6) + 10000 + 10), fb);
		osc = SinOsc.ar(SinOsc.ar(fq*5/3,0,env**2*10000,fq),0,LPF.ar(env,100));
		Out.ar(0, \amp.kr(1)*Pan2.ar(osc, Latch.ar(WhiteNoise.ar(1),fb),0.05))})
} +> \pebproto ;
//:


//: PEB MODIFIED FOR USE WITH SENSORS
// does NOT WORK - NEED TO MODIFY ABOVE GRADUALLY TO MAKE SOUND RIGHT AWAY
{ | bus = 50 |
	Mix.fill(8, {
		var fb, env, fq, osc;
		fb = (LFSaw.ar(
			Latch.ar(
				WhiteNoise.ar(\wnmul.kr(0.5)).abs
				+ \wnadd.kr(0.5),
				InFeedback.ar(bus,1)), 1) +
			(\fadd.kr(0.05) * 5 + 0.1)) /
			(\ldiv.kr(0.5) * 10 + 0.3);
			Out.ar(bus, fb);
			env = 1-fb;
			fq = Latch.ar(WhiteNoise.ar(
				(\noise.kr(1000) * 10000 + 10) )
				+ (\noisep.kr(6000) * 10000 + 10), fb);
			osc = SinOsc.ar(SinOsc.ar(fq*5/3,0,env**2*10000,fq),0,LPF.ar(env,100));
			Out.ar(0, \amp.kr(0.2) *
				Pan2.ar(osc, Latch.ar(WhiteNoise.ar(1), fb), 0.05))
	})
} +> \peb;
//;test noise par
//:before scaling
\noise <+.peb 100; // 10 - 10000
\noisep <+.peb 50000; // 10 - 10000
//:after scaling
\noise <+.peb 0.2;
\noise <+.peb 0.01;
\noise <+.peb 0.99;
\noisep <+.peb 0.2;
\noisep <+.peb 0.01;
\noisep <+.peb 0.99;
\fadd <+.peb 0.05; // 0.1 - 5
\fadd <+.peb 0.99; // 0.1 - 5
\ldiv <+.peb 0.03; // 0.3 - 10
\ldiv <+.peb 0.99; // 0.3 - 10

//:test wnmul, wnadd, fadd, ldiv
\wnmul <+.peb 10.0; // no effect? /// DO NOT USE
\wnadd <+.peb 0.0; // no effect? /// DO NOT USE
\fadd <+.peb 5; // 0.1 - 5
\ldiv <+.peb 0.3; // 0.3 - 10
//:MAP ALL CONTROLS HERE: noise, noisep, fadd, ldiv
\peb.map(\noise, \x3);
\peb.map(\noisep, \y3);
\peb.map(\fadd, \z3);
\peb.map(\ldiv, \x4);


//:================================================================
//:sound check
\default +> \check;
\freq <+.check 200;
