//:Soundcheck 1
// Hello. On emacs with snippet exensions
// you cannot see when the snippets are run.
// but the cursor will show which snippet is current
// More or less.

{
	loop {

		(degree: 20.rand, dur: 0.1).play;
		0.1.wait;
	}
	
}.fork
//:Soundcheck 2
(degree: [0, 19].pwhite, dur: 0.1) +> \p1;
//:stop soundcheck 2
\p1.stop
//================================================================ 
//:Synthdefs

SynthDef.new(\multi, { | amp = 0.3 |
	var sig, trem, env;
	env = Env.new([0.1, 0], [10, 10]);
	trem = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0, 1);
	sig = SinOsc.ar({ExpRand(50, 1200)}!8).range(0, 1);  //multichanel;
	// sig = Splay.ar(sig) * 0.5;
	Out.ar(0, Mix(sig * trem) * amp * EnvGen.kr(env, \gate.kr(1), 1, doneAction: 2));
}).add;

SynthDef.new(\klang, {|amp = 0.2, pan = 0
	freqs = #[55, 130, 174, 740],
	amps = #[0.35, 0.23, 0.12, 0.05],
	phases = #[pi]|
	var sig, env;
	sig = Klang.ar(`[freqs, amps, phases]);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).add;


SynthDef.new(\gauss,{ |freq = 367, amp = 0.3, pan = 0, rq= 0.6|
	var sig, env;
	sig = LFGauss.ar(PinkNoise.kr(0.25), 0.1);
	sig = Pan2.ar(sig, pan, amp);
	sig = APF.ar(sig, 100, 0.8);
	Out.ar(0, sig);
}).add;


SynthDef.new(\mpou, {|st=100|
	var sig, env;
	sig = SinOsc.ar(XLine.kr(st, 60, 3), 0, 0.4);
	env = EnvGen.kr(Env([1, 1, 0], [1, 1], \hold), doneAction: 2);
	sig = sig * env;
	sig = Pan2.ar(sig, 0);
	Out.ar(0, sig);
}).add;

SynthDef.new(\ante, {|freq = 380, harm = 200, atk = 1, rel = 1.2, dur = 1, amp = 0.2 |
	var sig, env;
	sig = Formant.ar(freq);
	env = Env.new([0, 0.6, 0], [atk, rel], \sine);
	sig = sig * EnvGen.kr(env, timeScale: dur, doneAction:2);
	sig = LPF.ar(sig);
	sig = Pan2.ar(sig, 0);
	Out.ar(0, sig * amp);
}).add;
// ================================================================
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//:
\gauss +> \gauss;
//:
\freq <+.gauss 150;
//:
\rq <+.gauss 0.1;
//: MPOU
(instrument: \mpou, dur: 1.1) +> \mpou;
//: MPOU
(instrument: \mpou, dur: 0.1) +> \mpou2;
//: MPOU
(dur: 0.25) +> \mpou2;
//: MPOU
(dur: [0.5, 2].prand) +> \mpou;
//: MPOU
(instrument: \mpou, dur: 0.1) +> \mpou2;
//: MPOU
(instrument: \mpou, dur: [1.0, 0.5].prand) +> \mpou;
//: MPOU
(st: 1000) +> \mpou;
//: MPOU
(st: 200) +> \mpou2;
//:
\mpou2.stop;
//:
\mpou.stop;
//: MPOU
(st: (100..150).pseq) +> \mpou2;
//: MPOU
(st: (100..150).pseq + 500) +> \mpou;
//: MPOU
(st: [10, 300, 10].pbrown) +> \mpou;
//: MPOU
(instrument: \mpou, dur: 1.1, st: 200) +> \mpou;
//:ANTE1
(instrument: \ante,
\midinote:  Pxrand([
		[23, 35, 54, 63, 64],
		[45, 52, 54, 59, 61, 64],
		[28, 40, 47, 56, 59, 63],
		[42, 52, 57, 61, 63],
	], inf)
) +> \ante;
//:
(dur: 0.1) +> \ante;
//:
(dur: 1.1) +> \ante;
//:
//:ANTEtest
(instrument: \ante, dur: [1.6, 2].pwhite, midinote: Pxrand([
		[23, 35, 54, 63, 64],
		[45, 52, 54, 59, 61, 64],
		[28, 40, 47, 56, 59, 63],
		[42, 52, 57, 61, 63],
], inf)) +> \antetest;
//:
(dur: 2.1) +> \antetest;
//:
\amp <+ 0.5;
//: ================ RINGS
//:ringz simply
{ Ringz.ar(PinkNoise.ar(0.05), \freq.kr(1000) * [1, 1.5], 0.05) } +> \test3;
//:ringz simply
{ Ringz.ar(PinkNoise.ar(0.05), \freq.kr(1000) * [1, 1.2], 0.05) } +> \test4;
//:
\freq <+.test3 400.rrand(1000);
//:
\test2.v(
	\freq.slider(\freq, \test2)
)
//:
\test3.v(
	\freq.slider(\freq, \test3)
)
//:
\test4.v(
	\freq.slider(\freq, \test4)
)
//:
\freq <+.test2 400.rrand(1000);
// ================ MULTI
//:
\multi +> \test1;
//:
\multi +> \test2;
//:
\multi3.stop;
//:
\test1.stop;
//:
\test2.stop;
//:
\fadeTime <+ 3;
//:
(\instrument: \multi, dur: 0.2) +> \multi3;
//:
\mpou.stop;
//:
\mpou2.stop;
//:
\klang +> \klang;
//:
\klang +> \klang2;
//:
\klang +> \klang3;
//:
(instrument: \klang, dur: 2) +> \klang;
//:
(instrument: \ante, dur: 1) +> \ante;
//:
(degree: [-20, 20, 1].pbrown) +> \ante;
//:
(dur: 0.1) +> \ante;
//:
(dur: [0.1, 0.2].prand, instrument: \ante) +> \ante2;
//:
(dur: [0.05, 0.02].prand, instrument: \ante) +> \ante3;
//:
(dur: [0.05, 0.02].prand, instrument: \ante) +> \ante4;
//:
(dur: 1) +> \ante4;
//:
(dur: 1) +> \ante2;
//:
(dur: 1) +> \ante3;
//:
(dur: 1) +> \ante;
//:
\klang.stop;
//:
\klang2.stop;
//:
\klang3.stop;
//:
\ante.stop;
//:
(dur: (10, 9.9 .. 1).pseq) +> \mpou;
//: THE END.
// THANKS