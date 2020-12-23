
1 + 1;

1000.rand;

1.0.rand;

pi;

//:
\yeah.b.play;
//:*
\yeah.b.play;
0.1.wait;
//:
{}
//:
{}.respondsTo(\blah);
//:
Function.dumpFullInterface;
//:
r = {
	loop {
		\yeah.b.play;
		0.1.wait;
	}
}.fork;
//:
r.stop;
//:
r.reset;
//:
Pbind(\degree, Pbrown(0, 20, 1), \dur, 0.1).play;
//:
() +> \changer;
//:scale example
a = Scale.ionian;
(scale: a, degree: (0..7).pseq) +> \scaleExample;
//:
(scale: Scale.chromatic) +> \scaleExample;
//:
(scale: Scale.chromatic24) +> \scaleExample;
//:
(scale: Scale.chinese) +> \scaleExample;
//:

//:
a.tuning = \just;
//:
a.tuning = \partch;
//:
a.tuning = Tuning.new([0, 0.8, 2.1, 3, 4.05, 5.2, 6, 6.75, 8.3, 9, 10.08, 11.5]);
//:
a.tuning = Tuning.new([0, 0.28, 2.6, 3, 4.05, 5.2, 6, 6.75, 8.3, 9, 10.08, 11.5]);
//:
(dur: 0.25) +> \scaleExample;
//:
(scale: Scale.aeolian);
//:
(degree: [0, 20, 1]) +> \changer;
//:
(degree: [0, 20].pwhite) +> \changer;
//:
(degree: (0..20).pseq) +> \changer;
//:
(degree: [0, 20, 1].pbrown) +> \changer;
//:
(dur: 0.1) +> \changer;
//:
(dur: 1.1) +> \changer;
//:
(dur: 0.31) +> \changer;
//:
(legato: [0.1, 1, 2].prand) +> \changer;
//:
(dur: [0.1, 0.2].prand) +> \changer;
//:
(degree: [0, 20, 1].pbrown) +> \changer;
//:
(degree: [0, 20, 1].pbrown) +> \changer;
//:event example
(degree: (0..7).pseq, dur: 0.25) +> \event;
//:
(mtranspose: 30) +> \event;
//:
(ctranspose: 3) +> \event;
//:
//:
(degree: [0, 2, 4]) +> \strumexample;
//:
(strum: 0.1) +> \strumexample;
//:
(strum: { 0.01.exprand(0.2)}, dur: 0.5) +> \strumexample;
//:
(strum: { -0.3.rand(0.2)}, dur: 0.5) +> \strumexample;
//:
1 rrand: 100;
//:
1.rrand(100);
//:
r.start;
//:
EnvGen.kr(Env.perc, doneAction: 2);

//:
{
	loop {
		\yeah4.b.play;
		0.25.wait;
	}
}.value;
//:
(
Server.default.boot;
)
//:
(
{
	SinOsc.ar(400, 0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		MouseX.kr(200, 2000, \exponential),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(5).range(400, 450),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(
			MouseX.kr(0.5, 20)
		).range(400, 450),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(
			MouseX.kr(20, 2500)
		).range(400, 4500),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(
			LFNoise0.kr(
				MouseX.kr(0.1, 40)
			).range(20, 2500)
		).range(400, 4500),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(
			LFNoise1.kr(
				MouseX.kr(0.1, 140)
			).range(20, 2500)
		).range(400, 4500),
		0, 0.1)
}.play;
)
//:Example of creating an object from a class
(
Window.new().front;
//
)
//:Example of creating an object from a class
(
Window("MY WINDOW", Rect(400, 400, 800, 300)).front;
//
Tuning.directory;
//:
Scale.
//:
d = Dictionary.new;
//:
d = ();
//:
d[\one] = 1;
d[\one];
d[2];
d[\two];
d[\two] = 'catch 22';
//:
Library.superclass.superclass;


