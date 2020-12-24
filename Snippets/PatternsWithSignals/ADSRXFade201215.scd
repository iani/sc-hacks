//: 14 Dec 2020 18:09 adsr and cross fade 
/* 
Testing the details
*/
//:shape of adsr
Env.adsr.plot;
//:adapt to xfade?
Env.adsr(1, 1, 1, 1).plot;
//:reverse attack curve?
Env.adsr(1, 1, 1, 1, curve: [4, -4, -4, -4]).plot;
//:+Testing with a source - this does not seem to work
var func, synth;
func = { PinkNoise.ar(0.1).dup };
synth = {   func *
	Env.adsr(3, 1, 1, 3, curve: [4, -4, -4, -4]).kr(2, gate: \trig.kr(1));
}.play;
(5..0) do: { | i |
    1.wait;
    postf("releasing in %\n", i);
};
"released!".postln;
synth.set(\trig, 0);
//:*Testing the above with different envelope shapes
var func, synth;
func = { PinkNoise.ar(0.1).dup };
[[4, -4, -4, -4], [8, -4, -4, -8], [-4, -4, -4, 4], [0, -4, -4, 0]] do: { | curves |
	postf("now testing curve: %\n", curves);
	synth = {   func *
		Env.adsr(3, 1, 1, 3, curve: curves.postln).kr(2, gate: \trig.kr(1));
	}.play;
	(5..0) do: { | i |
		1.wait;
		postf("releasing in %\n", i);
	};
	"released!".postln;
	synth.set(\trig, 0);
	3.wait;	
};
//:*Testing the above with sc-hacks
var func;
func = { PinkNoise.ar(0.1).dup };
[[4, -4, -4, -4], [8, -4, -4, -8], [-4, -4, -4, 4], [0, -4, -4, 0]] do: { | curves |
	postf("now testing curve: %\n", curves);
	\trig <+.test 1;
	{   func *
		Env.adsr(3, 1, 1, 3, curve: curves.postln).kr(2, gate: \trig.kr(1));
	} +> \test;
	(5..0) do: { | i |
		1.wait;
		postf("releasing in %\n", i);
	};
	"released!".postln;
	\trig <+.test 0;
	3.wait;	
};
