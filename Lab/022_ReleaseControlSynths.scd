//  5 Oct 2017 18:43
// Fixed:  6 Oct 2017 10:42
/* Release control synths mapped to parameters when:
	- a new control synth is mapped
	- a numeric value is stored in the param, setting the synth's control input,
	  and invalidating the mapping to the control rate synth. 

Testing before implementing:
*/
//: The control syth does not stop when we set the corresponding parameter.
\default.play;
//:
\freq <+ { LFNoise1.kr(1.5).range(300, 3000) };
//:
~freq = 100;
//: Listen to change notifications when setting the parameter
\default.e.addDependant({ | ... args | args.postln; });
//:
\default.play;
//:
~freq = 1400;
//:
\default.stop;