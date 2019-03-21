//:test granulation - add more parameters
{
	var bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	GrainBuf.ar(2,
		Impulse.kr(\per.kr(1).abs / 10),
		\dur.kr(0.5),
		bnum,
		\rate.kr(1) - 3,
		\pos.kr(0) * 10 * BufSampleRate.kr(bnum)
	)
} +> \i;
//:
\per <+ \stanford1ax;
\dur <+ \stanford1ay;
\rate <+ \stanford1az;
\pos <+ \stanford1mx;


//:
\per <+ \stanford1ax;
\dur <+ \stanford1ay;

