// Preparing buffer granulation for Mari Takano
//:Load a test buffer.
\grainbuffer.load(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
//:test that the buffer has loaded
~grainbuffer.play;
//:Test granulation
a = {
	var bufnum;
	bufnum = ~grainbuffer.bufnum;
	GrainBuf.ar(1, Impulse.kr(\period.kr(1)), \dur.kr(1),
		bufnum,
		\rate.kr(1),
		\pos.kr(0)
	)
}.play;
//:
a.set(\rate, 0.5);
//:
a.set(\dur, 0.1);
//:
a.set(\period, 5);
//:
a.set(\pos, 0.08);
//:
~bus = Bus.control;
//:
a.map(\pos, ~bus);
//:
~head = { Out.kr(~bus, LFSaw.kr(0.2).range(0, 1)) }.play;
//:
~head.free;
//:
~head = { Out.kr(~bus, LFSaw.kr(0.2).range(1, 0)) }.play;
//:
~head.free;
//:
a.set(\period, 10);
//:
a.set(\dur, 0.2);
//:
a.set(\rate, 1);
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
