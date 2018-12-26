// 25 Dec 2018 04:58
//:start
SuperDirt.start;
//:register all loaded SuperDirt single channel buffers;
~dirt.buffers keysValuesDo: { | name, bufs |
	if (bufs[0].numChannels == 1) {
		Registry(\buffers, name, { bufs[0] });
		bufs do: { | buf, i |
			Registry(\buffers, format("%%", name, i).asSymbol, { buf });
		}
	}
};
//:see one buffer
\baa2.b;
//:play one buffer
\baa2.b.play;
//:play in player one shot.
{ | b = 0 |
	b = \short.b;
	// b.numChannels.postln;
	PlayBuf.ar(b.numChannels, b);
} +> \playbuf;
//:variable channel number synthdef???
SynthDef("buf", { | b = 0, dur = 1, gate = 1 |
	var source, env;
	env = Env.adsr(sustainLevel: 1, releaseTime: 0.1);
	source = PlayBuf.ar(1, b, \rate.kr(1)) * EnvGen.kr(env, gate, doneAction: 2);
	Out.ar(0, source);
})
//:trigger at integer subdivisions of a cycle
{
	var trig;
	trig = Impulse.ar(2, 0, 0.5);
	Decay.ar(trig);
} +> \test;
//:trigger at integer subdivisions of a cycle
{
	var cycle, trig;
	cycle = LFSaw.ar(1).range(0, 2);
	// trig = Impulse.ar(2, 0, 0.5);
	// Decay.ar(trig);
	// [cycle, Decay.ar(1 - ((cycle % 1) > 0.1))];
	// [cycle, Decay.ar(cycle % 1 < 0.01)];
	[cycle, 1 - (cycle % 1.0 > 0.1)];
} +> \test;
//:
\quant <+.test 1;
() +> \test;
//:
\quant <+.test2 1;
(dur: 0.5, degree: [2, 3].pseq) +> \test2;
//:
\quant <+.test3 1;
(dur: 1 / 3, degree: [-3, -5, -2].pseq) +> \test3;
//:
\quant <+.test4 1;
(dur: 1 / 4, degree: (2 * (4 .. 4 + 3)).pseq) +> \test4;
//:
\quant <+.test5 1;
(dur: 1 / 5, degree: (10 .. 10 + 4).pseq) +> \test5;
//:
TempoClock.default.tempo = 0.2;
//:
\quant <+.test2 1;
TempoClock.default.schedAbs(
	TempoClock.default.beats.ceil - 0.00001, {
		(dur: 0.5, degree: [20, 3].pseq) +> \test2;
	}
);


//:
\quant <+.test3 1;
(dur: (1 / 3), degree: [4, 5, 5].pseq) +> \test3;
//:
\quant <+.test4 1;
(dur: (1 / 5), degree: [12, 8, 8, 8, 8].pseq) +> \test4;
//:+ tempo clock scheduling test
TempoClock.default.schedAbs(TempoClock.default.beats.ceil, { ().play });
0.1.wait;
TempoClock.default.schedAbs(TempoClock.default.beats.ceil, { ().play });
//:schedule pattern modification at beginning of beat
\quant <+.test4 1;
TempoClock.default.schedAbs(
	TempoClock.default.beats.ceil - 0.00001, {
		(dur: (1 / 5), degree: [12, 8, 9, 8, 10].pseq) +> \test4;
	}
);


//:schedule pattern modification at beginning of beat
\quant <+.test5 1;
TempoClock.default.schedAbs(
	TempoClock.default.beats.ceil - 0.00001, {
		(dur: (1 / 5), degree: [-10, -2, -2, -4, 0].pseq) +> \test5;
	}
);

