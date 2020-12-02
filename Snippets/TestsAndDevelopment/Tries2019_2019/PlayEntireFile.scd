/* Demo of evaluating an entire file at once */
//:preload include /SoundFiles/ default lindrum
//:pattern
(dur: [0.1.dup(20), 1, 2, 3].flat.prand, degree: [10, 40, 5].pbrown) +> \pattern;
//:synth
{ WhiteNoise.ar(Decay.kr(Dust.kr([5, 5]))) * 0.1 } +> \synth;
//:play all buffers in random order
{
	Library.at(\buffers).keys.asArray.prand.asStream do: { | k |
		k.b.postln.play;
		(k.b.numFrames / 88200 /* 44100 + 0.1 */).wait;
	};
}.fork;
