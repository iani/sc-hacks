//:
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
} +> \gre1;
\amp <+ 0.5;
//:test param control on gre1 player
\gre1.v(
	\amp.slider([0.0001, 50, \exp], \gre1, \amp),
	\pos.slider([0, 1], \gre1, \pos),
	\per.slider([0.2, 20, \exp], \gre1, \per),
	\dur.slider([0.1, 5, \exp], \gre1, \dur),
	\rate.slider([0.7, 1.2], \gre1, \rate),
	\pan.slider([-1, 1], \gre1, \pan),
);
//:receive osc from pi1
\per <+.gre1 '/pi1'.osc(3, [-20, 40], [0.9, 10]);
\amp <+.gre1 '/pi1'.osc(1, [-10, 10], \amp);
\dur <+.gre1 '/pi1'.osc(4, [-10, 10], [0.1, 5]);
\rate <+.gre1 '/pi1'.osc(0, [-10, 20], [0.1, 5]);
\pos <+.gre1 '/pi1'.osc(6, [-10, 20], [0.7, 1.2]);
\pan <+.gre1 '/pi1'.osc(7, [-2, 2], [-1, 1]);
//:Adapt abstract synthdefs - use new osc message format
//:LFNoise2
{ LFNoise2.ar(Lag.kr(\freq.kr(440), 0.1), 0.1).stereo } +> \default;

//:gyroscope -> simplesound - smoother

\default.v(
	\x.slider([-50, 50]),
	\y.slider([-50, 50]),
	\y.slider([-50, 50])
);
\default.watch(\x, { | val |
	\freq <+ [100, 5000, \exp].asSpec.map([-50, 50].asSpec.unmap(val))
});
Registry(\oscfuncs, \gyroscope, {
	OSCFunc({ | msg |
		\x <+ msg[1];
		\y <+ msg[2];
	}, \gyroscope)
}).enable;

{ Ringz.ar(WhiteNoise.ar(0.01) * Decay.kr(Impulse.kr(5)), Lag.kr(\freq.kr(440), 0.1), 0.1).stereo } +> \default;

//:Varying source
{ Ringz.ar(WhiteNoise.ar(0.01) * Decay.kr(Impulse.kr(LFNoise1.kr(0.2).range(1, 10))), Lag.kr(\freq.kr(440), 0.1), 0.1).stereo } +> \default;

//:introducing more parameters

\rate <+.default '/magnetometer'.osc(0, [-0.5, 0.5], [0.5, 20]);

\rate <+ 5;

{ Ringz.ar(WhiteNoise.ar(0.01) * Decay2.kr(Impulse.kr(\rate.kr(0.02)), 0.1), Lag.kr(\freq.kr(440), 0.1), 0.01 ).stereo } +> \default;

//:introducing more parameters 2


\default.v(
	\freq.slider([20, 1000]),
	\freq2.slider([20, 1000]),
	\rate.slider([0.1, 30]),
	\ringtime.slider([0.05, 2])
);
//:
\freq <+.default '/gyroscope'.osc(0, [-0.5, 0.5], [100, 2000]);
//:
\freq2 <+.default '/gyroscope'.osc(2, [-0.5, 0.5], [100, 2000]);

\rate <+.default '/magnetometer'.osc(1, [-0.5, 0.5], [0.5, 10]);

\ringtime <+.default '/acceleration'.osc(0, [-10.5, 10.5], [0.005, 2]);

\rate <+ 5;

{ Ringz.ar(WhiteNoise.ar(0.01) * Decay2.kr(Impulse.kr(\rate.kr(0.02)), 0.1), Lag.kr(\freq.kr(440), 0.1), \ringtime.kr(0.01) ).stereo } +> \default;

//:Send messages to self to test OSC reception
{
	var me;
	me = NetAddr.localAddr;
	postf("Will send messages to: %\n", me);
	1.wait;
	10 do: { | i |
		me.sendMsg(\testing, i);
		0.2.wait;
	}
}.fork;
//:check environment
currentEnvironment.postln;
//:osc messages to listen to
/*
'/temperature'
'/acceleration'
'/magnetometer'
'/gyroscope'
*/

//:first test with gyroscope
\testing <+ '/gyroscope'.osc(0, [-50, 50], [200, 5000]);
//:test mysterymetals synthdef
\mysterymetals +> \mysterymetals
//:change a parameter in mysterymetals
\pulse <+.mysterymetals 0.3;
//:change spulse in mysterymetals
\spulse <+.mysterymetals 5;
//:start simple sound: default
\default +>.default \default;
//:change frequency with gyroscope x
// test only: \freq <+ 100;
\freq <+ '/gyroscope'.osc(0, [-50, 50], [200, 5000]);
//:test with GrainBuf
//: GrainBuf: Duty scrolls through buffer
{
	var duty;
	duty = Duty.kr(
		\period.kr(1),
		0,
		Dseq((0..100), inf) / 100
	);
	GrainBuf.ar(1,
		Changed.kr(duty),
		\dur.kr(1),
		\allwk.bufnum,
		\rate.kr(1),
		\pos.kr(0) // duty, // \pos.kr(0)
	)
} +> \grainbuf;

\grainbuf.v(
	\period.slider([0.05, 2], \grainbuf),
	\dur.slider([0.05, 2], \grainbuf),
	\rate.slider([0.1, 10], \grainbuf),
	\pos.slider([0, 3.5], \grainbuf)
);

// \period <+ 0.1;
// \dur <+ 0.25;
\rate <+.grainbuf '/gyroscope'.osc(0, [-40, 40], [0.1, 2]);
\dur <+.grainbuf '/magnetometer'.osc(0, [-0.5, 0.5], [0.1, 2.5]);
// \period <+.grainbuf '/gyroscope'.osc(2, [-40, 40], [0.1, 2.5]);
\pos <+.grainbuf '/acceleration'.osc(0, [-10, 10], [0, 3.5]);
//: allwk .b play
\allwk.b.play;
//:
\rate.value(\grainbuf);
//:1