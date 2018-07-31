// Loading all wav, aif, aiff audio files in a folder.
//:preload files in a folder.
(Sch.homedir ++ "Sounds/lindrum/").loadBuffers;
//:list loaded buffers
Library.at(\buffers).keys.postln;
//:test one file.
\sdl.b.play;
//:play all loaded buffers
{
	var buffers, dur;
	buffers = Library.at(\buffers).keys.asArray.sort;
	postf("Playing % buffers\n", buffers.size);
	buffers do: { | b, i |
		dur = b.b.numFrames / b.b.sampleRate;
		postf("playing buffer number %, name %, duration %\n", i, b, dur);
		b.b.play;
		dur.wait;
	};
	"DONE".postln;
}.fork;
