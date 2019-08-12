// The "set parameter" operator: <+
//:
\lamentodellaninfa.b.play;
//:Start a new synth
{
	var bnum, src, chain;
	bnum = \lamentodellaninfa.b.bufnum;
	src = \amp.kr(0.5) * GrainBuf.ar(1,
		Impulse.kr(\per.kr(0.2)),
		\dur.kr(4.5),
		bnum,
		\rate.kr(1),
		\pos.kr(0) * BufSampleRate.kr(bnum)
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BrickWall(chain, \thresh.kr(0.1, 0.5));
	Pan2.ar(IFFT(chain), \pan.kr(0));
	// src;
} +> \setexample;
//:
\per <+ 10;
//:change threshold parameter
\thresh <+ -0.5;
//:Use gui to control threshold parameter
\setexampleGui.v(
	\thresh.slider([-0.9, 0.9], \setexample)
);
//:Use gui to control threshold parameter
\setexampleGui.v(
	\amp.slider([0, 3], \setexample),
	\thresh.slider([-0.9, 0.9], \setexample)
);
//:Full gui for parameters of this player
\setexampleGui.v(
	\amp.slider([0, 3], \setexample),
	\per.slider([0.2, 20], \setexample),
	\dur.slider([0.1, 5], \setexample),
	\rate.slider([0.2, 5], \setexample),
	\pos.slider([0, 50], \setexample),
	\pan.slider([-1, 1], \setexample),
	\thresh.slider([-2, 1], \setexample)
);
//:connect player to OSC input
// Note that from-to mapping ranges are specified in the code
\per <+.setexample '/pi5'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.setexample '/pi5'.osc(1, [-1, 30], \amp);
\rate <+.setexample '/pi5'.osc(2, [-10, 40], [0.2, 1]);
\pos <+.setexample '/pi5'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.setexample '/pi5'.osc(7, [-2, 2], [-1, 1]);
\thresh <+.setexample '/pi5'.osc(8, [-2, 2], [-1, 1]);
//:
