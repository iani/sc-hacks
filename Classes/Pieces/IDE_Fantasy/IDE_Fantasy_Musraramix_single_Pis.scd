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
	\thresh.slider([0.1, 2], \priest)
);
// connect to OSC
// //:connect to OSC
\per <+.priest '/pi5'.osc(3, [-40, 10], [0.2, 5]);
\per <+.priest '/pi5'.osc(3, [-40, 10], [0.2, 5]);
\dur <+.priest '/pi5'.osc(1, [-10, 40], [2, 5]);
\amp <+.priest '/pi5'.osc(4, [-10, 40], \amp);
\rate <+.priest '/pi5'.osc(2, [-20, 20], [0.25, 1.2]);
// rate for chloe
// \rate <+.priest '/pii5'.osc(2, [-20, 20], [1, 1.2]);
\pos <+.priest '/pi5'.osc(6, [-10, 4], [0.2, 5]);
\thresh <+.priest '/pi5'.osc(7, [-2, 5], [0.25, 1.9]);

//:PRIEST sound: granulation + binshift
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

//:================ ECHO ================
\echo.br_(400, 300);
\echo.v(
	\per.slider([0.2, 20], \echo),
	\dur.slider([2, 5], \echo),
	// \amp.slider([0.00, 3.5], \echo),
	\amp.slider(\amp, \echo),
	\rate.slider([0.2, 5], \echo),
	\pos.slider([0, 5], \echo),
	\pan.slider([-1, 1], \echo),
	\thresh.slider([0, 30], \echo)
);
//connect to OSC
// per for dafnis and priest
\per <+.echo '/pi5'.osc(3, [-40, 10], [0.2, 5]);
\dur <+.echo '/pi5'.osc(1, [-10, 40], [2, 5]);
\amp <+.echo '/pi5'.osc(4, [-10, 40], \amp);
// rate for chloe
/// \rate <+.echo '/pi5'.osc(2, [-20, 20], [1, 1.2]);
\rate <+.echo '/pi5'.osc(2, [-5, 20], [0.75, 1.5]);
\pos <+.echo '/pi5'.osc(6, [-10, 4], [0.2, 5]);
\pan <+.echo '/pi5'.osc(7, [-2, 2], [-1, 1]);
// thresh for ECHOST
// \thresh <+.echo '/pi5'.osc(5, [-20, 40], [0.01, 10.99]);
// thresh echo try 2
\thresh <+.echo '/pi5'.osc(5, [-20, 40], [0.01, 10.99]);
//: thresh echo try 3
// \thresh <+.echo '/pi5'.osc(3, [-20, 40], [0.9, 10]);


//:granulation + magabove - trying different effect
// ECHO
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
	chain = PV_MagAbove(chain, \thresh.kr(0.1, 0.5));
	Pan2.ar(IFFT(chain), \pan.kr(0))
} +> \echo;

//:================ DAFNIS ================
\dafnis.bl_(400, 300);
\dafnis.v(
	\per.slider([0.2, 20], \dafnis),
	\dur.slider([2, 5], \dafnis),
	// \amp.slider([0.00, 3.5], \dafnis),
	\amp.slider(\amp, \dafnis),
	\rate.slider([0.2, 5], \dafnis),
	\pos.slider([0, 5], \dafnis),
	\pan.slider([-1, 1], \dafnis),
	\thresh.slider([-1.0, 1.0], \dafnis)
);
//:Connect to OSC
\per <+.dafnis '/pi5'.osc(3, [-40, 10], [0.2, 5]);
\dur <+.dafnis '/pi5'.osc(1, [-10, 40], [2, 5]);
\amp <+.dafnis '/pi5'.osc(4, [-10, 40], \amp);
\rate <+.dafnis '/pi5'.osc(2, [-20, 20], [0.7, 1.0]);
\pos <+.dafnis '/pi5'.osc(6, [-10, 4], [0.2, 5]);
\pan <+.dafnis '/pi5'.osc(7, [-2, 2], [-1, 1]);
// thresh for DAFNIS
// \thresh <+.dafnis '/pi5'.osc(5, [-20, 40], [-0.98, 0.21]);
// \thresh <+.dafnis '/pi5'.osc(5, [-20, 40], [0.75, 1.21]);
// thresh for PRIEST
// \thresh <+.dafnis '/pi5'.osc(5, [-20, 40], [0.75, 1.21]);
// thresh for DAFNIS
// \thresh <+.dafnis '/pi5'.osc(5, [-20, 40], [0.01, 10.99]);
// thresh dafnis try 2
\thresh <+.dafnis '/pi5'.osc(5, [-20, 40], [-0.9, 0.39]);

//:DAFNIS granulation + brickwall
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
} +> \dafnis;
