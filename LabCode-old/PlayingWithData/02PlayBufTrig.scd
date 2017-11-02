// Exploring variants of playing buffers directly from the Data
// This file: Triggering (not granular but preparatory in that direction)
//: 
~amp = 0.0;
Data.doWith (\nxbuffer, { | buffer |
	{
		PlayBuf.ar (
			1,
			buffer,
			BufRateScale.kr (buffer) * \rate.kr (1),
			Changed.kr(\trigger.kr (0)),
			\startPos.kr (0) * BufFrames.kr (buffer),
			\loop.kr (0),
			0 // doneAction
		)
		* \amp.kr (0.1);
	} +> \b1;
})
//:
(trigger: Pseq ([0.5, 1], inf), dur: 0.1, amp: 1) @> \xpat;
//:
(trigger: Pseq ([0.5, 1], inf), dur: 0.1, 
startPos: Pseq ((0, 0.01 .. 0.99), inf)
) @> \xpat;

//:
(amp: Pseq ((0.01, 0.02.. 1.2), inf)) @>+ \xpat
//:
(amp: Pbrown (0.1, 2, 0.1, inf)) @>+ \xpat
//:
(amp: Pwhite (0.1, 2, inf)) @>+ \xpat
//:
(rate: Pwhite (-2, 5, inf)) @>+ \xpat
//:
\xpat.vlayout (
	CSlider (\startPos, [0, 1.0, \lin, 0]),
	CSlider (\rate, [-2, 15, \lin, 0]),
	CSlider (\amp, [0, 2, \lin, 0])
).front;
//:
Data.doWith (\nxbuffer, { | buffer |
	{
		var src;
		src = PlayBuf.ar (
			1,
			buffer,
			BufRateScale.kr (buffer) * \rate.kr (1),
			Changed.kr(\trigger.kr (0)),
			\startPos.kr (0) * BufFrames.kr (buffer),
			\loop.kr (0),
			0 // doneAction
		)
		* \amp.kr (0.1);
		Ringz.ar (src, \freq.kr (440), 0.1)
	} +> \b1;
})
//:
(freq: Pwhite (60, 90).midicps) @>+ \xpat;
//:
(freq: Pbrown (30, 90, 2).midicps) @>+ \xpat;
//:
(freq: Pbrown (50, 90, 20).midicps) @>+ \xpat;
//:
(dur: Prand ([0.05 dup: 20, 0.1, 0.2, 0.4.dup (5)].flat, inf)) @>+ \xpat;
//:
(dur: 0.5) @>+ \xpat;