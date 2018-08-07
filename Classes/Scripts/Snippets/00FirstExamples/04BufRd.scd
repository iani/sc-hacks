/* Exploring  BufRd + Phasor or Line as a flexible way to play 
	parts of a buffer. */
//:preload include loadallwk loadallwk44
//:test allwk buffer is loaded
\allwk.b.play;
//:test allwk44 buffer is loaded
\allwk44.b.play;
//:basic bufrd + phasor from help file
{ | rate=1, inter=2 |
	var b;
	b = \buf.kr(\allwk.bufnum);
    BufRd.ar(1, b, Phasor.ar(0, BufRateScale.kr(b) * rate, 0, BufFrames.kr(b)), 1, inter)
} +> \bufrd;
//:understanding reset pos in phasor (from help file)
// left channel start position is fixed to 0, right channel start position is set by MouseY
{ var trig, rate, framesInBuffer;
	var b;
	b = \buf.kr(\allwk.bufnum);
    rate = MouseX.kr(0.1, 100, 1);
    trig = Impulse.ar(rate);
    framesInBuffer = BufFrames.kr(b);
    x = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer,
        [0, MouseY.kr(0, framesInBuffer)]);
    BufRd.ar(1, b, x);
} +> \bufrd;
//:Single channel version of above
//start position is set by MouseY, retrigger period by MouseX
{ var trig, rate, framesInBuffer;
	var b;
	b = \buf.kr(\allwk.bufnum);
    rate = MouseX.kr(0.1, 100, 1);
    trig = Impulse.ar(rate);
    framesInBuffer = BufFrames.kr(b);
    x = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer, MouseY.kr(0, framesInBuffer));
    BufRd.ar(1, b, x);
} +> \bufrd;
//:Gui controlled version of above
var duration;
duration = \allwk.b.numFrames / \allwk.b.sampleRate;
{ 
	var b, framesInBuffer, trig;
	b = \buf.kr(\allwk.bufnum);
    trig = Impulse.ar(\period.kr(1).reciprocal);
    framesInBuffer = BufFrames.kr(b);
    x = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer,
		\startPos.kr(0) * BufSampleRate.kr(b));
    BufRd.ar(1, b, x);
} +> \bufrd;
\bufrd.v(
	\period.slider([0.1, duration]),
	\startPos.slider([0, duration])
);
//:Using Duty to create a timed triggering pattern
// This is deconstructed from a Duty help example.
var duration;
duration = \allwk.b.numFrames / \allwk.b.sampleRate;
{ 
	var b, framesInBuffer, trig;
	b = \buf.kr(\allwk.bufnum);
    trig = TDuty.kr(
		Dseq([0.1, 0.1, 0.2, 0.4], inf), // durations
		0,
		Dseq((1..2), inf)// trigger values
	);
    framesInBuffer = BufFrames.kr(b);
    x = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer,
		\startPos.kr(0) * BufSampleRate.kr(b));
    BufRd.ar(1, b, x);
} +> \bufrd;
\bufrd.v(
	\startPos.slider([0, duration])
);
//:Varying the above to move slowly along entire duration of buffer
// Note: Should improve this by using amp-windowed grains.
var duration;
duration = \allwk.b.numFrames / \allwk.b.sampleRate;
{ 
	var b, framesInBuffer, trig;
	b = \buf.kr(\allwk.bufnum);
    trig = TDuty.kr(
		Dseq([0.05], inf) * \rate.kr(1), // durations
		Impulse.kr(\trigtrig.kr(0.1).reciprocal),
		Dseq((1..500) / 500, inf)// trigger values
	);
    framesInBuffer = BufFrames.kr(b);
    x = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer,
		trig + \startPos.kr(0) * BufFrames.kr(b));
    BufRd.ar(1, b, x);
} +> \bufrd;
\bufrd.v(
	\startPos.slider([0, duration]),
	\rate.slider([0.05, 2]),
	\trigtrig.slider([0.1, 2.5])
);
\rate <+ 0.15;
//:Varying the above to move around randomly in brownian motion
{ 
	var b, framesInBuffer, trig;
	b = \buf.kr(\allwk.bufnum);
    trig = TDuty.kr(
		Dseq([0.05], inf) * \rate.kr(1), // durations
		0,
		Dbrown(0, 1, 0.01, inf)// trigger values
	);
    framesInBuffer = BufFrames.kr(b);
    x = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer,
		trig * BufFrames.kr(b));
    BufRd.ar(1, b, x);
} +> \bufrd;
\bufrd.v(
	\rate.slider([0.05, 2])
);
\rate <+ 0.15;
//:Explore TDuty to use for trigering grain envelopes
//:Simple finite sequence
{ 
	var trig;
    trig = Duty.kr(
		0.25,
		0,
		Dseq((60..72).midicps, 1)// trigger values
	);
    
    SinOsc.ar(trig, 0, 0.1);
} +> \demand;
//:infinite Looping sequence
{ 
	var trig;
    trig = Duty.kr(
		0.25,
		0,
		Dseq((60..72).midicps, inf)// trigger values
	);
    SinOsc.ar(trig, 0, 0.1);
} +> \demand;


