// 26 Sep 2017 13:03 Using links for the effect.
\source *> \effect;
//:
{ WhiteNoise.ar(0.1) } +> \source;
//:
{ | delay = 0.1, decay = 0.1, mul = 0.1 | CombN.ar (In.ar(\in.kr), 1, delay, decay, 0.1) } +> \effect;
//:
currentEnvironment;
//:
~delay = 0.01;
//:
~delay = 0.0025;
//:
~decay = 1;
//:*
~delay = 0.001 rrand: 0.01;
0.1.wait;
//:
\source.play;
//:
\effect.play;
//:
\delay <+ { LFNoise0.kr(10).range(0.001, 0.01 ) };
//:
\delay <+ { LFNoise2.kr(2).range(0.0005, 0.05 ) };
//:
\source.persist;
\effect.persist;
//:
\source.auto;
\effect.auto;
//: