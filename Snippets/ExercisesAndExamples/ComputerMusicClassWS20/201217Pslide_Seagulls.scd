//: 17 Dec 2020 11:48 Flock of Seagulls from Pslide.
/* 
Flock of Seagulls from J Harkin's tutorial - modified
*/
//:First test: Original code repeats changed from 8 to inf
// Played with tempo x 2
(
Pbind(
	\degree, Pslide((-6, -4 .. 23), inf, 3, 1, 0),
	\dur, Pseq([0.1, 0.1, 0.2], inf),
	\sustain, 0.15
).play(TempoClock(2));
)
//:Testing values from Pslide
Pslide((-6, -4 .. 23), inf, 3, 1, 0).asStream.nextN(30);
//:Writing the Pslide from above in a different way
// Played with tempo / 4 - to hear jumps happening when pattern folds over
(
Pbind(
	\degree, Pslide((0, 2 .. 23), inf, 3, 1, 0) - 6,
	\dur, Pseq([0.1, 0.1, 0.2], inf),
	\sustain, 0.15
).play(TempoClock(1/4));
)
//:The example from above, avoiding the final jumps by using Pn
// Played with tempo x 1.5
(
Pbind(
	\degree, Pn(Pslide((0, 2 .. 23), 10, 3, 1, 0), inf) - 6,
	\dur, Pseq([0.1, 0.1, 0.2], inf),
	\sustain, 0.15
).play(TempoClock(1.5));
)

//:The example from above, coding the slide in simpler manner using * operator 
// Played with tempo x 1.5
(
Pbind(
	\degree, Pn(Pslide((0, 1 .. 24), 10, 3, 1, 0), inf) * 2 - 6,
	\dur, Pseq([0.1, 0.1, 0.2], inf),
	\sustain, 0.15
).play(TempoClock(1.5));
)
//:compare different encodings of Pslide pattern:
/*The following 3 encoding versions produce the same result
Compare them as regards readability: Which one is easier to understand?
*/
Pslide((-6, -4 .. 23), 10, 3, 1, 0).asStream.nextN(30).postln;
(Pslide((0, 2 .. 23), 10, 3, 1, 0), inf) - 6).asStream.nextN(30).postln;
(Pslide((0, 1 .. 12), 10, 3, 1, 0) * 2 - 6).asStream.nextN(30).postln;