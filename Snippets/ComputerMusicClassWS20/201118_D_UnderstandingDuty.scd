//: 18 Nov 2020 09:14
/* Duty doc is too complex for my little brain.
I'll try to deconstruct it here today.
*/
//:Original example from http://doc.sccode.org/Classes/Duty.html
{
	var freq;
	freq = Duty.kr(
		Drand([0.01, 0.2, 0.4], inf), // demand ugen as durations
		0,
		Dseq([204, 400, 201, 502, 300, 200], inf)
	);
	SinOsc.ar(freq * [1, 1.01]) * 0.1

}.play;
//:I got dizzy. Let's make the durations a fixed cycle.
{
	var freq;
	freq = Duty.kr(
		Dseq([0.01, 0.2, 0.4], inf), // demand ugen as durations
		0,
		Dseq([204, 400, 201, 502, 300, 200], inf)
	);
	SinOsc.ar(freq * [1, 1.01]) * 0.1

}.play;
//:Reducing to what matters
//(Get that irritating reset argument out of the way)
{
	var freq;
	freq = Duty.kr(
		dur: Dseq([0.01, 0.2, 0.4], inf), // durations
		level: Dseq([204, 400, 201, 502, 300, 200], inf)
	);
	SinOsc.ar(freq * [1, 1.01]) * 0.1
}.play;
/*
Got it: 
- dur defines a sequence of durations.
- level defines a sequence of levels (signal values)
- the durations are played in order, and after each duration
  the level signal switches to the next element in the level argument.
*/
//:Using Duty to trigger an envelope
{
	var trig;
	trig = Changed.kr(Duty.kr(
		dur: Dseq([0.05, 0.2, 0.4], inf), // durations
		level: Dseries(0, 0.1, inf)
	));
	WhiteNoise.ar(Env.perc(0.01, 0.1).kr(gate: trig)) * 0.1
} +> \trig;
//:Trigger with Duty, with another pattern
{
	var trig;
	trig = Changed.kr(Duty.kr(
		dur: Dbrown(0.05, 0.2, 0.025, inf), // durations
		level: Dseries(0, 0.1, inf)
	));
	WhiteNoise.ar(Env.perc(0.01, 0.1).kr(gate: trig)) * 0.1
} +> \trig;
