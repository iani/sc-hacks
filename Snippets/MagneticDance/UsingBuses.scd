/*  4 Nov 2018 14:31

Trying new approach: All sensor data are set to buses. A class helps synths to address the bus corresponding to a desired sensor, with the desired scaling.

*/
//:0. Testing bus mapping. Stage 1: Use Bus class.
// \freq <+ 440;
{ SinOsc.ar(\freq.kr(440), 0, 0.1) } +> \test;
//:
\freq <+ \freq;
//:
// currentEnvironment;
\freq.bus.set(500);