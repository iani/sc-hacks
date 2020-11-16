//: 16 Nov 2020 10:17 Testing new concept for sending data
// to busses and using them in synths.
//:
{ SinOsc.ar(X(1).urange(2000, 9000), 0, 0.1).dup } +> \test;
//:NOTE: urange is sc-hacks custom method. Compare to range:
{
	var line, range, urange, trig;
	line = Line.kr(0, 1, 10, doneAction: 2);
	range = line.range(400, 800);
	urange = line.urange(400, 800);
	trig = Impulse.kr(10);
	line.poll(trig, "line");
	range.poll(trig, "range");
	urange.poll(trig, "urange");
	SinOsc.ar([range, urange], 0, 0.1)
} +> \test;
//:one more comparison of range to urange, for clarity:
{
	var input, trig;
	input = Line.kr(-1, 1, 10); // LFPulse.kr(2);
	trig = Impulse.kr(4);
	input.poll(trig, "input");
	input.range(400, 800).poll(trig, "range");
	input.urange(400, 800).poll(trig, "urange");
} +> \test;
//:*
\x1.bus.set(0.01 rrand: 0.99);
0.1.wait;
//:*
var base;
{ SinOsc.ar(X(1).urange(base = 100 rrand: 1000, base + (100 rrand: 2000)), 0, 0.1).dup } +> \test;
5.wait