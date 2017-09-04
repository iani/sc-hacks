//: basic:
\test.p; // Player
\test.pp; // Players sourcePlayer;
//: TESTING RELEASE and SynthDef cleanup
\default +> \test;
{ WhiteNoise.ar(0.1) } +> \test;

\test.ppp.addDependant({ | ... args | args.postln; } );

\test.ppp.release;

