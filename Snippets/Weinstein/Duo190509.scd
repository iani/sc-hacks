// 10 May 2019 12:38
//:sound check
(dur: 0.25, degree: [-10, 10, 1].pbrown) +> \soundcheck;
//:score framework
~f = [1, 2, 3, 5, 8, 13, 21, 34, 55];
~ff = ~f collect: { | f |
	format("f%", f).asSymbol;
};
~ffb = ~ff collect: { | f |
	format("f%", f).asSymbol;
};
// to be continued ...
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
	\dur.slider([0.1, 5], \bufplay),
	\amp.slider([0.01, 3], \bufplay),
	\rate.slider([0.2, 5], \bufplay),
	\pos.slider([0, 5], \bufplay),
	\pan.slider([-1, 1], \bufplay)
);
//:connect to OSC
\per <+.bufplay '/pi1'.osc(3, [-20, 40], [0.9, 10]);
\dur <+.bufplay '/pi1'.osc(1, [-10, 40], [0.1, 5]);
\amp <+.bufplay '/pi1'.osc(4, [-10, 40], [0.01, 3]);
\rate <+.bufplay '/pi1'.osc(2, [-40, 40], [0.9, 1.2]);
\pos <+.bufplay '/pi1'.osc(6, [-10, 4], [0.2, 5]);
\pan <+.bufplay '/pi1'.osc(7, [-2, 2], [-1, 1]);
//:start granulation
{ | bnum = 0 |
	\amp.kr(0.1) * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum),
		pan: \pan.kr(0)
	)
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
"DONE".postln;
//:testing
\f1.b;
\f1.b.play;
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
