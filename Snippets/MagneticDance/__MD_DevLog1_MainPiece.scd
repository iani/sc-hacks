// 21 Mar 2019 15:21
//:Bus check

//:Granulation basics
{
	var bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	GrainBuf.ar(1,
		Impulse.kr(\per.kr(1)),
		\dur.kr(0.5),
		bnum,
		\rate.kr(1),
		\pos.kr(0) * BufSampleRate.kr(bnum)
	)
} +> \gran;