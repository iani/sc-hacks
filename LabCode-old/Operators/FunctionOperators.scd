// 26 Jun 2017 00:35 examples for function operators

// ================ Synths

//: Start a synth on a new name
{ SinOsc.ar (\freq.kr (400), 0, 0.1) } +> \synth1;
//: Replace the synth on the same name
{ Decay2.kr (Impulse.kr (5)) * SinOsc.ar (\freq.kr (400 ) * [1, 1.2], 0, 0.1)} +> \synth1;
//: Start a synth on a different name:
{ Decay2.kr (Impulse.kr (7)) * Blip.ar (\freq.kr (400) / [8, 7.5], 50, 0.3) } +> \synth2;
//: change freq environment variable value.  The synths follow:
~freq = 100;
//: stop the second synth.
\synth2.synth.stop;
//: stop the first synth
\synth1.synth.stop;
//: Restart the first synth.  This uses the last stored synthdef.
\synth1.splay;
//: Restart the second synth.  This uses the last stored synthdef.
\synth2.splay;

// ================================================================

// ================ Routines
//: Start a routine 
{
	loop {
		~freq = 500 rrand: 4000;
		1.wait;
	}
} *> \rout1
//: replace this with a different routine
{
	loop {
		~freq = 100 rrand: 400;
		0.2.exprand (0.5).wait;
	}
} *> \rout1
//: Shortcut for loop {}
{
	~freq = 50 exprand: 400;
	0.1.wait;
} **> \rout1;
//: stop the routine
\rout1.routine.stop;

// ================================================================

// ================ Patterns
//: start a new pattern
(dur: 0.1, degree: Pseq ((0..7), inf)) @> \pat1;
//: replace the pattern running at \pat1 with a new one
(dur: Pwhite (0.01, 0.1, inf), degree: Pwhite(0, 7, inf)) @> \pat1;
//: add event's contents to the playing event
(dur: Pwhite (0.01, 2.1, inf)) @>+ \pat1;
//: testing function in event key
// Defer runs the function after the event has played all parameters
(func1: {{ postf("freq param is: %\n", ~freq )}.defer }) @>+ \pat1;

//: ================================================================

//: more function operators

//: Testing function in envir
{ | freq | { SinOsc.ar(freq, 0, EnvGen.kr(Env.perc(0.01, 0.1, 0.1), doneAction: 2))}.play } <* \freq;
//: Note that actions are replaced inherently by Notification:
{ | freq | { LFSaw.ar(freq / 4, 0, EnvGen.kr(Env.perc(0.01, 0.5, 0.1), doneAction: 2))}.play } <* \freq;
//: Clearly the latest stored function replaces the previous one:
{ | freq | { LFTri.ar(freq * 8, 0, EnvGen.kr(Env.perc(0.01, 0.15, 0.1), doneAction: 2))}.play } <* \freq;
//:

//: ================================================================

//: ========== Polyphony: EventStreams triggered by a pattern playing in currentEnvironment
() @> \pat1;
// { ~freq.postln; } <* \freq; // just as a test;
(degree: Pseq((0..7), inf)) <@ \freq;
//: add another stream on a different label
(degree: Pseq((0..7).scramble, inf)) <@.label2 \freq;
//: add another stream on a different label
(degree: Pseq((0..7) + 10, inf), dur: 0.1) <@.label3 \freq;
//: