//:Sound check
\default +> \test;
\freq <+ 2000;
\amp <+ 1;
//:Load sounds
Hacks.loadAudioFiles;
//:test lamentodellaninfa
\lamentodellaninfa.b.postln.play;
//:Play stereo with amplitude control
\amp <+.l 15;

{ PlayBuf.ar(1, \lamentodellaninfa.b.bufnum, doneAction: 2) * \amp.kr(1).dup(2)
} +> \l;
//:grain lamentodellaninfa test
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
} +> \sgt1;
\amp <+ 50;
//:test param control on sgt1 player
\sgt1.v(
	\amp.slider([0.0001, 50, \exp], \sgt1, \amp),
	\pos.slider([0, 1], \sgt1, \pos),
	\per.slider([0.2, 20, \exp], \sgt1, \per),
	\dur.slider([0.1, 5, \exp], \sgt1, \dur),
	\rate.slider([0.7, 1.2], \sgt1, \rate),
	\pan.slider([-1, 1], \sgt1, \pan),
);
//:
\per <+.sgt1 '/pi1'.osc(3, [-20, 40], [0.9, 10]);
\amp <+.sgt1 '/pi1'.osc(1, [-10, 40], \amp);
\dur <+.sgt1 '/pi1'.osc(4, [-10, 10], [0.1, 5]);
\rate <+.sgt1 '/pi1'.osc(0, [-10, 20], [0.1, 5]);
\pos <+.sgt1 '/pi1'.osc(6, [-10, 20], [0.7, 1.2]);
\pan <+.sgt1 '/pi1'.osc(7, [-2, 2], [-1, 1]);
// ================================================================
// Testing bus connection
//:test bus;
\testbus.bus;
//:get bus and connect with OSCFunc
// args: osc { | msg, index, min, max | } 
\testbus.bus.osc('/pi1', 0, -10, 10);
//:Test that the value is set.
\testbus.bus.get;
//:make the bus values audible.
{ WhiteNoise.ar(\amp.kr(0.1) ) } +> \test;
//:test amp control
\amp <+ 0.05;
//:get synth
\test.ppp;
//:map to bus;
\test.ppp.map(\amp, \testbus.bus);
//:test again
{ WhiteNoise.ar(\amp.kr(0.1, 1) ) } +> \test;
//:map to new bus - 0 = silence
\test.map(\amp, \testbus);
//:connect to osc
\testbus.bus.osc('/pi1', 0, -10, 10);
//================================================================
//First triggering tests
//:+Dummy test
{ WhiteNoise.ar(Env.perc.kr(levelScale: 0.1, gate: \amp.kr(0.1, 0.1) > 0.5))} +> \test;
[0, 0.5001, 0.4, 0.501, 0.45, 0.51, 0.49] do: { | i |
	\amp <+ i;
	i.postln;
	0.5.wait;
}
//:Connect to osc
\testbus.busOsc('/pi1', 0, -10, 10);
//:map test amp to bus
\test.map(\amp, \test);
//:test watch method
BusOsc.watch(\test1,
	[\test, \pi1, 0, -10, 10]
);
//:Adding slash if needed
("/" ++ \pi1).asSymbol.asCompileString;
//:
\test.busOsc(\pi1, 0, -10, 10);
//:Test again BusOsc for mapping
BusOsc.watch(\test2, //name
	// bus   osc  index min max
	[\test2, \pi1, 0, -10, 10]
);
//:sound for testing again
{ WhiteNoise.ar(Env.perc.kr(levelScale: 0.1, gate: \amp.kr(0.1, 0.1) > 0.5))} +> \test;
//;map
// envir  param  bus
\test.map(\amp, \sx);
//:multiple gates
{
	var src;
	src = (1..10).normalize[1..9] collect: { | i |
		[WhiteNoise.ar(Env.perc.kr(levelScale: 0.1,
			gate: \amp.kr(0.1, 0.1) > i)),
			WhiteNoise.ar(Env.perc.kr(levelScale: 0.1,
				gate: \amp.kr(0.1, 0.1) < i))
		]
	};
	Mix(src.flat).stereo
} +> \test;
//:multiple gates with different filters
{
	var src;
	src = (1..10).normalize[1..9] collect: { | i, j |
		[
			Ringz.ar(
				WhiteNoise.ar(Env.perc.kr(levelScale: 0.015,
					gate: \amp.kr(0.1, 0.1) > i)),
				j + 1 * 100, 0.5
			),
			Ringz.ar(
				WhiteNoise.ar(Env.perc.kr(levelScale: 0.015,
					gate: \amp.kr(0.1, 0.1) < i)),
				j + i * 100, 0.5
			)
		]
	};
	Mix(src.flat).stereo
} +> \test;
//:Sine envelope
{
	var src;
	src = (1..10).normalize[1..9] collect: { | i, j |
		[
			Ringz.ar(
				WhiteNoise.ar(Env.sine.kr(levelScale: 0.005,
					gate: \amp.kr(0.1, 0.1) > i)),
				j + 1 * 100, 2.0
			),
			Ringz.ar(
				WhiteNoise.ar(Env.sine.kr(levelScale: 0.005,
					gate: \amp.kr(0.1, 0.1) < i)),
				j + i * 100, 2.0
			)
		]
	};
	Mix(src.flat).stereo
} +> \test;
//:
