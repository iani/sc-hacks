// 23 Jun 2017 23:11

\r.routine;
//:
\r.routine.play;
//:
\r.routine.play ({
	loop {
		"playing a different routine ".post;
		10000.rand.postln;
		0.5.wait;
	}
});
//:
\r.loop ({
	var dur;
	dur = 0.01 exprand: 2.5;
	{ WhiteNoise.ar (EnvGen.kr (Env.perc (0.01, dur), levelScale: 0.1, doneAction: 2)) }.play;
	dur.wait;
})