// 21 Mar 2019 16:18
// { "testing".postln; } ! 50;
//:give basic feedback
"Starting sound script".postln;
//:name control parameter more appropriately
/*
{
	SinOsc.ar(\freq.kr(400) + 100 * 5, 0, 0.1)
} +> \sinetest;
//map bus to new parameter name
\freq <+ \stanford1ax;
*/
//:name control parameter more appropriately
{
	Mix(SinOsc.ar(
		[
			\freq.kr(400) + 100 * 5,
			\freq2.kr(400) + 100 * 5,
			\freq3.kr(400) + 100 * 5,
			\freq4.kr(400) + 100 * 5
			// \freq4.kr(400) + 100 * 5
		], 0, 0.1)
	)
} +> \sinetest;
//map bus to new parameter name
\freq <+ \stanford1ax;
\freq2 <+ \stanford1ay;
\freq3 <+ \stanford1az;
\freq4 <+ \stanford1mx;
//:
