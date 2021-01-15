//: 15 Jan 2021 18:22
/*
Before first tries triggering envelope multiple times with a control signal

Prelims: Review of bus mapping syntax
*/
//:================================================================
//:A. Approach 1: map control to bus.
//1. Play a function with freq as control in player \test
{ | freq = 2400 | SinOsc.ar(freq, 0, 0.2).dup } +> \test;
//:2. Set the target bus to a desired value
\freqbus.bus.set(1200);
//:3. Map the freq parameter in player bus to the target bus \freqbus
\freqbus @>.freq \test;
//:4. play a control function ot the target bus \freqbus
{ LFNoise1.kr(5).range(1000, 1500) }  @> \freqbus;
//:5. play a different function in player test
{ LFDNoise1.ar(\freq.kr(100), 0.5).dup } +> \test;
//:6. play a different control function to the same bus
{ LFNoise0.kr(25).range(700, 2500) }  @> \freqbus;

//================================================================
//:B. Approach 2: get bus as input in player's function
//:Earlier code - for cleanup
//:Prelims: Review of bus mapping syntax
\freqbus.bus.set(1500);
//:// read explicitly from the named bus
{ SinOsc.ar(\freqbus.bin, 0, 0.2).dup } +> \test;
//:
{ LFNoise1.kr(10, 1000, 1500) }  @> \freqbus;

