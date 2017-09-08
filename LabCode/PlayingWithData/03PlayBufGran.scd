// Exploring variants of playing buffers directly from the Data
// This file: Granular synthesis on the data buffers

~amp = 0.0;
Data.doWith (\nxbuffer, { | buffer |
	{
		TGrains.ar (
			1,
			Changed.kr(\trigger.kr (0)),
			buffer,
			\rate.kr (1) * BufRateScale.kr (buffer),
			\cpos.kr (1),
			\graindur.kr (1),
		)
		* \amp.kr (0.1);
	} +> \b1;
})
//:
(trigger: Pseq ([0.5, 1], inf), dur: 0.1) @> \xpat;
//:
~amp = 2;
//:
~dur = 2;
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
// Exploring variants of playing buffers directly from the Data
// This file: Granular synthesis on the data buffers

~amp = 2.0;
Data.doWith (\nxbuffer, { | buffer |
	{
		GrainBuf.ar (
			2,
			Changed.kr(\trigger.kr (0)),
			\graindur.kr (1),			// grainduration
			buffer,
			\rate.kr (1),
			\pos.kr (0),					// position in file
			1,
			\pan.kr (0)
		)
		* \amp.kr (0.1);
	} +> \b1;
})
//:
(trigger: Pseq ([0.5, 1], inf), dur: 0.5, amp: 1 ) @> \xpat;
//:
~rate = 0.52;
//:
~graindur = 0.2;
//:
(dur: 0.05) @>+ \xpat;
//:
(dur: 0.1) @>+ \xpat;
//:
(rate: Pbrown(-1.0, 3.0, 0.1)) @>+ \xpat;
//:
(pos: Pbrown(0, 0.5, 0.01)) @>+ \xpat;
//: Add resonance
Data.doWith (\nxbuffer, { | buffer |
	{
		var src;
		src = GrainBuf.ar (
			2,
			Changed.kr(\trigger.kr (0)),
			\graindur.kr (1),			// grainduration
			buffer,
			\rate.kr (1),
			\pos.kr (0),					// position in file
			1,
			\pan.kr (0)
		)
		* \amp.kr (0.1);
		Ringz.ar (src, \freq.kr (440), \rtime.kr (0.1))
	} +> \b1;
})
//:
(pan: Pbrown(-1.0, 1.0, 0.01)) @>+ \xpat;
//:
(freq: Pbrown (30, 90, 2).midicps) @>+ \xpat;
//: Use data from x dimension to play frequency
(dur: 0.001) @> \xpat; // restart xpat if needed
//:
(freq: Pseq (Data.xyz [2] + 100 * 20, inf)) @>+ \xpat;
//: Test pure frequency
{ Mix (SinOsc.ar (
	[\freq1.kr (440), \freq2.kr (440), \freq3.kr (440)]
	, 0, 0.1)) } +> \test;
//:
(freq1: Pseq (Data.xyz [0] + 100 * 20, inf),
freq2: Pseq (Data.xyz [1] + 100 * 20, inf),
freq3: Pseq (Data.xyz [2] + 100 * 20, inf)) @>+ \xpat;
//:
(freq: Pseq (, inf)) @>+ \xpat;
//:
(freq: Pbrown (50, 90, 4).midicps) @>+ \xpat;
//:
(dur: Prand ([0.05 dup: 20, 0.1, 0.2, 0.4.dup (5)].flat, inf)) @>+ \xpat;
//:
