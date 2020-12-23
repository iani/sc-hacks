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

