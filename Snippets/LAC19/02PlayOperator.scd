// The play operator: +>
// Play SynthDefs, Functions and Patterns interchangeably in Players
//:2a Play a synthdef by name
//:2a1 Define new SynthDef
// Use SimpleDef utility class from sc-hacks
SimpleDef(\formant, { | freq | Formant.ar(freq, \form.kr(1760), \bw.kr(880)) });
//:2a2 Play the new SynthDef
\formant +> \mysound;
//:2b Play a function (as in Function:play)
{ Resonz.ar(PinkNoise.ar(0.5), \freq.kr(440), \bwr.kr(0.02).dup) } +> \mysound
//:2c Play a pattern in the same player
// Per default, patterns start synchronized on a TempoClock beat
// We disable this for the demo, by setting \quant to 0:
\quant <+ 0;
(dur: 0.1, degree: Pbrown(-10, 10, 2)) +> \mysound;
//:Sending nil to a player stops it
nil +> \mysound;
//:Players restart with their last saved source
\mysound.start;
//:Patterns can be modified on the fly
// Specify custom synthdef as instrument
(instrument: \formant, amp: 0.01) +> \mysound
//:modify duration
(dur: [0.1, 0.2].prand) +> \mysound;
//:modify form and bw parameters in pattern
(form: [100, 3000, 100].pbrown, bw: [200, 3000, 100].pbrown) +> \mysound;
//:modify duration: play faster
(dur: 0.05) +> \mysound;
//:modify legato
(legato: [0.1, 0.1, 0.1, 0.05, 5].prand) +> \mysound;
//:slower
(dur: 0.2) +> \mysound;
//:amplitude
(amp: 0.25) +> \mysound;

//:stop
\mysound.stop;