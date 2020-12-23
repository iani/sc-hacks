//:Synapsewear connection
/* Synapseware data format: 
/synapseWear, time, status, x, y, z, ...
*/
//:Connect to synapse, scale input
BusOsc.watch(\player1, //name
	[\ssx, '/minibee/data', 1, -0.5, 0.5],
	[\ssy, '/minibee/data', 2, -1.0, 1.0],
	[\ssz, '/minibee/data', 3, -1.0, 1.0],
);
//:Test connection to synths
{
	Mix([
		LFSaw.ar(\freq1.kr(0.2, 0.5).range(200, 400), 0, 0.05),
		SinOsc.ar(\freq2.kr(0.3, 0.5).range(500, 1000), 0, 0.05),
		SinOsc.ar(\freq3.kr(0.4, 0.5).range(1500, 2000), 0, 0.05),
	]
	).stereo
} +> \sgt;
//:test parameter change
\freq1 <+ 0.8;
//:connect x to sound
\sgt.map(\freq1, \sx);
\sgt.map(\freq2, \sy);
\sgt.map(\freq3, \sz);

//:Load samples
//:Test sample
Hacks.loadAudioFiles;
\lamentodellaninfa.b.play;
//:grain synth
{
	GrainBuf.ar(
		2,
		Impulse.kr(\gps.kr(1).range(0.05, 10)),
		\dur.kr(1) * 0.25,
		sndbuf: \lamentodellaninfa.b.bufnum,
		rate: \rate.kr(1).range(0.5, 1.5),
		pos: \pos.kr(0.01844),
		interp: 2,
		pan: \pan.kr(0)
	) * \amp.kr(0.5)
} +> \lsm1;
//:Connect synapse to grain synth
\lsm1.map(\gps, \sz);
\lsm1.map(\pos, \sx);
\lsm1.map(\rate, \sy);

// ============================
// Previous: Tuning the grain synth parameters
//:find a sound with grain synth gui
\lsm1.v(
	\dur.slider([0.1, 12], \lsm1),
	\pos.slider([0.0, 1.0], \lsm1),
	\rate.slider([0.2, 15], \lsm1),
	\gps.slider([0.5, 20.0], \lsm1),
	\pan.slider([-1, 1.0], \lsm1),
	\amp.slider(\amp, \lsm1)
);
// ================================================================
//: add triggering
//:+Very simple test rung
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
