//:  3 Jan 2020 16:44
// calculate if variance is low
// variance is actually Changed.kr
//:
//:setup sensors
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\x1, 1, 0.47, 0.53, 1],
	[\y1, 2, 0.47, 0.53, 1],
	[\z1, 3, 0.47, 0.53, 1],
	[\x2, 1, 0.47, 0.53, 2], // using sensor module 3
	[\y2, 2, 0.47, 0.53, 2],
	[\z2, 3, 0.47, 0.53, 2],
	[\x3, 1, 0.47, 0.53, 3],
	[\y3, 2, 0.47, 0.53, 3],
	[\z3, 3, 0.47, 0.53, 3],
	[\x4, 1, 0.47, 0.53, 4], // using sensor module 3
	[\y4, 2, 0.47, 0.53, 4],
	[\z4, 3, 0.47, 0.53, 4]
);
//:
{
	var source;
	source = Impulse.kr(1);
	WhiteNoise.ar(
		Decay.kr(Changed.kr(source));
	);
} +> \test;
//:
{
	var source;
	source = Dust.kr(0.1);
	WhiteNoise.ar(
		Amplitude.kr(Changed.kr(source), 0.001, 1)
		< 0.1
	);
} +> \test;
//:
{ WhiteNoise.ar(\x3.kr(0)) } +> \busvol;
//:
{
	WhiteNoise.ar(
		Amplitude.kr(
			Changed.kr(
				\x3.kr(0), 0.15
			), 1, 1
		)
	)
} +> \busvol;
//:
\x3 @>.busvol \x3;>