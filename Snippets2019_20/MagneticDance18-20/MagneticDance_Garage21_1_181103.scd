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
		Impulse.kr(\gps.kr(1) * 2),
		\dur.kr(1) * 0.5,
		sndbuf: \lamento.b.bufnum,
		rate: \rate.kr(1) / 2.5,
		pos: \pos.kr(0),
		interp: 2,
		pan: \pan.kr(0)
	) * \amp.kr
} +> \lsm1;
//:grain synth gui
\lsm1.v(
	\dur.slider([0.1, 12], \lsm1),
	\pos.slider([0.0, 1.0], \lsm1),
	\rate.slider([0.2, 15], \lsm1),
	\gps.slider([0.5, 20.0], \lsm1),
	\pan.slider([-1, 1.0], \lsm1),
	\amp.slider(\amp, \lsm1)
);
//:grain synth connection
\dur <+.lsm1 '/gyroscope1'.osc(0, [-40, 40], [0.01, 12.5]);
\pos <+.lsm1 '/gyroscope1'.osc(1, [-20, 40], [0.0, 1.0]);
\rate <+.lsm1 '/gyroscope1'.osc(2, [-20, 40], [0.1, 15]);
\gps <+.lsm1 '/magnetometer1'.osc(0, [-1.0, 0.5], [0.2, 15]);
\pan <+.lsm1 '/magnetometer1'.osc(1, [-0.25, 0.25], [-1, 1]);
\amp <+.lsm1 '/magnetometer1'.osc(2, [-0.05, 0.25], \amp);
//:simpler sound
{
	SinOsc.ar(
		[Lag.kr(\freq.kr),
			Lag.kr(\freq2.kr)
		]
			, 0, 0.1)
} +> \lsm1;
//:simple gui
\lsm1.v(
	\freq.slider(\freq, \lsm1),
	\freq2.slider(\freq, \lsm1)
);
//:simple controller - twist
\freq <+.lsm1 '/gyroscope1'.osc(0, [-10, 40], \freq.asSpec);
/*
twist of hand
*/
//:simple controller hand up down vertical
\freq2 <+.lsm1 '/gyroscope1'.osc(1, [-10, 40], \freq.asSpec);
/*
twist of hand
*/
//:simple controller up down or twist
\freq2 <+.lsm1 '/gyroscope1'.osc(2, [-10, 20], \freq.asSpec);
/*
twist of hand
*/
//:Test with 2 hands
{
	SinOsc.ar(
		[Lag.kr(\freq.kr),
			Lag.kr(\freq2.kr)
		]
			, 0, 0.1)
} +> \lsm1;
{
	SinOsc.ar(
		[Lag.kr(\freq.kr),
			Lag.kr(\freq2.kr)
		]
			, 0, 0.1)
} +> \lsm0;
//:simple gui 2 hands
\lsm1.v(
	\freq.slider(\freq, \lsm1),
	\freq2.slider(\freq, \lsm1)
);
\lsm0.v(
	\freq.slider(\freq, \lsm0),
	\freq2.slider(\freq, \lsm0)
);
//:simple controller - twist
\freq <+.lsm1 '/gyroscope1'.osc(0, [-10, 40], \freq.asSpec);
\freq2 <+.lsm1 '/gyroscope1'.osc(1, [-10, 40], \freq.asSpec);
\freq <+.lsm0 '/gyroscope0'.osc(0, [-10, 40], \freq.asSpec);
\freq2 <+.lsm0 '/gyroscope0'.osc(1, [-10, 40], \freq.asSpec);

/*
twist of hand
*/
//:simple controller - twist
\freq <+.lsm1 '/gyroscope1'.osc(0, [-10, 40], \freq.asSpec);
\freq2 <+.lsm1 '/gyroscope1'.osc(2, [-10, 40], \freq.asSpec);
\freq <+.lsm0 '/gyroscope0'.osc(0, [-10, 40], \freq.asSpec);
\freq2 <+.lsm0 '/gyroscope0'.osc(2, [-10, 40], \freq.asSpec);

//:simple controller - twist
\freq <+.lsm1 '/acceleration1'.osc(0, [-10, 40], \freq.asSpec);
\freq2 <+.lsm1 '/acceleration1'.osc(2, [-10, 40], \freq.asSpec);
\freq <+.lsm0 '/acceleration0'.osc(0, [-10, 40], \freq.asSpec);
\freq2 <+.lsm0 '/acceleration0'.osc(2, [-10, 40], \freq.asSpec);

