\lsm0.v(
	\freq.slider(\freq, \lsm0),
	\amp.slider(\amp, \lsm0),
	\rate.slider([0.2, 5], \lsm0)
);
//:
\freq <+.lsm0 '/gyroscope0'.osc(0, [-40, 40], \freq);
\amp <+.lsm0 '/gyroscope0'.osc(1, [-40, 40], \amp);
\rate <+.lsm0 '/gyroscope0'.osc(2, [-40, 40], [0.2, 5]);
//:
{
	SinOsc.ar(\freq.kr(400), 0, \amp.kr(0.1))
} +> \lsm0;
//:
{
	SinOsc.ar(\freq.kr(400) * [0.975, 1] * 1.5, 0, mul: \amp.kr(0.1))
	* Decay2.kr(Impulse.kr(\rate.kr(1) * 0.01))
} +> \lsm0;
//:preload lamentodellaninfa sample
\lamento.loadBuffer("/Users/iani/Music/sounds/sounds-md/lamentodellaninfa.wav");
//:
{
	GrainBuf.ar(
		2,
		Impulse.kr(\gps.kr(1)),
		\dur.kr(1),
		sndbuf: \lamento.b.bufnum,
		rate: \rate.kr(1) / 3,
		pos: \pos.kr(0),
		interp: 2,
		pan: \pan.kr(0)
	)	
} +> \lsm0;
//:
\lsm0.v(
	\dur.slider([0.1, 2], \lsm0),
	\pos.slider([0.0, 1.0], \lsm0),
	\rate.slider([0.2, 5], \lsm0),
	\gps.slider([0.5, 20.0], \lsm0)
);
//:
\dur <+.lsm0 '/gyroscope0'.osc(0, [-40, 40], [0.1, 2.5]);
\pos <+.lsm0 '/gyroscope0'.osc(1, [-40, 40], [0.0, 1.0]);
\rate <+.lsm0 '/gyroscope0'.osc(2, [-40, 40], [0.2, 5]);
\gps <+.lsm0 '/magnetometer0'.osc(2, [-1.0, 0.5], [0.2, 5]);