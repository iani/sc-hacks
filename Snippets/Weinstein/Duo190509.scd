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
//:+Do a test run recording buffers with fibonacci durations
[1, 2, 3, 5, 8, 13, 21, 34, 55] do: { | f |
	var dur, bufname, buf, bufnum;
	dur = f;
	bufname = format("f%", f).asSymbol;
	buf = bufname.b;
	bufnum = buf.bufnum;
	postf("Recording into buffer: %\n", buf);
	postf("Duration is: %\n", dur);
	{
		RecordBuf.ar(
			In.ar(4) ,
			bufnum,
			loop: 0,
 			doneAction: 2
		);
	} +> \bufrec;	
	dur.wait;
};
"DONE".postln;


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
//:check server output channels
Server.default.options.numOutputBusChannels;
//:check server input channels
Server.default.options.numInputBusChannels;

\f55.b.play;