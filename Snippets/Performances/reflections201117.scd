//:  17 Nov 2020 11:46 Load audio files.
/*
Load audio files.
Prepare XBee to bus data reception.
Prepare playback tracks controlled by XBee.
*/
//:Load audio files ================
//:prep test - find matching files
"/home/iani/sounds/Reflections".matchType("wav"); 
//:load buffers from matches
"/home/iani/sounds/Reflections".matchType("wav") do: { | path |
	var buffer, bufname;
	// buffer = path.readBuffer;
	bufname = PathName(path).fileNameWithoutExtension.asSymbol;
	bufname.postln;
	Library.put(\buffers, bufname, path.readBuffer);
};
//:test one loaded buffer
\pilgrims.buf.play;
//:
//:Test buffer playback with control from bus
{
	PlayBuf.ar(1, \pilgrims.bn, \rate.kr(1), \trig.kr(1),
	\startPos.kr(0), \loop.kr(1), 2).stereo;
} +> \btest1;
//:
\testbus @>.rate \btest1;
//:
\testbus <@ 0.5;
