//:Test runs for effects on Prologue Fantasy
// 14 Dec 2019 14:14
//:test prologue buffer
\prologue.b.play;
//:test recording with prologue buffer. 
Server.default.record(numChannels: 2, duration: 60); // Duration: 1 minute
\prologue.b.play;
//:test recording with prologue buffer, with record shortcut
"test".record(30);
\prologue.b.play;
//:test recording with prologue buffer, start at semitone glissando
"test_part1_plain".record(30);
{
	var startpos = 809; // start of semitone glissando
	PlayBuf.ar(1, \prologue.b,
		// original:
		// \rate.kr(0.5, 1).urange(0.25, 1.5),
		// static version:
		[0.25, 1.5].asSpec.map(0.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		\startpos.kr(startpos) + 10 * 44100, 1
	).stereo;
} +> \p1;
\level <+.p1 2;
//:check rate parameter setting
[0.25, 1.5].asSpec.map(0.5);

