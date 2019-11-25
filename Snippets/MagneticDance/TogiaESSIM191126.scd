// =====================================================================
// SuperCollider Workspace
// =====================================================================
//:manual range
{ SinOsc.ar(\freq.kr() * 10000 + 20, 0, 0.01).stereo; } +> \test;
//:test own operator: urange
{ SinOsc.ar(\freq.kr().urange(20, 10000), 0, 0.01).stereo; } +> \test;
//;test own linexp
{ SinOsc.ar(\freq.kr().linexp(20, 10000), 0, 0.01).stereo; } +> \test;
//:compare urange with linexp
{ | freq = 0 |
	SinOsc.ar(
	[freq.linexp(20, 10000), freq.urange(20, 10000)],
	0, 0.1); } +> \test;
//:manual range modified
{ SinOsc.ar(\freq.kr() * 20000 + 120, 0, 0.01).stereo; } +> \test;
//:
\test.map(\freq, \testbus);
//:
\testbus.bus.set(0.06);
//:*
(0, 0.001 .. 1) do: { | f |
\testbus.bus.set(f);
0.05.wait;
};
//:
ControlSpec
//:
{ WhiteNoise.ar(0.05).stereo } +> \test;

//:just playback
{
	var src;
	src = In.ar(2);
	src;
} +> \test;
//:stereo playback
{
	var src;
	src = In.ar(2);
	src.stereo;
} +> \test;
//:ringz
{
	var src;
	src = In.ar(2);
	src = Ringz.ar(src, (1..5) * 100, 0.1);
	src = Mix(src * 0.1);
	src.stereo;
} +> \test;
//:ringz on harmonics of low B
{
	var src;
	src = In.ar(2);
	src = Ringz.ar(src, (59 - 12).midicps * (1..8), 0.3);
	src = Mix(src * 0.1);
	src.stereo;
} +> \test;
//: TUNING!!!!!
{ SinOsc.ar((59 - 12).midicps, 0, 0.3).stereo } +> \test;
//:SERVER METER
Server.default.meter;
//:magabove test 1
{
	var src, chain;
	src = In.ar(2);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagAbove(chain, \thresh.kr(0.1));
	Pan2.ar(IFFT(chain), \pan.kr(0));
} +> \ide;
//:tune thresh param;
\thresh <+ 10;
//:magbelow test 1
{
	var src, chain;
	src = In.ar(2);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagBelow(chain, \thresh.kr(0.1));
	Pan2.ar(IFFT(chain) * 50, \pan.kr(0));
} +> \ide;
//:
\thresh <+ 0.01;
//:magclip test 1
{
	var src, chain;
	src = In.ar(2);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagClip(chain, \thresh.kr(0.1));
	Pan2.ar(IFFT(chain) * 2, \pan.kr(0));
} +> \ide;
//:
\thresh <+ 10;
//:magsmear test 1
{
	var src, chain;
	src = In.ar(2);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagSmear(chain, \thresh.kr(0.1));
	Pan2.ar(IFFT(chain), \pan.kr(0));
} +> \ide;
//:
\thresh <+ 20;
//:binshift test 1
{
	var src, chain;
	src = In.ar(2);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BinShift(chain, \stretch.kr(0.1), \thresh.kr(0.1));
	Pan2.ar(IFFT(chain), \pan.kr(0));
} +> \ide;
//:
\stretch <+ 1;
//:
\thresh <+ 20;
//:
69.midicps;
//:

69.midicps;
//:
60.midicps
//:
59.midicps;
//:
(59 - 12).midicps;
//:


