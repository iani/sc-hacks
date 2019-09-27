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
