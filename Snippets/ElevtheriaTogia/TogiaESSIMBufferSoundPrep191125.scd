//:
Hacks.loadAudioFiles;
//:
Hacks.listAudioBuffers;
//:playback prologue - find start
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(1),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(10) * 44100, 1).stereo;
} +> \playbufstereo;
//:change period. + start point
\period <+ 10.2; // keep this
\startpos <+ 790.2;
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
\prologue.e;
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
\soundin.asPlayer(\effect.e) // .play(this); // accept non-symbol player arg
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
