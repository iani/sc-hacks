//: a text:
(
{
var text;
text = "The tao that can be told
is not the eternal Tao
The name that can be named
is not the eternal Name.

The unnamable is the eternally real.
Naming is the origin
of all particular things.

Free from desire, you realize the mystery.
Caught in desire, you see only the manifestations.

Yet mystery and manifestations
arise from the same source.
This source is called darkness.

Darkness within darkness.
The gateway to all understanding.";
text.size; // 432 characters;
text.split($ ).size; // 60 words
/*
// version 1 - first test
	// each char is a midinote
text do: { | char |
	[char, char.ascii].postln;
	(midinote: char.ascii).play;
	0.2.wait;
};
"THE END".postln;
*/
// verson 2: play each word as a phrase
text.split($ ) do: { | word |
	word do: { 
		//	[char, char.ascii].postln;
	(midinote: char.ascii, dur: 0.1).play;
		0.1.wait;
	};
	// pause 1 second between words.
	1.wait;
};
	"DONE".postln;
}.fork;
)
//:
