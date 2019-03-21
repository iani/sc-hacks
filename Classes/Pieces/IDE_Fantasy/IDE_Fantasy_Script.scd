// 21 Mar 2019 16:18
// { "testing".postln; } ! 50;
//:give basic feedback
// { "Starting sound script".postln; } ! 50;
//:

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
\pos <+.stanford1 '/pi5'.osc(6, [0, 4], [0.2, 5]);
\pan <+.stanford1 '/pi5'.osc(7, [-2, 2], [-1, 1]);
//:
// ================================================================
// Testing different pos range
// Perhaps corfu1 ? 
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
// Definitely stanford1 ? 
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
//:name control parameter more appropriately
/*
{
	SinOsc.ar(\freq.kr(400) + 100 * 5, 0, 0.1)
} +> \sinetest;
//map bus to new parameter name
\freq <+ \stanford1ax;
*/
//:name control parameter more appropriately
/*
{
	Mix(SinOsc.ar(
		[
			\freq.kr(400) + 100 * 5,
			\freq2.kr(400) + 100 * 5,
			\freq3.kr(400) + 100 * 5,
			\freq4.kr(400) + 100 * 5
			// \freq4.kr(400) + 100 * 5
		], 0, 0.1)
	)
} +> \sinetest;
//map bus to new parameter name
\freq <+ \stanford1ax;
\freq2 <+ \stanford1ay;
\freq3 <+ \stanford1az;
\freq4 <+ \stanford1mx;
//:
*/