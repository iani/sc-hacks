//: 18 Nov 2020 01:47 Linking audio synths with sc-hacks
/*

*/
//:Preliminary tests: compare linked pairs.
\src1 *> \fx1;
{ WhiteNoise.ar(0.1) } +> \src1;
{ Resonz.ar(Inp.ar, LFNoise0.kr(5).range(100, 2000), 0.1, 5).dup } +> \fx1;
//:change the source
{ LFNoise2.ar(5, 0.1).range(500, 4000) } +> \src1;
//:change the effect
{ Resonz.ar(Inp.ar, LFNoise2.kr(5).range(100, 2000), 0.1, 5).dup } +> \fx1;
//:
\src2 *> \fx2;
{ WhiteNoise.ar(0.1) } +> \src2;
{ LPF.ar(Inp.ar, 400) } +> \fx2;
//:======================================================
//:Case 1: many to 1.
//:Preliminaries: test 2 easily distinguishable sources
{ WhiteNoise.ar(Env.perc.kr(gate: LFPulse.kr(2))) / 4 } +> \s1;
{ SinOsc.ar(LFNoise0.kr(4).range(400, 2000), 0, 0.1) } +> \s1;
//:Create 2 many-to-1 links
\m1src1 *> \m1fx1;
\m1src2 *> \m1fx1;
//:play the sources
{ WhiteNoise.ar(Env.perc.kr(gate: LFPulse.kr(2))) / 4 } +> \m1src1;
{ SinOsc.ar(LFNoise0.kr(4).range(400, 2000), 0, 0.1) } +> \m1src2;
//:play the effect;
{ Inp.ar * LFPulse.kr(1, iphase: [0, 0.5])} +> \m1fx1;
//:change the effect
{ Inp.ar * LFSaw.kr(1/2, iphase: [0, 0.5])} +> \m1fx1;
//:change the effect again
{ Inp.ar * LFTri.kr(1/8, iphase: [0, 0.5])} +> \m1fx1;
//:================================================================
//:Case 2: 1 to many.
// FOR CLARITY, EACH EFFECT IS SET TO PLAY IN A SEPARATE CHANNEL
// Open a scope with 4 channels to see all outputs
//:Test source: Saw waveform.
{ LFSaw.ar(35.15, 0, 0.1) } +>\testsaw;
//:Link \testsaw to \o2m1, \o2m2, \o2m3;
\testsaw *< \o2m1;
\testsaw *< \o2m2;
\testsaw *< \o2m3;
//:Play inverse of source in \o2m1;
{ Out.ar(1, Inp.ar) } +> \o2m1;
//:Play positive part of source in \o2m2
{ Out.ar(2, Inp.ar > 0 * Inp.ar) } +> \o2m2;
//:Play inverted positive part of source in \o2m3
{ Out.ar(3, Inp.ar > 0 * Inp.ar * -1) } +> \o2m3;