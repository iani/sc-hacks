// 28 Sep 2017 16:36
Nevent.all;
//:
Player.all;
//:
PlayerGui.gui;
//:
currentEnvironment;
//:
{ WhiteNoise.ar } +> \test;
//:
{ SinOsc.ar(1000, 0, 0.1) } +> \test;
//:
{ SinOsc.ar(1300, 0, 0.1) } +> \test;
//:
{ SinOsc.ar(800, 0, 0.1) } +> \test;
//:
{ WhiteNoise.ar } +> \test;
//:
~fadeTime = 10;
//:
\test.toggle;