//:simple controller - twist
\freq <+.lsm1 '/acceleration1'.osc(0, [-15, 30], \freq.asSpec);
\freq2 <+.lsm1 '/acceleration1'.osc(2, [-15, 30], \freq.asSpec);
\freq3 <+.lsm1 '/acceleration1'.osc(1, [-15, 30], \freq.asSpec);
//:
\freq <+.lsm0 '/acceleration0'.osc(0, [-15, 30], \freq.asSpec);
\freq2 <+.lsm0 '/acceleration0'.osc(2, [-15, 30], \freq.asSpec);
\freq3 <+.lsm0 '/acceleration0'.osc(1, [-15, 30], \freq.asSpec);
//:
\lsm1.v(
	\freq.slider(\freq, \lsm1),
	\freq2.slider(\freq, \lsm1),
	\freq3.slider(\freq, \lsm1)
);
//:
\lsm0.v(
	\freq.slider(\freq, \lsm0),
	\freq2.slider(\freq, \lsm0),
	\freq3.slider(\freq, \lsm0)
);
//:
{
	[Mix(SinOsc.ar(
		[
			Lag.kr(\freq.kr),
			Lag.kr(\freq2.kr)
		]
		, 0, 0.1
	)
		
	),
		SinOsc.ar(
			Lag.kr(\freq3.kr),
			0,
			0.1
		)
	]
} +> \lsm1;
//:================================================================

//:simple controller - twist
\freq <+.lsm1 '/acceleration1'.osc(0, [-15, 30], \freq.asSpec);
\freq2 <+.lsm1 '/acceleration1'.osc(2, [-15, 30], \freq.asSpec);
\freq3 <+.lsm1 '/acceleration1'.osc(1, [-15, 30], \freq.asSpec);
\amp <+.lsm1 '/gyroscope1'.osc(0, [-40, 40]);
//:
\freq <+.lsm0 '/acceleration0'.osc(0, [-15, 30], \freq.asSpec);
\freq2 <+.lsm0 '/acceleration0'.osc(2, [-15, 30], \freq.asSpec);
\freq3 <+.lsm0 '/acceleration0'.osc(1, [-15, 30], \freq.asSpec);
//:
\lsm1.v(
	\freq.slider(\freq, \lsm1),
	\freq2.slider(\freq, \lsm1),
	\freq3.slider(\freq, \lsm1)
);
//:
\lsm0.v(
	\freq.slider(\freq, \lsm0),
	\freq2.slider(\freq, \lsm0),
	\freq3.slider(\freq, \lsm0)
);
//:
{
	[Mix(SinOsc.ar(
		[
			Lag.kr(\freq.kr),
			Lag.kr(\freq2.kr)
		]
		, 0, 0.1
	)
		
	),
		SinOsc.ar(
			Lag.kr(\freq3.kr),
			0,
			0.1
		)
	]
} +> \lsm1;
//:
{
	[Mix(SinOsc.ar(
		[
			Lag.kr(\freq.kr),
			Lag.kr(\freq2.kr)
		]
		, 0, 0.1
	)
		
	),
		SinOsc.ar(
			Lag.kr(\freq3.kr),
			0,
			0.1
		)
	]
} +> \lsm0;
//: second hand with grains
{
	GrainBuf.ar(
		2,
		Impulse.kr(\gps.kr(1) * 2),
		\dur.kr(1) * 0.5,
		sndbuf: \lamento.b.bufnum,
		rate: \rate.kr(1) / 2.5,
		pos: \pos.kr(0),
		interp: 2,
		pan: \pan.kr(0)
	) * \amp.kr	
} +> \lsm0;
//:grain synth gui
\lsm0.v(
	\dur.slider([0.1, 12], \lsm0),
	\pos.slider([0.0, 1.0], \lsm0),
	\rate.slider([0.2, 15], \lsm0),
	\gps.slider([0.5, 20.0], \lsm0),
	\pan.slider([-1, 1.0], \lsm0),
	\amp.slider(\amp, \lsm0)
);
//:grain synth connection
\dur <+.lsm0 '/gyroscope0'.osc(0, [-40, 40], [0.01, 12.5]);
\pos <+.lsm0 '/gyroscope0'.osc(1, [-20, 40], [0.0, 1.0]);
\rate <+.lsm0 '/gyroscope0'.osc(2, [-20, 40], [0.1, 15]);
\gps <+.lsm0 '/magnetometer0'.osc(0, [-1.0, 0.5], [0.2, 15]);
\pan <+.lsm0 '/magnetometer0'.osc(1, [-0.25, 0.25], [-1, 1]);
\amp <+.lsm0 '/magnetometer0'.osc(2, [-0.05, 0.25], \amp);
//:simpler sound