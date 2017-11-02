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
\cabasa.toggleBuf.auto;
//:
~rate = 0.2;
//:
\bufnum <+ \bell;
//:
~rate = 1;
//:+
var bufs = Pseq ([\bell, \cabasa, 'Construction_Mixer_Small'], inf).asStream;
loop {
	\bufnum <+ bufs.next;
	0.1.exprand(5.0).wait;
}
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