Hacks.listAudioBuffers;
//:setup sensors
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\testbus1_x, 1, 0.47, 0.53, 1],
	[\testbus1_y, 2, 0.47, 0.53, 1],
	[\testbus1_z, 3, 0.47, 0.53, 1],
	[\testbus2_x, 1, 0.47, 0.53, 2],
	[\testbus2_y, 2, 0.47, 0.53, 2],
	[\testbus3_z, 3, 0.47, 0.53, 2]
);

//:playback prologue - find start
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(1, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(10) * 44100, 1).stereo;
} +> \playbufstereo;
//:iannis
\playbufstereo.map(\rate, \testbus2_y);
//:change period. + start point
\period <+.playbufstereo 30.2; // keep this
\startpos <+.playbufstereo 790.2;
\rate <+.playbufstereo 0.2;
//:
//:
\playbufstereo *> \pvsmear;
//:binshift test 1
{
	var src, chain;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BinShift(chain, \stretch.kr(0.1) * \sf.kr(1), \thresh.kr(0.1) * 2);
	Pan2.ar(IFFT(chain), \pan.kr(0));
} +> \pvsmear;
//:
\pvsmear.map(\stretch, \testbus1_x, \thresh, \testbus1_y, \sf, \testbus1_z);
//:magabove test 1
{
	var src, chain;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagAbove(chain, \thresh.kr(0.1).urange(0.001, 2.5));
	Pan2.ar(IFFT(chain), \pan.kr(0)) * 5;
} +> \pvsmear;
//:magbelow test 1
{
	var src, chain;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagBelow(chain, \thresh.kr(0.1).urange(0.001, 102.5));
	Pan2.ar(IFFT(chain), \pan.kr(0)) * 5;
} +> \pvsmear;
//:
\pvsmear.map(\thresh, \testbus2_x);
//:magsmear test 1
{
	var src, chain;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagSmear(chain, \thresh.kr(0.1).urange(0.01, 10));
	Pan2.ar(IFFT(chain), \pan.kr(0)) * 2;
} +> \pvsmear;

//:
\stretch <+ 1;
\thresh <+ 0.5;
//;
\pvsmear.map(\stretch, \testbus1_x, \thresh, \testbus1_y, \sf, \testbus1_z);
//:

//:
\period <+ 30;
//:playback prologue - play for limited duration with playFor
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(1), \trig.kr(1),
		44100 * 10, 1).stereo
}.playFor(\playbufstereo, 6.5);
//:try playBuf
//                            startpos, dur
\prologue.playBuf(\playbufmono, 10, 6.5);
//:try playBuf with changing startpos and period
//                           play for ever
\prologue.playBuf(\playbufmono, 10);
//:
~rate = 0.52;
//:
~period = 5;
//:
~period = 0.95;
//:
\period <+.playbufmono 1;
//:
~rate;
//:
\prologue.ev;
//:
\period <+ 1;
//:
~period;
//:test soundin - lfnoise
\soundinTest.soundIn;
{ Inp.ar.stereo * LFNoise0.kr(10).range(0.0, 0.2) } +> \soundinTest;

//:test soundin - pulse
\soundinTest.soundIn;
{ Inp.ar.stereo * LFPulse.kr(10, 0, 0.5) } +> \soundinTest;

//:================================================================
// older stuff: develop sound in
//================================================================
//:sound check
\default +> \soundcheck;
//:model sound in method step 1
\soundin *> \effect;
{ SoundIn.ar } +> \soundin;
{ Inp.ar * LFPulse.kr(10) } +> \effect;
//:model sound in method step 2
// using shortcut until linking with custom envir is figured out
var chan = 0, inname = \soundin, effectname = \effect, uniqueinput;
uniqueinput = format("%_%", inname, effectname).asSymbol;
uniqueinput *> effectname;
{ SoundIn.ar(chan) } +> uniqueinput;
{ Ringz.ar(Inp.ar * LFPulse.kr(1, 0, 0.9), 400, 0.1).stereo } +> effectname;
//:easy hack for implementing the linking with unique soundin player
format("%_%", \soundin, \effect).asSymbol *> \effect;
{ SoundIn.ar } +> format("%_%", \soundin, \effect).asSymbol;
{ }
//:model sound in method step 2
\soundin.asPlayer(\effect.ev) // .play(this); // accept non-symbol player arg
//:model sound in method step 2
var chan = 0;
// create player soundin in environment effect
{ SoundIn.ar(chan) }.perform('+>', \soundin, \effect).inspect;
//:get player soundin in environment effect;
\soundin.p(\effect);
//:test again performing operator
{ WhiteNoise.ar(0.1) }.perform('+>', \player, \envir);
//:+test inf wait;
1.postln;
inf.wait;
"this will never happen";
