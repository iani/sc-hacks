//: 11 Sep 2017 18:03
\source *> \effect;
//:
{ WhiteNoise.ar(0.1) } +> \source;
//:
(dur: 0.1, degree: Pbrown(0, 10)) +> \source;
//:
(degree: Pwhite(0, 10)) +> \source;
//:
{ Ringz.ar(Fin(), LFNoise1.kr(10).range(100, 200), 5) } +> \effect;
//:
{ Fin() } +> \effect;

// ================================================================
//  7 Sep 2017 13:17
\test.push;
//:
currentEnvironment;
//:
\test.e.getAudioBus;
//:
\test.e.inspect;
\test.e.something;
//:
{ WhiteNoise.ar(0.05) } +> \source;
\source.e.getAudioBus(\out);
//:
{ Ringz.ar(Fin(), 1000, ) } +> \effect;
\effect.e.getAudioBus(\in);
//:
\effect.e;
//:
\source.e;
//:
\source *> \effect;
//:
\source.e;
//:
\effect.e;
