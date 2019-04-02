//:simple synth to test mapping
{ SinOsc.ar(\freq.kr(440), 0, 0.1).stereo } +> \maptest;
//:set a parameter once
\freq <+ 550;
//:open gui on freq parameter
\maptestfreqgui.v(
	\freq.slider(\freq, \maptest)
);
//:routine
{
	50 do: {
		\freq <+ 400.rrand(4000);
		0.1.wait;
	}
} *> \maptest;
//:control rate function
\freq <+ { LFNoise0.kr(5).range(300, 3000) };
//:control rate function 2
\freq <+ { LFNoise1.kr(5).range(300, 3000) };
//:envelope
\freq <+ Env([400, 4000, 400], [2, 2]);
