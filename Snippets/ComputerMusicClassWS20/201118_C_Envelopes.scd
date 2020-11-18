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
} +> \test;
//:To stop a Synth when its EnvGen finishes, set doneAction to 2
{
	var env;
	env = Env.perc;
	WhiteNoise.ar(EnvGen.kr(env, doneAction: 2));
} +> \test;
//:Shortcut for inserting an Env into EnvGen: .kr
{ WhiteNoise.ar(Env.perc.kr(doneAction: 2))} +> \test;
//:================================================================
//:Triggering envelopes
// An envelope triggers when its gate parameter changes from non-positive to positive
/* NOTE: \gate control is reserved by built-in SynthDef builder.
	Therefore, a different control name must be used (here: \mygate).
*/
// A primitive way of retriggering.
// Requires resetting the gate to 0 AFTER setting it to 1.
//                       start when mygate becomes > 0
{ WhiteNoise.ar(Env.perc.kr(gate: \trig.kr(0))) } +> \test; 
//:Trigger the envelope in the synth above by setting its gate control
\trig <+.test 1;
{ \trig <+.test 0; }.defer(0.1); // ensure reset to 0 after triggering.
//:A more elegant way of retriggering
{ WhiteNoise.ar(Env.perc.kr(gate: Changed.kr(\trig.kr(0)))) } +> \test;
//:
\trig <+.test UniqueID.next;
//:Structuring trigger time sequences
//:1. Structuring inside the synth function using UGens.
//:1a. Regular period, using Impulse

//:1b. Time interval patterns using Duty




//:2. Structuring from outside the synth function using routines.

//:============= ===================================================
//:Releasing envelopes