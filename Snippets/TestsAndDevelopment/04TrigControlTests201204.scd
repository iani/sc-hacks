//:  4 Dec 2020 14:32
/* can we make TrigControl not to trigger immediately upon creation?
Purpose: Trigger the release of an envelope internally
*/
//:tr always triggers on creation - so not useful here
{
	WhiteNoise.ar(0.1) * Env.perc.kr(gate: \trig.tr(0));
} +> \test;
//:Use TDuty instead. First try (from help file)
{ TDuty.ar(Dseq([0.1, 0.2, 0.4, 0.3], inf)) } +> \test;
//:Triger an envelope with it
{
	var trig;
	trig = TDuty.kr(Dseq([0.1, 0.2, 0.4, 0.3] * 2, inf));
	WhiteNoise.ar(0.3).dup * Env.perc.kr(gate: trig);
} +> \test;
//:From another help example
{
	var trig;
	trig = TDuty.ar(
		Dseq([0.1, 0.2, 0.4, 0.3], inf), // demand ugen as durations
		0,
		Dseq([0.1, 0.4, 2.01, 0.5, 1.0], inf) // demand ugen as amplitude
	);
	Ringz.ar(trig, LFNoise1.kr(1/5).exprange(500, 4000), 0.5).dup

} +> \test;
//:Do not repeat
{
	var trig;
	trig = TDuty.ar(
		Dseq([0.1, 0.2, 0.4, 0.3], 1), // demand ugen as durations
		0,
		Dseq([0.1, 0.4, 2.01, 0.5, 1.0], inf) // demand ugen as amplitude
	);
	Ringz.ar(trig, LFNoise1.kr(1/5).exprange(500, 4000), 0.5).dup

} +> \test;
//:Only 2 triggers
{
	var trig;
	trig = TDuty.ar(
		Dseq([1], 1), // demand ugen as durations
		0,
		Dseq([1, 1], 1) // demand ugen as amplitude
	);
	Ringz.ar(trig, LFNoise1.kr(1/5).exprange(500, 4000), 0.5).dup

} +> \test;
//:Only 1 trigger (the first one has 0 amplitude)
{
	var trig;
	trig = TDuty.ar(
		Dseq([1], 1), // demand ugen as durations
		0,
		Dseq([0, 1], 1) // demand ugen as amplitude
	);
	Ringz.ar(trig, 5000, 0.5).dup

} +> \test;

//:Use to release an envelope
{
	var trig;
	trig = TDuty.ar(
		Dseq([1], 1), // demand ugen as durations
		0,
		Dseq([1, 1], 1) // demand ugen as amplitude
	);
	WhiteNoise.ar(0.5).dup * Env.adsr.kr(gate: trig);
} +> \test;
