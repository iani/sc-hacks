/* 15 Jul 2017 19:41
Play an array of numbers as sound signal:
- Convert the array to signal.
- Load the signal into a buffer
- As soon as the signal has been loaded, play the buffer with PlayBuf.
*/

//: Example from Help file to Signal:
s.waitForBoot({
	var amplitudes = [0, 1, 1, -2, 1];
	var sigs = [
		Signal.chebyFill(256+1, amplitudes, normalize: true, zeroOffset: true),
		Signal.chebyFill(256+1, amplitudes, normalize: true, zeroOffset: false)
	];
	b = sigs.collect{ arg sig; Buffer.loadCollection(s, sig.asWavetableNoWrap) };
	s.sync;
	x = {
		var in = SinOsc.ar(100, 0, SinOsc.kr(0.1, 0, 0.5, 0.5));
		Shaper.ar(b, in ) ++ LeakDC.ar(Shaper.ar(b[1], in))
	}.scope;
})
//:
x.free; b.do(_.free); b = nil
// ================================================================
//: try Buffer.loadCollection:
b = Buffer.loadCollection (
	Server.default,
	Array.rand (100000, 0.0, 0.3),
	1,
	{ | b  | postf ("loading done. Result: %\n", b);
		b.play;
	}
);
//: Use server sample rate to produce signal of prescribed duration
b = Buffer.loadCollection (
	Server.default,
	Array.rand (Server.default.actualSampleRate.round (1).asInteger * 5, 0.0, 0.3),
	1,
	{ | b  | postf ("loading done. Result: %\n", b);
		b.play;
	}
);
//: try sine wave
b = Buffer.loadCollection (
	Server.default,
	(0.0, 0.1.. 150pi).sin / 10,
	1,
	{ | b  | postf ("loading done. Result: %\n", b);
		b.play;
	}
);
//:
b.plot;
b.play;
//:
{ PlayBuf.ar (1, b.bufnum, loop: 1, doneAction: 2) } +> \test;
//:
{ PlayBuf.ar (1, b.bufnum, loop: 1, doneAction: 2) }.scope;
//:
{ SinOsc.ar (400, 0, 0.1) }.scope;
//:
(0.0, 0.001..pi).sin / 10;
//:
((0.0, 0.01.. 50pi).sin / 10).plot;
//:
//: try Buffer.loadCollection:
b = Buffer.loadCollection (
	Server.default,
	(0.0, 0.1.. 150pi).sin / 10,
	1,
	{ | b  | postf ("loading done. Result: %\n", b);
		b.play;
	}
);
//: Trying Array:play utility
((0.0, 0.1.. 150pi).sin / 10).plot.data.first.play;

Array.rand(100000, 0, 0.1).plot.data.first.play;

Array.rand(100000, 0, 0.1).plotPlay;
//: Synthesize sine-wave with given frequency
(0, 0.01 .. pi).sin.plot; // half a period

(0, 0.01 .. 2pi).sin.plot; // whole period

(0, 0.01 .. 2pi * 2).sin.plot; // 2 periods

//: size?
(0, 0.01 .. 2pi * 2).size;

//: Prescribing the size
(0, pi / 100 .. 2pi * 2).size; // 401

(0, pi / 100 .. 2pi).size; // 201

(0, 2pi / 100 .. 2pi).size; // 201
// make this 44100 = 1 sec long
(0, 2pi / 44100 .. 2pi).size; // 201
// plot its sine
(0, 2pi / 44100 .. 2pi).sin.plot;
// make 440 periods in this 1 second
(0, 2pi / 44100 * 440 .. 2pi * 440).sin.plot;
//: plot and play it
(0, 2pi / 44100 * 440 .. 2pi * 440).sin.plotPlay;
//: package it into a function
~sine = { | freq = 440, dur = 1, amp = 0.1 |
	(0, 2pi / Server.default.actualSampleRate * freq .. 2pi * freq * dur).sin * amp;
}
//: Use the function, plot and play
~sine.(880, 2).plotPlay;
//: Play many at once.  Major chord

~sine.(880 * 1, 2).plotPlay;
~sine.(880 * 5 / 4, 2).plotPlay;
~sine.(880 * 3 / 2, 2).plotPlay;

//: Play many at once.  Minor chord
~sine.(880 * 1, 2).plotPlay;
~sine.(880 * 6 / 5, 2).plotPlay;
~sine.(880 * 3 / 2, 2).plotPlay;
//: Mix signals by adding them together
(~sine.(880 * 1, 4) + ~sine.(880 * 6 / 5, 4) + ~sine.(880 * 3 / 2, 4)).plotPlay;
//: Obtain an equivalent result using UGens:
{
	SinOsc.ar(440, 0, 0.1)
	+ SinOsc.ar(440 * 5 / 4, 0, 0.1)
	+ SinOsc.ar(440 * 3 / 2, 0, 0.1)
} +> \major;
//: Using MultiChannel expansion + Mix for more compact writing:
{
	Mix (SinOsc.ar(440 * [1, 5/4, 3/2], 0, 0.1))
}.play;
//: Using MultiChannel expansion + Mix for more compact writing:
{
	Mix (SinOsc.ar(440 * [1, 5/4, 3/2], 0, 0.1))
}.play;
//: Reintroduce finite duration with a routine
{
	var synth;
	synth = {
		Mix (SinOsc.ar(440 * [1, 5/4, 3/2], 0, 0.1))
	}.play;
	2.wait;
	synth.free;
}.fork;
//: Use sc-hacks technique to get rid of variable
{
	{
		Mix (SinOsc.ar(440 * [1, 5/4, 3/2], 0, 0.1))
	} +> \synth;
	2.wait;
	\synth.synth.stop;
}.fork;
//: Make a function to play the above as an event of given duration and base frequency
~chord = { | freq = 440, dur = 1, amp = 0.1 |
	{
		var synth;
		synth = {
			Mix (SinOsc.ar(freq * [1, 5/4, 3/2], 0, amp))
		}.play;
		dur.wait;
		synth.release (0.1.exprand (1));
	}.fork
};
//: Test ~chord
~chord.();
//: Try many chords. Use midicps to play in a 12-tone equal-tempered pitch space
r = {
	loop {
		~chord.(40.rrand (80).midicps, 0.1.exprand (2), 0.01.exprand (0.12));
		0.1.exprand (2).wait;
	};
}.fork;
//:
r.stop;