//:2 values from one Duty
{ 
	var trig;
    trig = Duty.kr(
		0.5,
		0,
		[Dseq((60..72).midicps, inf), Dseq((72..60).midicps * 2, inf)]
	);
    SinOsc.ar(trig, 0, 0.1);
} +> \demand;


//:sine envelope triggered by Changed.kr on duty values
{ 
	var trig;
	var durs, dur;
	var env;
	env = Env.sine(1);
	durs = [2, 0.5, 0.1, 0.1, 0.1, 5];
    trig = Duty.kr(
		dur = [Dseq(durs, inf), Dseq(durs, inf)],
		0,
		[Dseq((60..72).midicps, inf), Dseq((72..60).midicps * 2, inf)]
	);
    SinOsc.ar(trig, 0, 0.1) * EnvGen.kr(env, Changed.kr(trig), timeScale: dur);
} +> \demand;


//:Like above, with fuller env shape
{ 
	var trig;
	var durs, dur;
	var env;
	env = Env.pairs([[0, 0], [0.1, 1], [0.9, 1], [1, 0.0]], \sine); // Env.sine(1);
	durs = [2, 0.5, 0.1, 0.1, 0.1, 5];
    trig = Duty.kr(
		dur = [Dseq(durs, inf), Dseq(durs, inf)],
		0,
		[Dseq((60..72).midicps, inf), Dseq((72..60).midicps * 2, inf)]
	);
    SinOsc.ar(trig, 0, 0.1) * EnvGen.kr(env, Changed.kr(trig), timeScale: dur);
} +> \demand;


