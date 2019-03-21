// 21 Mar 2019 16:18
// { "testing".postln; } ! 50;
//:give basic feedback
// { "Starting sound script".postln; } ! 50;
// ================================================================
//: Corfu 1
// ================================================================
{
	var bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	\amp.kr(0.1) * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum),
		pan: \pan.kr(0)
	)
} +> \corfu1;
//:
\corfu1.tr_(400, 300);
//:
\corfu1.v(
	\per.slider([0.2, 20], \corfu1),
	\dur.slider([0.1, 5], \corfu1),
	\amp.slider(\amp, \corfu1),
	\rate.slider([0.2, 5], \corfu1),
	\pos.slider([0, 5], \corfu1),
	\pan.slider([-1, 1], \corfu1)
);
//:
\per <+.corfu1 '/pi3'.osc(3, [-20, 40], [0.9, 10]);
\amp <+.corfu1 '/pi3'.osc(1, [-10, 40], \amp);
\dur <+.corfu1 '/pi3'.osc(1, [-10, 40], [0.1, 5]);
\rate <+.corfu1 '/pi3'.osc(2, [-40, 40], [0.9, 1.2]);
\pos <+.corfu1 '/pi3'.osc(6, [-10, 4], [0.2, 5]);
\pan <+.corfu1 '/pi3'.osc(7, [-2, 2], [-1, 1]);
//:
// ================================================================
//  Corfu 2 
// ================================================================
{
	var bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	\amp.kr(0.1) * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum),
		pan: \pan.kr(0)
	)
} +> \corfu2;
//:
\corfu2.v(
	\per.slider([0.2, 20], \corfu2),
	\amp.slider(\amp, \corfu2),
	\rate.slider([0.2, 5], \corfu2),
	\pos.slider([0, 50], \corfu2),
	\pan.slider([-1, 1], \corfu2)
);
//:
\per <+.corfu2 '/pi4'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.corfu2 '/pi4'.osc(1, [-10, 40], \amp);
\rate <+.corfu2 '/pi4'.osc(2, [-40, 40], [0.2, 2]);
\pos <+.corfu2 '/pi4'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.corfu2 '/pi4'.osc(7, [-2, 2], [-1, 1]);
//:
//:
// ================================================================
// Athens 1 
// ================================================================
{
	var bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	\amp.kr(0.1) * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum),
		pan: \pan.kr(0)
	)
} +> \athens1;
//:
\athens1.v(
	\per.slider([0.2, 20], \athens1),
	\amp.slider(\amp, \athens1),
	\rate.slider([0.2, 5], \athens1),
	\pos.slider([0, 50], \athens1),
	\pan.slider([-1, 1], \athens1)
);
//:
\per <+.athens1 '/pi1'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.athens1 '/pi1'.osc(1, [-10, 40], \amp);
\rate <+.athens1 '/pi1'.osc(2, [-10, 40], [0.8, 1.2]);
\pos <+.athens1 '/pi1'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.athens1 '/pi1'.osc(7, [-2, 2], [-1, 1]);
//:
//:
// ================================================================
// PV_below 
// Athens 2
// ================================================================
{
	var bnum, src, chain;
	bnum = \lamentodellaninfa.b.bufnum;
	src = \amp.kr(0.1) * GrainBuf.ar(1,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum)
		//	pan: \pan.kr(0)
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagBelow(chain, \thresh.kr(0.1));
	Pan2.ar(IFFT(chain), \pan.kr(0))
} +> \athens2;

//:
\athens2.v(
	\per.slider([0.2, 20], \athens2),
	\amp.slider(\amp, \athens2),
	\rate.slider([0.2, 5], \athens2),
	\pos.slider([0, 50], \athens2),
	\pan.slider([-1, 1], \athens2),
	\thresh.slider([0.01, 1], \athens2)
);
//:
\per <+.athens2 '/pi2'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.athens2 '/pi2'.osc(1, [-10, 40], \amp);
\rate <+.athens2 '/pi2'.osc(2, [-10, 40], [0.2, 1]);
\pos <+.athens2 '/pi2'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.athens2 '/pi2'.osc(7, [-2, 2], [-1, 1]);
\thresh <+.athens2 '/pi2'.osc(8, [-2, 2], [0.01, 1]);
//:
/*
//:
// ================================================================
// PV_above
// Stanford2
// ================================================================
{
	var bnum, src, chain;
	bnum = \lamentodellaninfa.b.bufnum;
	src = \amp.kr(0.1) * GrainBuf.ar(1,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum)
		//	pan: \pan.kr(0)
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagAbove(chain, \thresh.kr(0.1));
	Pan2.ar(IFFT(chain), \pan.kr(0))
} +> \stanford1;
//:
\thresh <+.stanford1 0.02;      
//:
\stanford1.v(
	\per.slider([0.2, 20], \stanford1),
	\amp.slider(\amp, \stanford1),
	\rate.slider([0.2, 5], \stanford1),
	\pos.slider([0, 50], \stanford1),
	\pan.slider([-1, 1], \stanford1),
	\thresh.slider([0.01, 1], \stanford1)
);
//:
\per <+.stanford1 '/pi5'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.stanford1 '/pi5'.osc(1, [-10, 40], \amp);
\rate <+.stanford1 '/pi5'.osc(2, [-10, 40], [0.2, 1]);
\pos <+.stanford1 '/pi5'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.stanford1 '/pi5'.osc(7, [-2, 2], [-1, 1]);
\thresh <+.stanford1 '/pi5'.osc(8, [-2, 2], [0.01, 1]);

*/

//:
// ================================================================
// PV_BrickWall
// Stanford 1
// ================================================================
{
	var bnum, src, chain;
	bnum = \lamentodellaninfa.b.bufnum;
	src = \amp.kr(0.1) * GrainBuf.ar(1,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum)
		//	pan: \pan.kr(0)
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BrickWall(chain, \thresh.kr(0.1, 0.5));
	Pan2.ar(IFFT(chain), \pan.kr(0))
} +> \stanford1;
//:
\stanford1.v(
	\per.slider([0.2, 20], \stanford1),
	\amp.slider(\amp, \stanford1),
	\rate.slider([0.2, 5], \stanford1),
	\pos.slider([0, 50], \stanford1),
	\pan.slider([-1, 1], \stanford1),
	\thresh.slider([-1, 1], \stanford1)
);
//:
\per <+.stanford1 '/pi5'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.stanford1 '/pi5'.osc(1, [-10, 40], \amp);
\rate <+.stanford1 '/pi5'.osc(2, [-10, 40], [0.2, 1]);
\pos <+.stanford1 '/pi5'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.stanford1 '/pi5'.osc(7, [-2, 2], [-1, 1]);
\thresh <+.stanford1 '/pi5'.osc(8, [-2, 2], [-1, 1]);
//:
