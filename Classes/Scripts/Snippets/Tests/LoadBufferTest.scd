/* Try executing any snippets below in any order

*/
//:preload buffers
(Hacks.homedir ++ "Sounds/lindrum/").loadBuffers;
//:list loaded buffers
(Library.at(\buffers) ? ()).keys.postln;
//:look at one buffer
Library.at(\buffers).keys.asArray.first.b.postln;
//:play one buffer
Library.at(\buffers).keys.asArray.first.b.play;
//:play all buffers
{
	Library.at(\buffers).keys.asArray do: { | k |
		k.b.postln.play;
		(k.b.numFrames / 44100 + 0.1).wait;
	};
	"DONE".postln;
}.fork;
