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
//:playbuf: trigger per button
{ | startpos = 0 |
	var bufnum;
	bufnum = \allwk.bufnum;
	PlayBuf.ar(
		1,
		bufnum,
		1,
		Changed.kr(\trig.kr(0)),
		startpos * BufSampleRate.kr(bufnum),		
		0
	)
} +> \buftest;

\buftest.v(
	Button().states_([["trigger playback"]])
	.action_({
		\trig <+ (\trig.value ? 0 + 1);
	}),
	\startpos.slider([0, 3])
);
//:playbuf: button trigger + startpos + rate control
{ | startpos = 0 |
	var bufnum;
	bufnum = \allwk.bufnum;
	PlayBuf.ar(
		1,
		bufnum,
		\rate.kr(1),
		Changed.kr(\trig.kr(0)),
		startpos * BufSampleRate.kr(bufnum),		
		0
	)
} +> \buftest;

\buftest.v(
	Button().states_([["trigger playback"]])
	.action_({
		\trig <+ (\trig.value ? 0 + 1);
	}),
	\startpos.slider([0, 3]),
	\rate.slider([-5, 5])
);
//:playbuf: button trigger + startpos + rate + loop control
{ | startpos = 0 |
	var bufnum;
	bufnum = \allwk.bufnum;
	PlayBuf.ar(
		1,
		bufnum,
		\rate.kr(1),
		Changed.kr(\trig.kr(0)),
		startpos * BufSampleRate.kr(bufnum),		
		\loop.kr(0)
	)
} +> \buftest;

\buftest.v(
	Button().states_([["trigger playback"]])
	.action_({
		\trig <+ (\trig.value ? 0 + 1);
	}),
	\startpos.slider([0, 3]),
	\rate.slider([-5, 5]),
	Button().states_([["one shot"],["loop"]])
	.action_({ | me | \loop <+ me.value })
	.value_(\loop.value ? 0)
);