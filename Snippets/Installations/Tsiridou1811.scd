Ve//:sound check
\default +> \test;
//:input test - delay 2 seconds
{ DelayN.ar(In.ar(2), 2, 2) } +> \test;
//:First effect test: AllPass
{ AllpassN.ar(In.ar(2), 0.1, 0.1, 10) } +> \test;
//:J. McCartney example from docs
{
var s, z, y;
    // 10 voices of a random sine percussion sound :
s = In.ar(2);
    // reverb predelay time :
z = DelayN.ar(s, 0.048);
    // 7 length modulated comb delays in parallel :
y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15) }));
    // two parallel chains of 4 allpass delays (8 total) :
4.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1) });
    // add original sound to reverb and play it :
s+(0.2*y)
}.scope

} +> \test;
//:J. McCartney example from docs - variant
{
var s, z, y;
    // 10 voices of a random sine percussion sound :
s = In.ar(2);
    // reverb predelay time :
z = DelayN.ar(s, 0.048);
    // 7 length modulated comb delays in parallel :
y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15) }));
    // two parallel chains of 4 allpass delays (8 total) :
4.do({ y = AllpassN.ar(y, 0.050, [0.0050.rand, 0.0050.rand], 1) });
    // add original sound to reverb and play it :
s+(0.2*y)
}.scope

} +> \test;
//:1st freeverb example
\test2.v(
	\mix.slider([0.01, 0.5], \test2),
	\room.slider([0.01, 0.5], \test2),
	\damp.slider([0.01, 0.75], \test2),
);

{  |mix = 0.25, room = 0.15, damp = 0.5|
FreeVerb.ar(
            In.ar(2),
            mix, // mix 0-1
            room, // room 0-1
            damp // damp 0-1 duh
        ) ! 2
} +> \test2;
//:JPverb example 1
{
    var src, rev;
   src = In.ar(2);
   rev = JPverb.ar(
        src,
        \t60.kr(1,           0.05),
        \damp.kr(0,          0.05),
        \size.kr(1,          0.05),
        \earlydiff.kr(0.707, 0.05),
        \mdepth.kr(5,        0.05),
        \mfreq.kr(2,         0.05),
        \lowx.kr(1,          0.05),
        \midx.kr(1,          0.05),
        \highx.kr(1,         0.05),
        \lowband.kr(500,     0.05),
        \highband.kr(2000,   0.05)
    );

    Mix([src, rev]) * 0.1;
} +> \test;
//:JPverb example 2 - with sliders
{
\test.v(
        \t60.slider([0.1, 2], \test),
        \damp.slider([0.0, 0.99], \test),
        \size.slider([0.1, 1.5], \test),
        \earlydiff.slider([0.1, 1.5], \test),
        \mdepth.slider([1, 9], \test),
        \mfreq.slider([1, 9], \test),
        \lowx.slider([0.1, 1.5], \test),
        \midx.slider([0.1, 1.5], \test),
        \highx.slider([0.1, 1.5], \test),
        \lowband.slider([100, 1500], \test),
        \highband.slider([100, 3000], \test),
        \amp.slider(\amp, \test);
);
}.defer(1);

{
    var src, rev;
   src = In.ar(2);
   rev = JPverb.ar(
        src,
        \t60.kr(2,           0.05),
        \damp.kr(0,          0.05),
        \size.kr(1,          0.05),
        \earlydiff.kr(0.707, 0.05),
        \mdepth.kr(5,        0.05),
        \mfreq.kr(2,         0.05),
        \lowx.kr(1,          0.05),
        \midx.kr(1,          0.05),
        \highx.kr(1,         0.05),
        \lowband.kr(500,     0.05),
        \highband.kr(2000,   0.05)
    );

    Mix([src, rev]) * \amp.kr(0.1);
} +> \test;
