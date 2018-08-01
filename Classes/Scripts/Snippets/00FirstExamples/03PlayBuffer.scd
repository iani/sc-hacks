//Testing PlayBuf, triggering
//:preload include loadallwk scope meter
//:preload include loadallwk
//:playbuf: trigger on startpos change
{ | startpos = 0 |
	var bufnum;
	bufnum = \allwk.bufnum;
	PlayBuf.ar(
		1,
		bufnum,
		1,
		Changed.kr(startpos),
		startpos * BufSampleRate.kr(bufnum),		
		0
	)
} +> \buftest;

\buftest.v(
	\startpos.slider([0, 3])
);