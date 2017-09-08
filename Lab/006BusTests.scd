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