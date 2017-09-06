//  6 Sep 2017 01:33
b =\default +> \test;
a = (dur: 0.02, degree: Pbrown(0, 10, 1)) +> \test;
//:
{ WhiteNoise.ar(0.1) } +> \test;
//:
b = \test.clear;
//:
(dur: 0.1) +> \test;
//:
(dur: 1.1) +> \test;
//:
\test.ppp.clear.originalStream.event;
//:
(degree: Pwhite(0, 10)) +> \test;
//:
b = (degree: Pbrown(0, 10, 1)) +> \test.clear;
//:
\test.ppp.addEvent((dur: 0.1));
//:
a === b;
//:
b
a

Nevent.libRoot.class;

Library.at(Nevent.libRoot);

\test.p.play;
\x.p.play;

//:
() +> \x;
//:
Player
\x.play;