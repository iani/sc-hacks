//: 17 Dec 2020 15:18 Testing tempo change
/*
With transpose patterns and scales
*/
//:Testing tempo change
var tempo, pattern;
tempo = TempoClock();
pattern = Pbind(\degree, Pseq((0..7), inf), \dur, Pseq([Pn(1/4, 7), 1], inf) ).play(tempo);
{
	(1, 1.1 .. 5) do: { | t |
		2.wait;
		postf("now setting tempo to %\n", t);
		tempo.tempo = t;
	};
	"DONE!".postln;
	pattern.stop;
}.fork;
//:Testing tempo change inside pattern
Pbind(\degree, Pseq((0..7), inf),
	\dur, Pseq([Pn(1/4, 7), 1], inf),
	\tempo, Pstutter(8, Pseq((1, 1.1..5), inf))
).play(TempoClock());
//:Random tempo change inside pattern
Pbind(\degree, Pseq((0..7), inf),
	\dur, Pseq([Pn(1/4, 7), 4], inf),
	\tempo, Pstutter(8, Pwhite(0.05, 5, inf))
).play(TempoClock());

//:Random tempo change inside pattern + random gtranspose, mtranspose
Pbind(\degree, Pseq((0..7), inf),
	\dur, Pseq([Pn(1/4, 7), 4], inf),
	\gtranspose, Pseq([Pn(1/4, 7), 4], inf),
	\dur, Pseq([Pn(1/4, 7), 4], inf),
	\tempo, Pstutter(8, Pwhite(0.05, 5, inf)),
	\gtranspose, Pstutter(8, Prand((0..7), inf)),
	\mtranspose, Pstutter(8, Prand((0..7), inf)),
).play(TempoClock());