//:Try above with bufrd
// 50 ms grains
{ 
	var b, framesInBuffer, duty, trig, phasor, dur;
	var env;
	env = Env.pairs([[0, 0], [0.1, 1], [0.9, 1], [1, 0.0]], \sine); // Env.sine(1);
	b = \buf.kr(\allwk.bufnum);
    duty = Duty.kr(
		dur = Dseq([0.05], inf), // durations
		0,
		Dseq((0..500), inf) / 500
	);
	trig = Changed.kr(duty);
    framesInBuffer = BufFrames.kr(b);
    phasor = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer, duty * BufFrames.kr(b));
    BufRd.ar(1, b, phasor) * EnvGen.kr(env, Changed.kr(trig), timeScale: dur);
} +> \bufrd;
//:bufrd - 2 overlapping grain streams - simulataneous
// 50 ms grains
{ 
	var b, framesInBuffer, duty, trig, phasor, dur;
	var env;
	env = Env.pairs([[0, 0], [0.1, 1], [0.9, 1], [1, 0.0]], \sine); // Env.sine(1);
	b = \buf.kr(\allwk.bufnum);
    duty = Duty.kr(
		dur = Dseq([0.05], inf), // durations
		0,
		Dseq((0..500), inf) / 500
	);
	trig = Changed.kr(duty);
    framesInBuffer = BufFrames.kr(b);
    phasor = Phasor.ar([trig, trig], BufRateScale.kr(b), 0, framesInBuffer, duty * BufFrames.kr(b));
    BufRd.ar(1, b, phasor) * EnvGen.kr(env, Changed.kr(trig), timeScale: dur);
} +> \bufrd;
//:bufrd - 2 overlapping grain streams - time offset
// 50 ms grains
{ 
	var b, framesInBuffer, duty, trig, phasor, dur;
	var env;
	env = Env.pairs([[0, 0], [0.1, 1], [0.9, 1], [1, 0.0]], \sine); // Env.sine(1);
	b = \buf.kr(\allwk.bufnum);
    duty = Duty.kr(
		dur = Dseq([0.05], inf), // durations
		0,
		Dseq((0..500), inf) / 500
	);
	trig = Changed.kr([duty, DelayN.kr(duty, 0.05, 0.025)]);
    framesInBuffer = BufFrames.kr(b);
    phasor = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer, duty * BufFrames.kr(b));
    BufRd.ar(1, b, phasor) * EnvGen.kr(env, Changed.kr(trig), timeScale: dur);
} +> \bufrd;
//:bufrd - overlapping grains w. time+onset offsets
// 50 ms grains
{ 
	var b, framesInBuffer, duty, trig, phasor, dur;
	var env;
	env = Env.pairs([[0, 0], [0.1, 1], [0.9, 1], [1, 0.0]], \sine); // Env.sine(1);
	b = \buf.kr(\allwk.bufnum);
    duty = Duty.kr(
		dur = Dseq([0.05], inf), // durations
		0,
		Dseq((0..500), inf) / 500
	);
	trig = Changed.kr([duty, DelayN.kr(duty, 0.025, 0.025)]);
    framesInBuffer = BufFrames.kr(b);
	                                                  // why 0.01 instead of 0.025?
    phasor = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer, [duty + 0.025, duty] * BufFrames.kr(b));
    BufRd.ar(1, b, phasor) * EnvGen.kr(env, Changed.kr(trig), timeScale: dur);
} +> \bufrd;
//:bufrd - mixed overlapping grains w. time+onset offsets
// 50 ms grains
{ 
	var b, framesInBuffer, duty, trig, phasor, dur;
	var env;
	env = Env.pairs([[0, 0], [0.1, 1], [0.9, 1], [1, 0.0]], \sine); // Env.sine(1);
	b = \buf.kr(\allwk.bufnum);
    duty = Duty.kr(
		dur = Dseq([0.05], inf), // durations
		0,
		Dseq((0..500), inf) / 500
	);
	trig = Changed.kr([duty, DelayN.kr(duty, 0.025, 0.025)]);
    framesInBuffer = BufFrames.kr(b);
	                                                  // why 0.01 instead of 0.025?
    phasor = Phasor.ar(trig, BufRateScale.kr(b), 0, framesInBuffer, [duty + 0.01, duty] * BufFrames.kr(b));
	Mix(
		BufRd.ar(1, b, phasor) * EnvGen.kr(env, Changed.kr(trig), timeScale: dur));
} +> \bufrd;
//: compare to GrainBuf - redone
{
	GrainBuf.ar(1,
		Impulse.kr(\period.kr(1).reciprocal),
		\dur.kr(1),
		\allwk.bufnum,
		\rate.kr(1),
		\pos.kr(0)
	)
} +> \grainbuf;

\grainbuf.v(
	\period.slider([0.05, 2]),
	\dur.slider([0.05, 2]),
	\rate.slider([0.1, 10]),
	\pos.slider([0, 3.5])
)

//: GrainBuf with Duty
{
	var duty;
	duty = Duty.kr(
		\period.kr(1),
		0,
		Dseq((0..100), inf) / 100
	);
	GrainBuf.ar(1,
		Changed.kr(duty),
		\dur.kr(1),
		\allwk.bufnum,
		\rate.kr(1),
		duty, // \pos.kr(0)
	)
} +> \grainbuf;

\grainbuf.v(
	\period.slider([0.05, 2]),
	\dur.slider([0.05, 2]),
	\rate.slider([0.1, 10]),
	\pos.slider([0, 3.5])
)


//: compare to GrainBuf - from help file
var winenv;

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

//:

SynthDef(\buf_grain_test, { |out, gate = 1, amp = 1, sndbuf, envbuf|
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
    Out.ar(out,
        GrainBuf.ar(2, Impulse.kr(10), 0.1, sndbuf, LFNoise1.kr.range(0.5, 2),
            LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf) * env)
}).add;
//:b play
b.play;
// use built-in env
x = Synth(\buf_grain_test, [\sndbuf, b, \envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);