//:
Hacks.loadAudioFiles;
//:
Hacks.listAudioBuffers;
//:playback prologue - find start
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(1), \trig.kr(1),
		44100 * 10, 1).stereo;
} +> \playbufstereo;
//:playback prologue - play for limited duration with playFor
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(1), \trig.kr(1),
		44100 * 10, 1).stereo
}.playFor(\playbufstereo, 6.5);
//:try playFor on buffer name
//                            startpos, dur
\prologue.playFor(\playbufmono, 10, 6.5);
//:test soundin
\soundinTest.soundIn;
{ Inp.ar.stereo * LFNoise0.kr(10, 0, 0.9) } +> \soundinTest;

//:================================================================
// older stuff: develop sound in
//================================================================

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
