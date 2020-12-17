//:multichannel expansion, phase and envelope triggering
/* 18 Nov 2020 00:09

*/
//:
{ WhiteNoise.ar(LFPulse.kr(1/8, iphase: (0..7) / 7, mul: 0.2, width: 1/8)) } +> \test;
//:
{
	WhiteNoise.ar(
		Decay.kr(LFPulse.kr(1/8, iphase: (0..7) / 7, mul: 0.2, width: 1/8), 0.1, 0.1)
	)
} +> \test;
//:
{ WhiteNoise.ar(Env.adsr.kr(gate: \trig.kr(0))) } +> \env;
//:
\trig <+ 1;
//:
\trig <+ 0;
//:
{ WhiteNoise.ar(Env.adsr.kr(gate: LFPulse.kr(1))) } +> \env;
//:
{ Out.ar(1, SinOsc.ar(400, 0, Env.adsr.kr(gate: LFPulse.kr(1)))) } +> \env;
//:
{ 1/4 * WhiteNoise.ar(Env.adsr.kr(gate: LFPulse.kr(1/8, iphase: (0..7) / 7))) } +> \env;
//:
{ 1/4 * WhiteNoise.ar(Env.adsr.kr(gate: LFPulse.kr(1/8, width: 0.1, iphase: (0..7) / 7))) } +> \env;
//:
{ SinOsc.ar(((1..8)+80).midicps,
	0,
	Env.adsr.kr(gate: LFPulse.kr(1/8, width: 0.1, iphase: (0..7) / 7)))
} +> \env;