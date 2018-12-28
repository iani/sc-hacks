Include.server(
"
options.memSize = 8192 * 64;
"
);
Include("scope");
Include("meter");
/*
//: Testing control before trying the actual algorithm
// This will be removed later:
{ SinOsc.ar(\freq.kr(400), 0, 0.1) } +> \test;
//:
\test.v(
	\freq.slider([300, 3000].asSpec)
)
*/
//:
/*
{
	var in;
	in = In.ar(2);
	// NOTE: 60 seconds max delay is beyond the memory allocated to server
	// by default option settings. Increased memSize option to 8192 * 64.
	DelayN.ar(in, 60, \dt.kr(5), 1, \feedback.kr(0) * in)
} +> \delay;
*/
//: