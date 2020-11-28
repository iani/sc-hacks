SenseServer.postInput;
SenseServer.mute;
SensePlayer.read("/home/iani/.local/share/SuperCollider/MD/201117_153721.txt");
SensePlayer.play;
// SenseBus.activate;
SenseBus.mute.activate.scope;
//:Accessing the X busses
\x1.bus.get;
\x2.bus;
//:First sound test;
{ SinOsc.ar(1000, 0, 0.5).dup } +> \test;
//:Test with X(1) bus
{ SinOsc.ar(X(1).exprange(400, 2000), 0, 0.5).dup } +> \test;

// ================================================================
//:Setup for triggering
//:+Test how trigger is done
\trig <+.test 0;
0.1.wait;
{ WhiteNoise.ar(Env.perc(level: 0.5).kr(gate: \trig.kr(0))).dup; } +> \test;
0.1.wait;
\trig <+.test 1;
//:*Add an adjustable threshold to the trigger
0.5.wait;
\prepare.postln;
\level <+.test 0;
\thresh <+.test 1;
0.1.wait;
{ WhiteNoise.ar(Env.perc(level: 0.5).kr(
	gate:
	\level.kr(0) > \thresh.kr(1))
).dup; } +> \test;
0.9.wait;
"NOW".postln;
\level <+.test 2;
//:+Plug X(1) to the threshold-trigger
\prepare.postln;
\thresh <+.test 0.1;
\test.sliders([\thresh, [-1.0, 1.0, \linear]]);
0.1.wait;
\go.postln;
{ WhiteNoise.ar(Env.perc(level: 0.5).kr(
	gate:
	/* \level.kr(0) */ X(1) > \thresh.kr(0.1))
).dup; } +> \test

//: ================================================================
//:+building the playback algorithm
SensePlayer.read("/home/iani/.local/share/SuperCollider/MD/201117_153721.txt");
~data = SensePlayer.data[..4];
~size = ~data.size;
~times = ~data.flop.first.differentiate[0] = 0;
~convertedData = ~data.flop.put(0, ~times).flop;
~convertedData do: { | row, count |
}