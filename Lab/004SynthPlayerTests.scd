//:+ basic:
\test.p; // Player
\test.pp; // Players sourcePlayer;
//: TESTING RELEASE and SynthDef cleanup
\default +> \test;
{ WhiteNoise.ar(0.1) } +> \test;
//:* looping
\default +> \test;
0.5.wait;
{ WhiteNoise.ar(0.1) } +> \test;
0.5.wait;
//:
\default +> \test;
~freqStream = Pbrown(10, 100, 1).midicps.asStream;
//:*
~freq = ~freqStream.next;
0.01.wait;
//:
\test.pp.release;
//: ... debugging release ...
\test.ppp.addDependant({ | ... args | args.postln; });
\test.ppp.release;
//:
(dur: 0.1, degree: 10 + 10.rand).play;
//:*
(dur: 0.1, degree: 10 + 10.rand).play;
0.1.wait;
//:*
(dur: 0.1, degree: 10 + 10.rand).play;
0.1.wait;

//:*
(dur: 0.1, degree: 10 + 10.rand).play;
0.1.wait;
(dur: 0.1 + 10.rand, degree: 10 + 10.rand).play;
5.0.rand.wait;
//:
~freq = 150;
//:
currentEnvironment.inspect;
//:
currentEnvironment addDependant: { | ... args | args.postln; };
//:
~e = (Integer: 100);
//:
currentEnvironment.dispatch.dispatcher;
//:
~e.put(Float, 123456);

putAll