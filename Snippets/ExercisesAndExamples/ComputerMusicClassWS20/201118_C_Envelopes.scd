//: 18 Nov 2020 08:23 Intro to Envelopes
//:================================================================
//:Basics
//:Definition
/*
An envelope defines the shape of a Signal of limited duration
*/
Env.perc.plot;
//:
Env([0, 1, 0.5, 0.9, 0], 0.1 ! 4).plot;
//:To play an envelope, you have to put it in an EnvGen UGen
{
	var env;
	env = Env.perc;
	WhiteNoise.ar(EnvGen.kr(env));
} +> \trig;
//:To stop a Synth when its EnvGen finishes, set doneAction to 2
{
	var env;
	env = Env.perc;
	WhiteNoise.ar(EnvGen.kr(env, doneAction: 2));
} +> \trig;
//:Shortcut for inserting an Env into EnvGen: .kr
{ WhiteNoise.ar(Env.perc.kr(doneAction: 2))} +> \trig;
//:================================================================
//:Triggering envelopes
// An envelope triggers when its gate parameter changes from non-positive to positive
/* NOTE: \gate control is reserved by built-in SynthDef builder.
	Therefore, a different control name must be used (here: \mygate).
*/
// A primitive way of retriggering.
// Requires resetting the gate to 0 AFTER setting it to 1.
//                       start when mygate becomes > 0
{ WhiteNoise.ar(Env.perc.kr(gate: \trig.kr(0))) } +> \trig; 
//:Trigger the envelope in the synth above by setting its gate control
\trig <+.test 1;
{ \trig <+.test 0; }.defer(0.1); // ensure reset to 0 after triggering.
//:A more elegant way of retriggering
{ WhiteNoise.ar(Env.perc.kr(gate: Changed.kr(\trig.kr(0)))) } +> \trig;
//:
\trig <+.test UniqueID.next;
//:Structuring trigger time sequences
//:1. Structuring inside the synth function using UGens.
//:1a. Regular period, using Impulse
{ 0.1 * WhiteNoise.ar(Env.perc.kr(gate: Impulse.kr(\rate.kr(7)))).dup } +> \trig;
//:*change the rate manually
\rate <+.test 5.rrand(10);
1.wait;
//:change the rate with an LFNoise0 ugen
{ 0.1 * WhiteNoise.ar(
	Env.perc.kr(gate: Impulse.kr(LFNoise0.kr(1/4).range(1, 20)))).dup
} +> \trig;
//:As above, but with an LFNoise1 ugen
{ 0.1 * WhiteNoise.ar(
	Env.perc.kr(gate: Impulse.kr(LFNoise1.kr(1/4).range(1, 20)))).dup
} +> \trig;
//:Trigger with Dust
{ 0.1 * WhiteNoise.ar(Env.perc.kr(gate: Dust.kr(10))).dup } +> \trig;
//:Modulate Dust frequency with LFNoise0
{ 0.1 * WhiteNoise.ar(
	Env.perc.kr(gate: Dust.kr(LFNoise0.kr(1/4).range(0.1, 20)))).dup
} +> \trig;
//:1b. Time interval patterns using Duty
{
	var trig;
	trig = Changed.kr(Duty.kr(
		dur: Dseq([0.05 ! 4, 0.2, 0.4 ! 2].flat, inf), // durations
		level: Dseries(0, 0.1, inf) // values used for triggering
	));
	WhiteNoise.ar(Env.perc(0.01, 0.1).kr(gate: trig)) * 0.1.dup
} +> \trig;
// SEE FILE201118_D_UnderstandingDuty.scd for analysis and more examples

//:1c Time interval patterns using signal shapes compared to gate levels
{
	var ctl;
	ctl = SinOsc.kr(0.15).abs;
	0.1 * WhiteNoise.ar(Env.perc(0.01, 0.1)
		.kr(gate: Changed.kr(({ | i | i / 20 < ctl} ! 20).sum))).dup;
} +> \trig;
// SEE FILE 201118_E_MoreControlSignals.scd for explanation and more examples

//:2. Structuring from outside the synth function using routines.
//:+ 2.a Regular beats
{ 0.01 * WhiteNoise.ar(Env.perc.kr(gate: Changed.kr(\trig.kr(0)))).dup } +> \trig;
loop {
	0.2.wait;
	\trig <+.trig UniqueID.next;
};
//:+ 2b. Using Pbrown to vary the length of beats
var durs;
durs = Pbrown(0.02, 0.2, 0.005, inf).asStream;
{ 0.05 * WhiteNoise.ar(Env.perc(0.01, 0.1)
	.kr(gate: Changed.kr(\trig.kr(0)))).dup
} +> \trig;
loop {
	durs.next.wait;
	\trig <+.trig UniqueID.next;
};

//:+ 2b. Using Pseq to play a fixed metric pattern
var durs;
durs = Pseq([0.1 ! 2, 0.2 ! 2, 0.4, 0.2 ! 2].flat, inf).asStream;
{ 0.05 * WhiteNoise.ar(Env.perc(0.01, 0.1)
	.kr(gate: Changed.kr(\trig.kr(0)))).dup
} +> \trig;
loop {
	durs.next.wait;
	\trig <+.trig UniqueID.next;
};

//:================================================================
//:Releasing envelopes
/*
Release is a special term that describes envelopes which 
wait to receive a signal from the user to finish, instead of 
finishing by themselves after a fixed time interval.
*/