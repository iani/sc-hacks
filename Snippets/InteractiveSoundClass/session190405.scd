{ SinOsc.ar(400, 0, 0.1) } +> \f;
//:
{
	Mix(
		SinOsc.ar(400, 0, 0.1)
	)
} +> \f;
//:
{
	Mix(
		SinOsc.ar(100 * (1..100),
			(1..100) / 300,
			0.01
			//(1.100).reciprocal / 100)
		)
	)
} +> \f;
//:
UGen.dumpClassSubtree;
//:

{
    var f, sf;
    sf = K2A.ar(MouseX.kr > 0.5); // > 0;
    f = Ball.ar(sf, MouseY.kr(0.01, 20, 1), 0.01);
    f = f * 15 + 500;
    SinOsc.ar(f, 0, 0.2)
} +> \ball;

//:
{
    var f, sf;
    // sf = K2A.ar(MouseX.kr > 0.5); // > 0;
	sf = Impulse.kr(1);
    f = Ball.ar(sf, MouseY.kr(0.01, 20, 1), 0.01);
    f = f * 15 + 500;
    SinOsc.ar(f, 0, 0.2)
} +> \ball;

//:
{
    var f, sf;
    // sf = K2A.ar(MouseX.kr > 0.5); // > 0;
	sf = Impulse.kr(\rate.kr(1));
    f = Ball.ar(sf, MouseY.kr(0.01, 20, 1), 0.01);
    f = f * 15 + 500;
    SinOsc.ar(f, 0, 0.2)
} +> \ball;
//:
{
    var f, sf;
    // sf = K2A.ar(MouseX.kr > 0.5); // > 0;
	sf = Impulse.kr(\rate.kr(1));
    f = Ball.ar(sf, \grav.kr(1), 0.01);
    f = f * 15 + 500;
    SinOsc.ar(f, 0, 0.2)
} +> \ball;
//:
\ball.v(
	\rate.slider([0.2, 2]),
	\grav.slider([0.01, 20, \exp])
)
// Without sc hacks
//:before the sweep
a = { SinOsc.ar(440, 0, 0.1) }.play;
//:before the sweep 2
a.release;
a = { SinOsc.ar(MouseX.kr(400, 4000), 0, 0.1) }.play;
// with sc hacks
//:static sound
{ SinOsc.ar(440, 0, 0.1) } +> \a;
//:mouse controlled sound
{ SinOsc.ar(MouseX.kr(400, 4000), 0, 0.1) } +> \a;
//:Line 1 - linear
{ SinOsc.ar(Line.kr(400, 4000, 5), 0, 0.1) } +> \a;
//:Line 2 - exponential
{ SinOsc.ar(XLine.kr(400, 4000, 5), 0, 0.1) } +> \a;
//:We need ENVELOPES
{
	var env, envgen; // variable to store the envelope in. 
	// define an envelope
	// ------- levels, times ... 
	env = Env([440, 440, 440, 880], [0.1, 3, 0.25]);
	envgen = EnvGen.kr(
		env,
		\trig.kr(1),
		\levelScale.kr(1),
		\levelBias.kr(0),
		\timeScale.kr(1),
		0
	);
	SinOsc.ar(envgen, 0, 0.1)
} +> \a;
//:+retrigger! (hack, unfortunately)
\trig <+ 0.0;
0.1.wait;
\trig <+ 1;
//:+Now check level bias to understand logarithmic pitch perception
\levelBias <+ 200;
\trig <+ 0.0;
0.1.wait;
\trig <+ 1;

//:+Now check level bias to understand logarithmic pitch perception
\levelBias <+ -200;
\trig <+ 0.0;
0.1.wait;
\trig <+ 1;

//:+by comparison
\levelBias <+ 0;
\trig <+ 0.0;
0.1.wait;
\trig <+ 1;
//:An easier approach: using Pulse
{
	SinOsc.ar(LFPulse.kr(1).range(\lo.kr(440), \hi.kr(880)), 0, 0.1)
} +> \a

//:An easier approach: using Pulse
{ | lo = 440, add = 440 |
	SinOsc.ar(LFPulse.kr(1).range(lo, lo + add), 0, 0.1)
} +> \a
//:An easier approach: using Pulse
{ | lo = 440, mul = 2 |
	SinOsc.ar(LFPulse.kr(1).range(lo, lo * mul), 0, 0.1)
} +> \a
//:
\mul <+ 2;
//:
\lo <+ 220;
//:
\lo <+ 440;
//:logarithmic vs. linear pitch perception 1

{ SinOsc.ar(Line.kr(400, 800, 0.5), 0, 0.1) } +> \a;

