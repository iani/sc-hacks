//  9 Mar 2019 11:47
// Testing SImpleDef

() +> \sc;

//:
SimpleDef("plain", { WhiteNoise.ar() });
//:
SimpleDef("plain2", { | freq | SinOsc.ar(freq) });
//:
SimpleDef.perc("perc1", { | freq | SinOsc.ar(freq) });
//:
SimpleDef.asr("asr1", { | freq | SinOsc.ar(freq) });
//:
(instrument: \plain2, degree: [-10, 10].pwhite) +> \sc;
//:
(instrument: \perc1) +> \sc;
//:
(instrument: \asr1) +> \sc;
//:asr - testing legato
(legato: (0.1, 0.2..1.5).pseq) +> \sc;
//:asr - testing legato
(dur: 0.25) +> \sc;
//:additional parameters
SimpleDef.asr("lohi1", { | freq |
	SinOsc.ar(freq + SinOsc.kr(
		\rate.kr(5)
	).range(\lo.kr(0), \hi.kr(50)))
});
//:additional parameters
SimpleDef.sine("sine1", { | freq |
	SinOsc.ar(freq + SinOsc.kr(
		\rate.kr(5)
	).range(\lo.kr(0), \hi.kr(50)))
});
//:
(instrument: \lohi1) +> \lohi;
//:
(instrument: \sine1) +> \lohi;
//:testing extra control params
(rate: [1, 20].pwhite) +> \lohi;
//:
(legato: 0.2, dur: 2) +> \lohi;
//:
(instrument: \lohi1, legato: 0.02, dur: 0.5) +> \lohi;
//:
(instrument: \plain, legato: 0.02, dur: 0.5) +> \lohi;
//:
(instrument: \plain, legato: 2, dur: 0.5) +> \lohi;
//:
(instrument: \lohi1, legato: 2, dur: 2.5, degree: [0, 4].prand) +> \lohi;
//:testing release node with release ================================================================
SimpleDef.fade(\fade, { | freq | SinOsc.ar(freq) });
//:
a = Synth(\fade);
//:*
a = Synth(\fade);
1.wait;
"freeing now".postln;
a.free;
4.wait;
a = Synth(\fade);
1.wait;
"releasting now".postln;
a.release;
1.wait;
a = Synth(\fade);
1.wait;
"release 5 now".postln;
a release: 5;
5.wait;
//:test fade with pattern
(instrument: \fade, degree: [0, 4].pseq) +> \fade;
//:
(dur: 0.1) +> \fade;
//:
(legato: 2) +> \fade;
//:
(legato: 0.2) +> \fade;
//:
(legato: 1.02) +> \fade;
//:
(dur: 1) +> \fade;
//:
(degree: [0, 2, 4].pseq) +> \fade;