
SynthDef.new(\multi, { | amp = 0.3 |
	var sig, trem, env;
	env = Env.new([0.1, 0], [10, 10]);
	trem = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0, 1);
	sig = SinOsc.ar({ExpRand(50, 1200)}!8).range(0, 1);  //multichanel;
	// sig = Splay.ar(sig) * 0.5;
	Out.ar(0, Mix(sig * trem) * amp * EnvGen.kr(env, \gate.kr(1), 1, doneAction: 2));
}).add;
//:
\multi +> \test1;
//:
\fadeTime <+ 3;
//:
currentEnvironment;
//:*
\multi +> \test1;
3.wait;
//:
\amp <+ 0.85;
//:

Player

//:
x = Synth(\multi);
//:

SynthDef.new(\klang, {|amp = 0.2, pan = 0
	freqs = #[55, 130, 174, 740],
	amps = #[0.35, 0.23, 0.12, 0.05],
	phases = #[pi]|
	var sig, env;
	sig = Klang.ar(`[freqs, amps, phases]);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).play;

//:
SynthDef.new(\gauss,{ |freq = 367, amp = 0.3, pan = 0, rq= 0.6|
	var sig, env;
	sig = LFGauss.ar(PinkNoise.kr(0.25), 0.1);
	sig = Pan2.ar(sig, pan, amp);
	sig = APF.ar(sig, 100, 0.8);
	Out.ar(0, sig);
}).play;

//:
SynthDef.new(\mpou, {|st=100|
	var sig, env;
	sig = SinOsc.ar(XLine.kr(st, 60, 3), 0, 0.4);
	env = EnvGen.kr(Env([1, 1, 0], [1, 1], \hold));
	sig = sig * env;
	sig = Pan2.ar(sig, 0);
	Out.ar(0, sig);
}).play;

//:

~chords = Pbind(
	\instrument, \ante,
	\dur, Pwhite(1.6, 2, inf),
	\midinote, Pxrand([
		[23, 35, 54, 63, 64],
		[45, 52, 54, 59, 61, 64],
		[28, 40, 47, 56, 59, 63],
		[42, 52, 57, 61, 63],
	], inf),
).play;
//:


//:

SynthDef.new(\ante, {|freq = 380, harm = 200, atk = 1, rel = 1.2, dur = 1 |
	var sig, env;
	sig = Formant.ar(freq);
	env = Env.new([0, 0.6, 0], [atk, rel], \sine);
	sig = sig * EnvGen.kr(env, timeScale: dur, doneAction:2);
	sig = LPF.ar(sig);
	sig = Pan2.ar(sig, 0);
	Out.ar(0, sig);
}).add;
//:
(instrument: \ante, dur: [1.6, 2].pwhite, midinote: Pxrand([
		[23, 35, 54, 63, 64],
		[45, 52, 54, 59, 61, 64],
		[28, 40, 47, 56, 59, 63],
		[42, 52, 57, 61, 63],
], inf)) +> \antetest;
//:
(dur: 2.1) +> \antetest;
//:Explore when environment is pushed
currentEnvironment;
//:
\amp <+ 0.5;
\default +> \test2;
//:
{ Ringz.ar(PinkNoise.ar(0.05), \freq.kr(1000), 0.05) } +> \test3;
//:
// \test3.push;
\freq <+.test3 400.rrand(1000);
//:
\test2.v(
	\freq.slider(\freq, \test2)
)
//:
\test3.v(
	\freq.slider(\freq, \test3),
	\freq.slider(\freq, \test2)
)
//:
// \test2.push;
\freq <+.test2 400.rrand(1000);
//: