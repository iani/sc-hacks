//: 15 Jan 2021 18:22
/*
Before first tries triggering envelope multiple times with a control signal

Prelims: Review of bus mapping syntax

2 Approaches: 

1. Map a bus to a control of a synth.

2. Read a control signal from a bus inside a synth.
 
*/
//:================================================================
//:A. Approach 1: map control to bus.
\freqbus @>.freq \test; // map control freq to bus freqbus
{ LFNoise0.kr(5).range(1000, 1500) }  @> \freqbus; // play control func in bus
{ | freq = 2400 | Pulse.ar(freq, mul: 0.1).dup } +> \test;

//:================ Features: ================
//:Play a different func in the player. The parameter mapping remains
{ | freq = 2400 | SinOsc.ar(freq, mul: 0.3).dup } +> \test;
//:Play a new control func in the bus, replacing the previous control synth
{ LFNoise1.kr(15).range(1000, 1700) }  @> \freqbus;

//:================================================================
//:B. Approach 2: Read from a control bus inside the synthfunc.
{ SinOsc.ar(\freqbus.bin * [1, 5/4], 0, 0.2) } +> \test2;
{ Decay.kr(Dust.kr(5)).range(1000, 1700) }  @> \freqbus;
