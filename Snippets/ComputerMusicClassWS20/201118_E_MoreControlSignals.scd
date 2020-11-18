//: 18 Nov 2020 10:58 More on control signals
/* Comparing signals (and using them as triggers)
Run the examples below with a scope open on control signal, with 12 channels.
*/
//:Prepare scope
Server.default.scope(rate: \control, numChannels: 12);
//:Compare a signal
{
	var sig;
	sig = SinOsc.kr(1, 0, 0.5);
	[sig, sig > 0]
} +> \ctls;
//:Expand the above to several comparisons
{
	var sig;
	sig = SinOsc.kr(1, 0, 0.9);
	[sig, sig > 0, sig > 0.5]
} +> \ctls;
//:Code more compacly using an array
{
	var sig;
	sig = SinOsc.kr(1, 0, 1);
	[sig] ++ ({ | i |
		i / 10 < sig
	} ! 10)
} +> \ctls;
//:Sum and combine with Changed to use as trigger
{
	var sig, comps, sum;
	sig = SinOsc.kr(1, 0, 1);
	comps = { | i | i / 9 < sig} ! 9;
	sum = comps.sum;
	[sig] ++ comps ++ [sum / 10, Changed.kr(sum)];
} +> \ctls;
//:Use the above as envelope trigger;
{
	var sig, comps, sum, trig;
	sig = SinOsc.kr(0.3, 0, 1);
	comps = { | i | i / 9 < sig} ! 9;
	sum = comps.sum;
	trig = Changed.kr(sum);
	Out.kr(0, [sig] ++ comps ++ [sum / 10, trig]);
	0.1 * WhiteNoise.ar(Env.perc(0.01, 0.1).kr(gate: trig));
} +> \ctls;
//:Reverse the negative part of the Sine curve with abs
{
	var sig, comps, sum, trig;
	sig = SinOsc.kr(0.3, 0, 1).abs;
	comps = { | i | i / 9 < sig} ! 9;
	sum = comps.sum;
	trig = Changed.kr(sum);
	Out.kr(0, [sig] ++ comps ++ [sum / 10, trig]);
	0.1 * WhiteNoise.ar(Env.perc(0.01, 0.1).kr(gate: trig));
} +> \ctls;
//:Code more compactly and try with different control ugen sources
{
	var ctl;
	ctl = LFSaw.kr(0.3).abs;
	0.1 * WhiteNoise.ar(Env.perc(0.01, 0.1)
		.kr(gate: Changed.kr(({ | i | i / 9 < ctl} ! 9).sum)));
} +> \ctls;
//:Code more compactly and try with different control ugen sources
{
	var ctl;
	ctl = LFTri.kr(0.3).abs;
	0.1 * WhiteNoise.ar(Env.perc(0.01, 0.1)
		.kr(gate: Changed.kr(({ | i | i / 9 < ctl} ! 9).sum)));
} +> \ctls;
//:Change the density of beats by changing the comparison level quotient
{
	var ctl, quot;
	ctl = LFTri.kr(0.3).abs;
	quot = LFSaw.kr(1/60).range(1, 9);
	0.1 * WhiteNoise.ar(Env.perc(0.01, 0.1)
		.kr(gate: Changed.kr(({ | i | i / quot < ctl} ! 9).sum)));
} +> \ctls;
//:Use noisy curves as control UGen for the trigger
{
	var ctl;
	ctl = LFNoise2.kr(1).range(0, 0.9);
	0.1 * WhiteNoise.ar(Env.perc(0.01, 0.1)
		.kr(gate: Changed.kr(({ | i | i / 20 < ctl} ! 20).sum)));
} +> \ctls;
//:Use Dust as trigger
// compare this pattern to using noisy curve as trigger control.
{
	0.1 * WhiteNoise.ar(Env.perc(0.01, 0.1)
		.kr(gate: Dust.kr(5))
	);
} +> \ctls;
