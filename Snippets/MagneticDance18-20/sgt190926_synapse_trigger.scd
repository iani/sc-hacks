//:Synapsewear connection
/* Synapseware data format: 
/synapseWear, time, status, x, y, z, ...
*/
BusOsc.watch(\synapse, //name
	// bus   osc  index min max
	[\sx, \synapseWear, 2, (2**15).neg + 1, 2**15],
	[\sy, \synapseWear, 3, (2**15).neg + 1, 2**15],
	[\sz, \synapseWear, 4, (2**15).neg + 1, 2**15],
)
//:Maybe this scaling is better
BusOsc.watch(\synapse, //name
	[\sx, \synapseWear, 2, -2e4, 2e4],
	[\sy, \synapseWear, 3, -2e4, 2e4],
	[\sz, \synapseWear, 4, -2e4, 2e4],
)
//:Sound Test1
//:sound for testing again
{ WhiteNoise.ar(Env.perc.kr(levelScale: 0.1, gate: \amp.kr(0.1, 0.1) > 0.5))} +> \test;
//;map
// envir  param  bus
\test.map(\amp, \sx);
//:add Resonance
{
	var src;
	src = WhiteNoise.ar(Env.perc.kr(levelScale: 0.05, gate: \amp.kr(0.1, 0.1) > 0.5));
	Ringz.ar(src, \freq.kr(0.1, 0.5).range(100, 2000), 2)
} +> \test;
//map envir  param  bus
\test.map(\amp, \sx);
// add freq
\test.map(\freq, \sy)

//:Scale resonance to prepare multichannel
{
	var src;
	src = WhiteNoise.ar(Env.perc.kr(levelScale: 0.05, gate: \amp.kr(0.1, 0.1) > 0.5));
	Ringz.ar(src, 100 * (1 + \freq.kr(0.1, 0.5)), 2).stereo
} +> \test;
//map envir  param  bus
\test.map(\amp, \sx);
// add freq
\test.map(\freq, \sy)

//:Multichannel resonance
{
	var src;
	src = WhiteNoise.ar(Env.perc.kr(levelScale: 0.005, gate: \amp.kr(0.1, 0.1) > 0.5));
	src = Ringz.ar(src, 100 * ((2, 2.25 .. 5) + \freq.kr(0.1, 0.5)), 2);
	Mix(src).stereo;
} +> \test;
//map envir  param  bus
\test.map(\amp, \sx);
// add freq
\test.map(\freq, \sy)

//:sine envelope + Multichannel resonance
{
	var src, freq;
	freq = \freq.kr(0.1, 0.5);
	src = WhiteNoise.ar(Env.sine(0.1 * (1 + (\dur.kr(1) * 10)))
		.kr(levelScale: 0.005, gate: \amp.kr(0.1, 0.1) > 0.5));
	src = Ringz.ar(src, 100 * ((2, 2.25 .. 5) + freq), 2);
	Mix(src).stereo;
} +> \test;
//map envir  param  bus
\test.map(\amp, \sx);
\test.map(\freq, \sy); // add freq
\test.map(\dur, \sz)   // dur
// ================================================================
// BEATS
//:Try1
(degree: 20, dur: 0.1) +> \beats;
//
//:Try2
~freqs = [4000, 5000];
(freq: Pseq(~freqs, inf), dur: 0.5) +> \beats;
//:
~freqs[1] = 2000;