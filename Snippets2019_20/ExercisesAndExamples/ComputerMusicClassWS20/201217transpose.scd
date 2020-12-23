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
*/
//:Play all 7 modes based on c.
Pbind(\degree, Pseq((0..7), inf),
	\dur, Pseq([Pn(1/4, 7), 1], inf),
	\mtranspose, Pstutter(8, Pseq((0..6), inf)),
	\ctranspose, Pstutter(8, Pseq([0, -2, -4, -5, -7, -9, -11], inf))
).play(TempoClock(2));
/* Note: Since mtranspose makes the scale start on a different degree,
we transpose the whole framework down by as many semitones as the mode
moves it up.
*/