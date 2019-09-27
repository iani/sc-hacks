Ndef(\pad).fadeTime = 10;
Ndef(\click).fadeTime = 10;
//:
(
Ndef(\pad, {
	var src;
	src = Formants.ar(([1, 2, 3, 4] *.t [31, 50].midicps * {LFNoise1.kr(10, 0.003, 1)}!4).flat, Vowel([\u, \e], [\bass, \tenor, \soprano]), 
		freqMods: LFNoise2.ar(1*[0.1, 0.2, 0.3, 0.4, 0.5].scramble, 0.1), unfold: true).sum * 0.1;
	Splay.ar(src.flat.scramble)
}).play
)
//:
(
Ndef(\click, {
	var src, in;
	var mods = LFNoise2.ar(#[0.1, 0.2, 0.3, 0.4, 0.5].scramble 
		* {LFNoise1.ar(0.1).range(0.125, 4)}!5, 0.01);
	
	in = Impulse.ar(75 * [1, 0.66, 0.75, 2.33, 0.2387], mul: 1);
	src = Vowel([\a, \o, \e, \i, \u].scramble, [\bass, \bass, \soprano])
		.collect{|vowel, i|
	BPFStack.ar(
		(PinkNoise.ar * 0.0125) + 
			in[i], 
		vowel,
		freqMods: mods[i] + 1.1,
		unfold: true
	)};
	Splay.ar(src.flat.scramble)
}).play
)