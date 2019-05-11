// 11 May 2019 12:52 - adding fft processing effects
//:score framework
//:Allocate buffers. !!!!!
var fibs;
fibs = [1, 2, 3, 5, 8, 13, 21, 34, 55];
fibs do: { | f |
	format("f%", f).asSymbol.b(f);
};
postf("allocated % buffers", fibs.size);
//:+test buffers exist
2 do: {
	[1, 2, 3, 5, 8, 13, 21, 34, 55] do: { | f |
		format("f%", f).asSymbol.b.postln;
		0.1.wait;
	};	
}
//:perpare gui
\bufplay.tr_(400, 300);
\bufplay.v(
	\per.slider([0.2, 20], \bufplay),
	\dur.slider([2, 5], \bufplay),
	\amp.slider([0.00, 3.5], \bufplay),
	\rate.slider([0.2, 5], \bufplay),
	\pos.slider([0, 5], \bufplay),
	\pan.slider([-1, 1], \bufplay),
	\thresh.slider([-1, 1], \bufplay)
);
//:connect to OSC
\per <+.bufplay '/pi1'.osc(3, [-20, 40], [5, 10]);
\dur <+.bufplay '/pi1'.osc(1, [-10, 40], [2, 5]);
\amp <+.bufplay '/pi1'.osc(4, [-10, 40], [0.00, 3.5]);
\rate <+.bufplay '/pi1'.osc(2, [-20, 20], [0.5, 2]);
\pos <+.bufplay '/pi1'.osc(6, [-10, 4], [0.2, 5]);
\pan <+.bufplay '/pi1'.osc(7, [-2, 2], [-1, 1]);
\thresh <+.bufplay '/pi1'.osc(5, [-20, 40], [-0.98, 0.21]);
//:debug thresh
\thresh <+.bufplay '/pi1'.osc(3, [-20, 40], [0.9, 10]);
//:granulation + brickwall for duo
{ | bnum = 0 |
	var src, chain;
	src = \amp.kr(0.1, 1.0) * 2 * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5) * 2,
		bnum,
		\rate.kr(2, 1.0),
		\pos.kr(0, 1.0) * BufSampleRate.kr(bnum)
		//		pan: \pan.kr(0) // moved pan after FFT
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BrickWall(chain, \thresh.kr(0.1, 0.5));
	Pan2.ar(IFFT(chain), \pan.kr(0))
} +> \bufplay;
//:+Do a test run recording buffers with fibonacci durations
~buffers = [1, 2, 3, 5, 8, 13, 21, 34, 55] collect: { | f |
	format("f%", f).asSymbol.b(f);
};
\bnum <+.bufplay ~buffers[0].bufnum;	

~buffers do: { | buf, i |
	var bufnum;
	bufnum = buf.bufnum;
	postf("Recording into buffer: %\n, bufnum: %\n", buf, bufnum);
	postf("Duration is: %\n", buf.dur);
	{
		RecordBuf.ar(
			In.ar(4),
			bufnum,
			loop: 0,
 			doneAction: 2
		);
	} +> \bufrec;
	buf.dur.wait;
	postf("Done recording into %. Starting playback of %\n", buf, buf);
	\bnum <+.bufplay bufnum;
	/*
		{
		PlayBuf.ar(1, bufnum, doneAction: 2)
		} +> \bufplay;
	*/
};
"ALL RECORDINGS DONE".postln;
"STARTING BUFFER CHANGES".postln;
5 do: {
	~buffers do: { | buffer |
		\bnum <+.bufplay buffer.bufnum;
		10.wait;
	};
};
"DONE".postln;
//:testing
\f1.b;
\f1.b.play;
//:================================================================
//:code from IDE
//: Stanford 1
// ================================================================
// ================================================================
// PV_BrickWall
// Stanford 1
// ================================================================
{
	var bnum, src, chain;
	bnum = \lamentodellaninfa.b.bufnum;
	src = \amp.kr(0.1) * GrainBuf.ar(1,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum)
		//	pan: \pan.kr(0)
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BrickWall(chain, \thresh.kr(0.1, 0.5));
	Pan2.ar(IFFT(chain), \pan.kr(0))
} +> \stanford1;
//:tuning amp on 23 Mar 2019 09:41
\stanford1.v(
	\per.slider([0.2, 20], \stanford1),
	\amp.slider(\amp, \stanford1),
	\rate.slider([0.2, 5], \stanford1),
	\pos.slider([0, 50], \stanford1),
	\pan.slider([-1, 1], \stanford1),
	\thresh.slider([-1, 1], \stanford1)
);
//:
\per <+.stanford1 '/pi5'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.stanford1 '/pi5'.osc(1, [-5, 30], \amp);
\rate <+.stanford1 '/pi5'.osc(2, [-10, 40], [0.2, 1]);
\pos <+.stanford1 '/pi5'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.stanford1 '/pi5'.osc(7, [-2, 2], [-1, 1]);
\thresh <+.stanford1 '/pi5'.osc(8, [-2, 2], [-1, 1]);

