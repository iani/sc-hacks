//:  17 Nov 2020 11:46 Load audio files.
/*
Load audio files.
Prepare XBee to bus data reception.
Prepare playback tracks controlled by XBee.
*/
//:Load audio files ================
//:prep test - find matching files
"/home/iani/sounds/Reflections".matchType("wav");
//:
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
//:Test buffer playback with control from bus - controlling rate
{
	PlayBuf.ar(1, \kiiroi.bn, X(1).range(0.0125, 0.5).lag(0.5), \trig.kr(1),
	\startPos.kr(0), \loop.kr(1), 2).stereo;
} +> \kiiroi;
//:Test buffer playback with control from bus - controlling rate
{
	PlayBuf.ar(1, \pilgrims.bn, Y(1).range(0.0125, 0.5).lag(0.5), \trig.kr(1),
	\startPos.kr(0), \loop.kr(1), 2).stereo;
} +> \pilgrims;
//:Test buffer playback with control from bus - controlling rate
{
	PlayBuf.ar(1, \sweet_crickets.bn, Z(1).range(0.0125, 0.5).lag(0.5), \trig.kr(1),
	\startPos.kr(0), \loop.kr(1), 2).stereo;
} +> \crossing;
//:
Library.at(\buffers).keys
//:
\testbus @>.rate \btest1;
//:
\testbus <@ 0.5;
//:
SenseBus.activate;
SenseBus.mute;
//:x = vertical axis up down
{ SinOsc.ar(X(1).range(200, 1600), 0, 0.01).dup } +> \test;
//: horizontal axis rotation left right
{ SinOsc.ar(Y(1).range(200, 1600), 0, 0.1).dup } +> \test;
//: horizontal axis rotation left - right
{ SinOsc.ar(Z(1).range(400, 800), 0, 0.1).dup } +> \test;
//:
{
	(
		SinOsc.ar(X(1).range(200, 1600), 0, 0.01) +
		SinOsc.ar(Y(1).range(200, 1600), 0, 0.01) +
		SinOsc.ar(Z(1).range(200, 1600), 0, 0.01)
	).dup * 2 } +> \test;



{ Mix(
	SinOsc.ar(X(1).range(400, 800), 0, 0.1),
	SinOsc.ar(Y(1).range(400, 800), 0, 0.1),
	SinOsc.ar(Z(1).range(400, 800), 0, 0.1)
).dup } +> \test;
//:
SenseServer.record;
//:
SenseServer.stopRecording;