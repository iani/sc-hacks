//  6 Sep 2017 01:33
b =\default +> \test;
a = () +> \test;
//:
(dur: 0.1) +> \test;
//:
\test.ppp.clear.originalStream.event;
//:
(degree: Pwhite(0, 10)) +> \test;
//:
(degree: Pbrown(0, 10, 1)) +> \test.clear;
//:
\test.ppp.addEvent((dur: 0.1));
//:
a === b;
//:
b
a

Nevent.libRoot.class;

Library.at(Nevent.libRoot)