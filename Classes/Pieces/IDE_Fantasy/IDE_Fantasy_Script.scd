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
} +> \stanford1;
//:
\stanford1.tr_(400, 300);
//:
\stanford1.v(
	\per.slider([0.2, 20], \stanford1),
	\dur.slider([0.1, 5], \stanford1),
	\amp.slider(\amp, \stanford1),
	\rate.slider([0.2, 5], \stanford1),
	\pos.slider([0, 5], \stanford1),
	\pan.slider([-1, 1], \stanford1)
);
//:
\per <+.stanford1 '/pi5'.osc(3, [-20, 40], [0.9, 10]);
\amp <+.stanford1 '/pi5'.osc(1, [-10, 40], \amp);
\dur <+.stanford1 '/pi5'.osc(1, [-10, 40], [0.1, 5]);
\rate <+.stanford1 '/pi5'.osc(2, [-40, 40], [0.9, 1.2]);
\pos <+.stanford1 '/pi5'.osc(6, [-10, 4], [0.2, 5]);
\pan <+.stanford1 '/pi5'.osc(7, [-2, 2], [-1, 1]);
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
} +> \stanford1;
//:
\stanford1.v(
	\per.slider([0.2, 20], \stanford1),
	\amp.slider(\amp, \stanford1),
	\rate.slider([0.2, 5], \stanford1),
	\pos.slider([0, 50], \stanford1),
	\pan.slider([-1, 1], \stanford1)
);
//:
\per <+.stanford1 '/pi5'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.stanford1 '/pi5'.osc(1, [-10, 40], \amp);
\rate <+.stanford1 '/pi5'.osc(2, [-40, 40], [0.2, 2]);
\pos <+.stanford1 '/pi5'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.stanford1 '/pi5'.osc(7, [-2, 2], [-1, 1]);
//:
//:
// ================================================================
// Testing different rate range
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
} +> \stanford1;
//:
\stanford1.v(
	\per.slider([0.2, 20], \stanford1),
	\amp.slider(\amp, \stanford1),
	\rate.slider([0.2, 5], \stanford1),
	\pos.slider([0, 50], \stanford1),
	\pan.slider([-1, 1], \stanford1)
);
//:
\per <+.stanford1 '/pi5'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.stanford1 '/pi5'.osc(1, [-10, 40], \amp);
\rate <+.stanford1 '/pi5'.osc(2, [-10, 40], [0.2, 1]);
\pos <+.stanford1 '/pi5'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.stanford1 '/pi5'.osc(7, [-2, 2], [-1, 1]);
//:
//:
// ================================================================
// PV_below 
// stanford1 
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
