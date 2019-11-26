//:mapping busses
// under way. 25 Nov 2019 18:33

//:connecting players (source-effect)
// | Symbol     | =*>=       | Symbol     | Link
\source *> \effect;
//:
{ WhiteNoise.ar(0.02) } +> \source;
//:
{ Ringz.ar(Inp.ar, LFNoise1.kr(5).range(500, 1500), 1.5) } +> \effect;
//:same as above, in one block:
{ WhiteNoise.ar(0.02) } +> \source;
{ Ringz.ar(Inp.ar, LFNoise1.kr(5).range(500, 1500), 1.5) } +> \effect;
//:playing buffers
//to prepare: load buffer prologue with Hacks.loadAudioFiles
//then:
{//                       rate trig, startpos loop
	PlayBuf.ar(1, \prologue.b, 1, 1, 0, 1)
} +> \playbuf;
//:+prepare and test playFor
\amp <+.test 0.01;
{
	WhiteNoise.ar(\amp.kr(0.1)).stereo;
} +> \test;
1.wait;
\amp <+ 0.1;
1.wait;
\test.stop;
//:play something for given duration
{
	WhiteNoise.ar(0.1).stereo;
}.playFor(\test)
//:Soundin
{ Inp.ar.stereo * LFPulse.kr(1, 0, 0.9) } +> \intest.soundIn;