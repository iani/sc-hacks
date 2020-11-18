/*
 9 Nov 2018 16:23 Testing use of synthdefs with envelopes in patterns etc.
*/
//:preload synthdefs used in this file
SynthDef("sinegennodur", {
	var env, src, out;
	env = Env.sine();
	// Klang args: [freqs], [amps], [phases]
	src = Klang.ar(`[[440, 660, 880]]);
	out = src * EnvGen.kr(env, 1, doneAction: 2);
	Out.ar(0, out);
}).add;
//:preload synthdefs used in this file
SynthDef("sinegennodur", {
	var env, src, out;
	env = Env.sine();
	// Klang args: [freqs], [amps], [phases]
	src = Klang.ar(`[[440, 660, 880]]);
	out = src * EnvGen.kr(env, 1, doneAction: 2);
	Out.ar(0, out);
}).add;
//:first test
Synth('sinegennodur')
//:test in patterns
(instrument: \sinegennodur, dur: 2.2) +> \test;

//:note: shortcuts for freq arguments:
// fundamental * [ratios]
// example:
440 * (1..10) // first 10 harmonic partials
// variants:
440 * (1, 1.2 .. 2) // partials in 1/5 fixed increment values till first octave
// as previous example, coded with explicit ratio:
440 * (1, 6/5 .. 2) //
// as previous example, coded even more explicitly:
440 * (1, 1 + 1/5 .. 2)

//:First test one synthdef


// c variable vs pointer examples
int simplevar; // a simple variable containing one integer.
char onecharacter; // variable containing one character only;
char *string; // a string of undetermined length
int *integerarray /// an array of integers
//:
