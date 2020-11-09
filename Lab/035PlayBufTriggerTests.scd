// 24 Aug 2020 17:35
//:+ record audio file for testing PlayBuf and buffer play UGens
// this file was moved to ~/sounds/iz/sinegliss.aiff
// then a symbolic link of iz was created in Dirt-Samples quark directory
Server.default.record(numChannels: 1, duration: 60.0);
{ SinOsc.ar(XLine.kr(800, 2400, 61.0), 0, 0.2) }.play;
//:Using SD to load test sample along with others.
SD.init;
SD.gui;
//:get the buffer for future use
~gliss = SD.buffers[\iz_sinegliss];
//:test the buffer
~gliss.play;
//:test the buffer with PlayBuf
~test = {
	var bufnum;
	bufnum = ~gliss.bufnum;
	\amp.kr(2) * PlayBuf.ar(1, bufnum,
		\rate.kr(2),
		Changed.kr(\trig.kr(1)),
		\startPos.kr(0) * BufSampleRate.kr(bufnum),
		\loop.kr(1)
	)
}.play;
//:test retriggering
~test.set(\trig, 0.rrand(10000000.0));
//:
~test.set(\startPos, 10, \trig, 0.rrand(10000000.0));
//:
~test.set(\startPos, 40, \trig, 0.rrand(10000000.0));
//:
~test.set(\rate, -1, \startPos, 55, \trig, 0.rrand(10000000.0));
//:
~test.set(\rate, -1, \startPos, 2, \trig, 0.rrand(10000000.0));
//:
~test.set(\rate, 1, \startPos, 2, \trig, 0.rrand(10000000.0));




//:+test retriggering from different start positions
var pos, synth, rate;
synth = {
	var bufnum;
	bufnum = ~gliss.bufnum;
	\amp.kr(2) * PlayBuf.ar(1, bufnum,
		\rate.kr(2),
		Changed.kr(\trig.kr(1)),
		\startPos.kr(0),
		\loop.kr(1)
	)
}.play;
0.1.wait;
pos = Pseq(44100 * [0, 15, 30, 45].reverse, inf).asStream;
rate = Pseq([-3, -2, -1, 1, 2, 3], inf).asStream;
20 do: {
	synth.set(
		\rate, rate.next,
		\startPos, pos.next, \trig, 0.rrand(10000000.0));
	3.wait;
};
//:================================================================
//retry with default allwk buffer, making easier to hear rate and
//startpos changes
~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
//:
//:+test retriggering from different start positions
var pos, synth, rate;
synth = {
	var bufnum;
	bufnum = ~buf.bufnum;
	\amp.kr(3) * PlayBuf.ar(1, bufnum,
		\rate.kr(2),
		Changed.kr(\trig.kr(1)),
		\startPos.kr(0),
		\loop.kr(1)
	)
}.play;
0.1.wait;
pos = Pseq(44100 * [0, 0.2, 0.5, 1.0].reverse, inf).asStream;
rate = Pseq([-0.25, -0.5, 0.25, 0.5, 1], inf).asStream;
inf do: {
	synth.set(
		\rate, rate.next,
		\startPos, pos.next, \trig, 0.rrand(10000000.0));
	8.0.wait;
};
//:===============================================================
// Retry with prologue buffer, which is longer and has even more variety
~buf = SD.buffers[\iz_prologue];
//:
//:+test retriggering from different start positions
var pos, synth, rate;
~synth = {
	var bufnum;
	bufnum = ~buf.bufnum;
	\amp.kr(3) * PlayBuf.ar(1, bufnum,
		\rate.kr(1),
		Changed.kr(\trig.kr(1)),
		\startPos.kr(0) * BufSampleRate.kr(bufnum),
		\loop.kr(1)
	)
}.play;
//:manually jumping to some positions to try out
~synth.set(\startPos, 10, \trig, 0.rrand(1000000.0));
//:more positions
~synth.set(\startPos, 15, \trig, 0.rrand(1000000.0));
//:more positions
~synth.set(\startPos, 12, \trig, 0.rrand(1000000.0));
//:more positions
~synth.set(\startPos, 13.5, \trig, 0.rrand(1000000.0));
//:more positions
~synth.set(\startPos, 65, \trig, 0.rrand(1000000.0));//:
//:more positions
~synth.set(\startPos, 105, \trig, 0.rrand(1000000.0));
//:more positions
~synth.set(\rate, -1, \startPos, 125, \trig, 0.rrand(1000000.0));
//:more positions
~synth.set(\rate, -1, \startPos, 135, \trig, 0.rrand(1000000.0));
//:more positions
~synth.set(\rate, 1, \startPos, 125, \trig, 0.rrand(1000000.0));
//:+ The above, in sequence using routine
~buf = SD.buffers[\iz_prologue];
~synth = {
	var bufnum;
	bufnum = ~buf.bufnum;
	\amp.kr(3) * PlayBuf.ar(1, bufnum,
		\rate.kr(1),
		Changed.kr(\trig.kr(1)),
		\startPos.kr(0) * BufSampleRate.kr(bufnum),
		\loop.kr(1)
	)
}.play;
0.1.wait;
~synth.set(\rate, 1, \startPos, 10, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, -1, \startPos, 15, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, 1.2, \startPos, 10, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, 1.25, \startPos, 10, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, 1.5, \startPos, 10, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, 1, \startPos, 10, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, -1, \startPos, 15, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, 1.2, \startPos, 15, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, 1.25, \startPos, 12, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\startPos, 13.5, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\startPos, 65, \trig, 0.rrand(1000000.0));//:
3.wait;
~synth.set(\startPos, 105, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, -1, \startPos, 125, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, -1, \startPos, 135, \trig, 0.rrand(1000000.0));
3.wait;
~synth.set(\rate, 1, \startPos, 125, \trig, 0.rrand(1000000.0));
//:

0.1.wait;
pos = Pseq(44100 * [0, 0.2, 0.5, 1.0].reverse, inf).asStream;
rate = Pseq([-0.25, -0.5, 0.25, 0.5, 1], inf).asStream;
inf do: {
	synth.set(
		\rate, rate.next,
		\startPos, pos.next, \trig, 0.rrand(10000000.0));
	8.0.wait;
};

//:testing new methods ar, bufplay, etc. 
// 26 Aug 2020 19:08
//:
SD.init;
//:
a = { SD.bufferAt(\iz_prologue).ar * \amp.kr(1) }.play;
//:
a.trig(\startPos, 700, \amp, 5, \rate, 0.75);
//:
a.trig(\startPos, 750, \amp, 5, \rate, -0.75);
//:
a.trig(\startPos, 750, \amp, 5, \rate, -1.25);
//:
b = {
	Resonz.ar(SD.bufferAt(\iz_prologue).ar,
		\freq.kr(440),
		\bwr.kr(1),
		\amp.kr(1)
	)
}.play;
//:
b.trig(\startPos, 700, \amp, 5, \rate, 0.75);
//:
b.set(\freq, 1000);
//:
b.set(\bwr, 0.01);
//:
b.set(\freq, 5000);
//:
b.trig(\startPos, 750, \amp, 5, \rate, -0.75);
//:
b.trig(\startPos, 750, \amp, 5, \rate, -1.25);
