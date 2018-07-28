// Link one writer to many readers using *<
// preliminary tests have no effect. Need to redo.
\sourcem21 *< \effectm21a;
\sourcem21 *< \effectm21b;
{ WhiteNoise.ar(0.1) } +> \sourcem21;
// { SinOsc.ar(LFNoise0.kr(5).range(200, 2000), 0, 0.1) } +> \sourcem21b;
{ Pan2.ar(LPF.ar(In.ar(\in.kr(0)), 800) * 3 * Decay.kr(Impulse.kr(1)), -1) }  +> \effectm21a;
{ Pan2.ar(HPF.ar(In.ar(\in.kr(0)), 1800) * Decay.kr(Impulse.kr(1, 0.5)), 1) }  +> \effectm21b;
//:Change effects
{ Pan2.ar(Ringz.ar(In.ar(\in.kr(0)) * 0.05, LFNoise1.kr(0.2).range(400, 4000)), -1) * 0.1 }  +> \effectm21a;
{ Pan2.ar(HPF.ar(In.ar(\in.kr(0)), LFNoise1.kr(2).range(100, 4000)) * Decay.kr(Impulse.kr(4, 0.5)), 1) }  +> \effectm21b;
//:Change effects again. pan
{ { Ringz.ar(In.ar(\in.kr(0)) * 0.05, LFNoise1.kr(0.2).range(400, 4000)) * 0.1 }  ! 2 }  +> \effectm21a;
{ { HPF.ar(In.ar(\in.kr(0)), LFNoise1.kr(2).range(100, 4000)) * Decay.kr(Impulse.kr(4, 0.5)) } ! 2 }  +> \effectm21b;
//: