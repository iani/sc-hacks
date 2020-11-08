//  7 Sep 2020 15:12
// Testing shortcuts for buffer playing and SynthDef construction
//:Load a test buffer.
\testbuffer.load(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
//:
~testbuffer.play;
//:
a = { ~testbuffer.ar(2) }.play;
//:
a.trig;
//:
a.trig(\startPos, 1.12):
//:
a release: 7;
//:
a = {
	Resonz.ar(
		~testbuffer.ar,
		\freq.kr(400),
		\bwr.kr(0.1)
	)
}.play;
//:
a = {
	var src;
	src = { ~testbuffer.ar(1.0 rrand: 1.4) } ! 2;
	Resonz.ar(
		src,
		{ Lag.kr(LFNoise0.kr(3).range(100, 10000), 0.5) } ! 2,
		\bwr.kr(0.1)
	)
}.play;
//:
a = {
	Mix(
		Resonz.ar(
		{ ~testbuffer.ar(0.9 rrand: 1.1) } ! 4,
		{ Lag.kr(LFNoise0.kr(3).range(100, 10000), 0.5) } ! 4,
			\bwr.kr(0.1)
		)
	)
}.play;

//:*
a.set(\freq, 100 rrand: 10000);
1.wait;
//:
a = {
	Mix(
		Resonz.ar(
			~testbuffer.ar((1..4) / 100 + 1),
			{ LFNoise1.kr(5).range(100, 10000) } ! 4,
			\bwr.kr(2)
		)
	)
}.play;
