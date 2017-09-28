//: 28 Sep 2017 11:42
\default.toggle;
//:
\default toggle: { Mix({ SinOsc.ar(400 rrand: 4000, 0, 0.005) } ! 20) };
//:
\default toggle: \default;
// toggleBuf
//: Preparing.
\cabasa.b.postln;
\asdfasdf.b.postln;
\cabasa.b.numChannels;
//:
\cabasa.toggleBuf;
//:
\bell.toggleBuf;
//:
currentEnvironment;

\cabasa.bufnum;

AudioFiles.buffers;
//:
{ PlayBuf.ar(1, 0, loop: 1) } +> \test;

//:
\test.toggle;
//:
currentEnvironment;
//:
\test.e.push;