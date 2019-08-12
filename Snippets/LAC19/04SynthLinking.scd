//:simple source synth
{ PinkNoise.ar(\amp.kr(0.1)) } +> \source;
//:simple effect synth
{ Ringz.ar(In.ar(\in.kr(0)), \freq.kr(440), \dtime.kr(1)).stereo } +> \effect;
//:connect source to effect
\source *> \effect;
//:set a parameter once
\freq <+ 550;
//:open gui on freq parameter
\maptestfreqgui.v(
	\freq.slider(\freq, \effect),
	\amp.slider(\amp, \source),
	\dtime.slider([0.01, 2.0, \exp], \effect)
);
//:routine
{
	50 do: {
		\freq <+ 400.rrand(4000);
		0.1.wait;
	}
} *> \effect;
//:control rate function
\freq <+.effect { LFNoise0.kr(5).range(300, 3000) };
//:control rate function 2
\freq <+.effect { LFNoise1.kr(5).range(300, 3000) };
//:emvelope
\freq <+.effect  Env([400, 4000, 400], [2, 2]);

//:emvelope 2
\dtime <+.effect  Env([0.001, 1.5, 0.001], [0.5, 0.5], \exp);

//:control rate function 2
\dtime <+.effect { LFNoise2.kr(0.2).range(0.001, 0.1) };
