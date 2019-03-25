// Playing synthdefs, functions and patterns
//:play a synthdef by name
\default +> \mysound;
//:play a function
{ SinOsc.ar(\freq.kr(400), 0, 0.1) } +> \mysound;
//:play a pattern
// Per default, patterns start synchronized on a TempoClock beat
// We disable this for the demo, by setting \quant to 0:
\quant <+ 0;
(dur: 0.1, degree: Pbrown(-10, 10, 2)) +> \mysound;
//:sending nil to the player stops it
nil +> \mysound;
//:the player can be restarted
\mysound.start;
//:play a different synth
// NOTE: BOTH PATTERNS AND SYNTHS CAN BE RESTARTED
{ PinkNoise.ar(0.1).stereo } +> \mysound
//:stop the synth
\mysound.stop;
//:restart the synth
\mysound.start;
//:back to default synthdef to end this part
\default +> \mysound;
//:toggle a players state on-off
\mysound.toggle;