//:================================================================
//:code from IDE
//: Corfu 1
// ================================================================
{
	var bnum;
	bnum = \f3.b.bufnum;
	\amp.kr(0.1) * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum),
		pan: \pan.kr(0)
	)
} +> \bufplay;
//:
//:
\bufplay.tr_(400, 300);
//:
\bufplay.v(
	\per.slider([0.2, 20], \bufplay),
	\dur.slider([0.1, 5], \bufplay),
	\amp.slider(\amp, \bufplay),
	\rate.slider([0.2, 5], \bufplay),
	\pos.slider([0, 5], \bufplay),
	\pan.slider([-1, 1], \bufplay)
);

//:================================================================
//:Early tries - buffer input recording and playback
//:buffer for testing recording
\buffer.b(10); // 10 seconds.
//:record buffer
{
	RecordBuf.ar(
		In.ar(4),
		\buffer.b.bufnum,
		loop: 0,
		doneAction: 2
	);
} +> \recording;
//:
\buffer.b.play;
//:check server output channels
Server.default.options.numOutputBusChannels;
//:check server input channels
Server.default.options.numInputBusChannels;

\f55.b.play;
//:sound check
{ | pos = 0 | Pan2.ar(WhiteNoise.ar(0.1), pos) } +> \soundcheck;
//:
\pos <+ -1;
//:
\pos <+ 1;
//:Brickwall original from stanford
// ================================================================
// PV_BrickWall
// Stanford 1
// ================================================================
{
	var bnum, src, chain;
	bnum = \lamentodellaninfa.b.bufnum;
	src = \amp.kr(0.1) * GrainBuf.ar(1,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum)
		//	pan: \pan.kr(0)
	);
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_BrickWall(chain, \thresh.kr(0.1, 0.5));
	Pan2.ar(IFFT(chain), \pan.kr(0))
} +> \stanford1;
//:tuning amp on 23 Mar 2019 09:41
\stanford1.v(
	\per.slider([0.2, 20], \stanford1),
	\amp.slider(\amp, \stanford1),
	\rate.slider([0.2, 5], \stanford1),
	\pos.slider([0, 50], \stanford1),
	\pan.slider([-1, 1], \stanford1),
	\thresh.slider([-1, 1], \stanford1)
);
//:
\per <+.stanford1 '/pi5'.osc(3, [-40, 40], [0.2, 10]);
\amp <+.stanford1 '/pi5'.osc(1, [-5, 30], \amp);
\rate <+.stanford1 '/pi5'.osc(2, [-10, 40], [0.2, 1]);
\pos <+.stanford1 '/pi5'.osc(6, [-5, 5], [0.0, 55]);
\pan <+.stanford1 '/pi5'.osc(7, [-2, 2], [-1, 1]);
\thresh <+.stanford1 '/pi5'.osc(8, [-2, 2], [-1, 1]);
//:================================================================
