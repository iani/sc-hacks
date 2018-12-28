// Link many writers to one reader using *>
\sourcem21a *> \effectm21;
\sourcem21b *> \effectm21;
{ WhiteNoise.ar(0.1) } +> \sourcem21a;
{ SinOsc.ar(LFNoise0.kr(5).range(200, 2000), 0, 0.1) } +> \sourcem21b;
{ In.ar(\in.kr(0)) * Decay.kr(Impulse.kr(1)) }  +> \effectm21;