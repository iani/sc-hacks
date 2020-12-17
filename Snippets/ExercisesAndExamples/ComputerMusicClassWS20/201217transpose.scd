//: 17 Dec 2020 09:34
/* understanding gtranspose and mtranspose
*/
//:basic scale to test:
Pbind(\degree, Pseq((0..7), inf), \dur, 1/4).play;
//:hold the last note of the scale longer
Pbind(\degree, Pseq((0..7), inf), \dur, Pseq([Pn(1/4, 7), 1], inf)).play;
//:Rotate through 8 degrees of gtranspose, one step per scale
Pbind(\degree, Pseq((0..7), inf),
	\dur, Pseq([Pn(1/4, 7), 1], inf),
	\gtranspose, Pstutter(8, Pseq((0..7), inf))
).play;
/* Note:
This plays the scales: 
c major, d major, e major, f major, g major, a major, b major, c' major
*/
//:As above, but with mtranspose instead
Pbind(\degree, Pseq((0..7), inf),
	\dur, Pseq([Pn(1/4, 7), 1], inf),
	\mtranspose, Pstutter(8, Pseq((0..7), inf))
).play;
/* Note:
This plays the scales: 
c major (ionian), d dorian, e phrygian, f lydian, g mixolydian, a aolian, 
b locrian, c' ionian
*/
//:As above, but with ctranspose instead
Pbind(\degree, Pseq((0..7), inf),
	\dur, Pseq([Pn(1/4, 7), 1], inf),
	\ctranspose, Pstutter(8, Pseq((0..12), inf))
).play(TempoClock(4));
/* Note:
This plays major scales on all chromatic steps from c to c'
c major (ionian), d dorian, e phrygian, f lydian, g mixolydian, a aolian, 
b locrian, c' ionian
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
