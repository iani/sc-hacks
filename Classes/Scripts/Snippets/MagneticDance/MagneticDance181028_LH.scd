\lsm1.v(
	\freq.slider(\freq, \lsm1),
	\amp.slider(\amp, \lsm1),
	\rate.slider([0.2, 5], \lsm1)
);
//:
\freq <+.lsm1 '/gyroscope1'.osc(0, [-40, 40], \freq);
\amp <+.lsm1 '/gyroscope1'.osc(1, [-40, 40], \amp);
\rate <+.lsm1 '/gyroscope1'.osc(2, [-40, 40], [0.2, 5]);
//:
{
	SinOsc.ar(\freq.kr(400), 0, \amp.kr(0.1))
} +> \lsm1;
//:
{
	var src;
	src = SinOsc.ar(\freq.kr(400) * [1, 1.15, 1.2, 1.3, 1.5] * 0.125, 0, mul: \amp.kr(0.1))
	* Decay2.kr(Impulse.kr(\rate.kr(1) * 0.152));

	src;
	Mix(src)
} +> \lsm1;
//:preload lamentodellaninfa sample
\lamento.loadBuffer("/Users/iani/Music/sounds/sounds-md/lamentodellaninfa.wav");
//:preload lamentodellaninfa sample
\vento.loadBuffer("/Users/iani/Music/sounds/sounds-md/lamentodellaninfa.wav");
//:grain synth
{
	GrainBuf.ar(
		2,
		Impulse.kr(\gps.kr(1) * 1),
		\dur.kr(1) * 0.5,
		sndbuf: \lamento.b.bufnum,
		rate: \rate.kr(1) / 2.5,
		pos: \pos.kr(0),
		interp: 2,
		pan: \pan.kr(0)
	)	
} +> \lsm1;
//:grain synth gui
\lsm1.v(
	\dur.slider([0.1, 2], \lsm1),
	\pos.slider([0.0, 1.0], \lsm1),
	\rate.slider([0.2, 5], \lsm1),
	\gps.slider([0.5, 20.0], \lsm1)
);
//:grain synth connection
\dur <+.lsm1 '/gyroscope1'.osc(0, [-40, 40], [0.1, 2.5]);
\pos <+.lsm1 '/gyroscope1'.osc(1, [-40, 40], [0.0, 1.0]);
\rate <+.lsm1 '/gyroscope1'.osc(2, [-40, 40], [0.2, 5]);
\gps <+.lsm1 '/magnetometer1'.osc(2, [-1.0, 0.5], [0.2, 5]);
