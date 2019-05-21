// 19 May 2019 19:11 Version for Musraramix (190530)
// 20 May 2019 14:24 Cleanup of design session with Natali on 19 May.
//:================ PRIEST ================
// prepare gui
\priest.tr_(400, 300);
\priest.v(
	\per.slider([0.2, 20], \priest),
	\dur.slider([2, 5], \priest),
	// \amp.slider([0.00, 3.5], \priest),
	\amp.slider(\amp, \priest),
	\rate.slider([0.2, 5], \priest),
	\pos.slider([0, 5], \priest),
	\pan.slider([-1, 1], \priest),
	\thresh.slider([0.1, 20], \priest)
);
// connect to OSC
// //:connect to OSC
\per <+.priest '/pi1'.osc(3, [-40, 10], [0.2, 5]);
\per <+.priest '/pi1'.osc(3, [-40, 10], [0.2, 5]);
\dur <+.priest '/pi1'.osc(1, [-10, 40], [2, 5]);
\amp <+.priest '/pi1'.osc(4, [-10, 40], \amp);
\rate <+.priest '/pi1'.osc(2, [-20, 20], [0.25, 1.2]);
// rate for chloe
// \rate <+.priest '/pii5'.osc(2, [-20, 20], [1, 1.2]);
\pos <+.priest '/pi1'.osc(6, [-10, 4], [0.2, 5]);
\pan <+.priest '/pi1'.osc(7, [-2, 2], [-1, 1]);

//:PRIEST granulation + binshift
{
	var src, chain, bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	src = \amp.kr(0.1, 1.0) * 1.5 * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5) * 2,
		bnum,
		\rate.kr(2, 1.0),
		\pos.kr(0, 1.0) * BufSampleRate.kr(bnum)
		//		pan: \pan.kr(0) // moved pan after FFT
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BinShift(chain, \thresh.kr(0.1, 0.5));
	Pan2.ar(IFFT(chain), \pan.kr(0))
	// src
} +> \priest;
//:Find initial settings
\thresh <+.priest 5;

//:================ ECHO ================

\bufplay.tr_(400, 300);
\bufplay.v(
	\per.slider([0.2, 20], \bufplay),
	\dur.slider([2, 5], \bufplay),
	// \amp.slider([0.00, 3.5], \bufplay),
	\amp.slider(\amp, \bufplay),
	\rate.slider([0.2, 5], \bufplay),
	\pos.slider([0, 5], \bufplay),
	\pan.slider([-1, 1], \bufplay),
	\thresh.slider([-1, 1], \bufplay)
);
//:connect to OSC
// per for dafnis and priest
\per <+.bufplay '/pi2'.osc(3, [-40, 10], [0.2, 5]);
\per <+.bufplay '/pi2'.osc(3, [-40, 10], [0.2, 5]);
// dur for dafnis and priest
\dur <+.bufplay '/pi2'.osc(1, [-10, 40], [2, 5]);
// \amp <+.bufplay '/pi2'.osc(4, [-10, 40], [0.00, 3.5]);
\amp <+.bufplay '/pi2'.osc(4, [-10, 40], \amp);
// rate for dafnis and priest
// \rate <+.bufplay '/pi2'.osc(2, [-20, 20], [0.25, 1.2]);
// rate for chloe
\rate <+.bufplay '/pi2'.osc(2, [-20, 20], [1, 1.2]);
\pos <+.bufplay '/pi2'.osc(6, [-10, 4], [0.2, 5]);
\pan <+.bufplay '/pi2'.osc(7, [-2, 2], [-1, 1]);
// thresh for DAFNIS
// \thresh <+.bufplay '/pi1'.osc(5, [-20, 40], [-0.98, 0.21]);
// \thresh <+.bufplay '/pi1'.osc(5, [-20, 40], [0.75, 1.21]);
// thresh for PRIEST
// \thresh <+.bufplay '/pi1'.osc(5, [-20, 40], [0.75, 1.21]);
// thresh for ECHO
// \thresh <+.bufplay '/pi2'.osc(5, [-20, 40], [0.01, 10.99]);
// thresh echo try 2
\thresh <+.bufplay '/pi2'.osc(5, [-20, 40], [5.01, 30.99]);

//:granulation + brickwall for duo
// DAFNIS
{
	var src, chain, bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	src = \amp.kr(0.1, 1.0) * 1.5 * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5) * 2,
		bnum,
		\rate.kr(2, 1.0),
		\pos.kr(0, 1.0) * BufSampleRate.kr(bnum)
		//		pan: \pan.kr(0) // moved pan after FFT
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BrickWall(chain, \thresh.kr(0.1, 0.5));
	Pan2.ar(IFFT(chain), \pan.kr(0))
} +> \bufplay;
