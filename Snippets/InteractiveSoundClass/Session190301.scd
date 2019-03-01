
1 + 1;

1000.rand;

1.0.rand;

pi;

://:
(
Server.default.boot;
)
//:
(
{
	SinOsc.ar(400, 0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		MouseX.kr(200, 2000, \exponential),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(5).range(400, 450),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(
			MouseX.kr(0.5, 20)
		).range(400, 450),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(
			MouseX.kr(20, 2500)
		).range(400, 4500),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(
			LFNoise0.kr(
				MouseX.kr(0.1, 40)
			).range(20, 2500)
		).range(400, 4500),
		0, 0.1)
}.play;
)
//:
(
{
	SinOsc.ar(
		SinOsc.ar(
			LFNoise1.kr(
				MouseX.kr(0.1, 140)
			).range(20, 2500)
		).range(400, 4500),
		0, 0.1)
}.play;
)
//:Example of creating an object from a class
(
Window.new().front;
//
)
//:Example of creating an object from a class
(
Window("MY WINDOW", Rect(400, 400, 800, 300)).front;
//