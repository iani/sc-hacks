//: 16 Jan 2021 01:48
/*
Triggering with a control bus.
This can be shared amongs synths to ensure coordination of beats.

Procedure:




*/
// Tests - demos:
//:the audio player to be controlled
{ | trig = 0 | WhiteNoise.ar(Decay.kr(trig)).dup } +> \test;
//:Map the trig parameter in player bus to the target bus \trigbus
\trigbus @>.trig \test;
//:Play a control function ot the target bus \freqbus
{ Impulse.kr(1) }  @> \trigbus;
//:Try triggering with envelope instead of Decay
{ WhiteNoise.ar(0.1 * Env.perc.kr(0, \trig.kr)).dup } +> \test;
// Try various other types of envelopes
//:
{ WhiteNoise.ar(Env.triangle(0.1, 0.3).kr(0, \trig.kr)).dup } +> \test;
//:
{ WhiteNoise.ar(0.1 * Env.linen(0.01, 0.02, 0.02).kr(0, \trig.kr)).dup } +> \test;
//:Try different tempi. All of the following work with the short linen env above
{ Impulse.kr(3) }  @> \trigbus;
{ Impulse.kr(5) }  @> \trigbus;
{ Impulse.kr(15) }  @> \trigbus;
//:Try using demand ugen to play different beat patterns
