// 17 May 2019 17:26
// Topic: Navigation
// Starting point: Transition from point a to point b in time x
// Implementation: Transition of param freq with linen
//:Line example: Trajectory consisting of 2 points: origin, target
var origin, target, time;
origin = 520;
target = 1500;
time = 4;
{ SinOsc.ar(Line.kr(origin, target, time, doneAction: 2), 0, 0.1) }.play;
//:Extension 1: Sonify a trajectory of more than 2 points
//store the points in an array.
var trajectory;
trajectory = Array.rand(50, 200.0, 5000.0);
//Πονηρό implementation: Use an envelope;
//Env: levels, times ...
{
	var env;
	//     levels, times
	env = Env(trajectory, 0.1.dup(trajectory.size - 1));
	SinOsc.ar(env.kr(2, 1), 0, 0.1)
}.play;
//:Variant of extension 1 (a): Play 1 note per point
var trajectory;
trajectory = Array.rand(50, 200.0, 5000.0);
Pbind(\freq, Pseq(trajectory), \dur, 0.1).play;
//:Variant of extension 1 (b): Play 1 note per point, using line
// (Portamento)
{
var trajectory;
trajectory = Array.rand(50, 200.0, 5000.0);
trajectory.size - 2 do: { | i |
	{ SinOsc.ar(
		Line.kr(trajectory[i], trajectory[i + 1], 0.1, doneAction: 2),
		0, 0.1
	)}.play;
	0.2.wait;
};
}.fork
//:Variant of extension 1 (c): Overlap
// (Portamento)
{
var trajectory;
trajectory = Array.rand(50, 200.0, 5000.0);
trajectory.size - 2 do: { | i |
	{ SinOsc.ar(
		Line.kr(trajectory[i], trajectory[i + 1], 0.5, doneAction: 2),
		0, 0.1
	)}.play;
	0.3.wait;
};
}.fork
//:Variant of extension 1 (d): "Staccato" (gaps)
// (Portamento)
{
var trajectory;
trajectory = Array.rand(50, 200.0, 5000.0);
trajectory.size - 2 do: { | i |
	{ SinOsc.ar(
		Line.kr(trajectory[i], trajectory[i + 1], 0.2, doneAction: 2),
		0, 0.1
	)}.play;
	0.5.wait;
};
}.fork
//:Variant of extension 1 (d): Random waits
// (Portamento)
{
var trajectory;
trajectory = Array.rand(50, 200.0, 5000.0);
trajectory.size - 2 do: { | i |
	{ SinOsc.ar(
		Line.kr(trajectory[i], trajectory[i + 1], 0.2, doneAction: 2),
		0, 0.1
	)}.play;
	0.1.rrand(0.9).wait;
};
}.fork
//:Extension 2: Play 20 trajectories in parallel
{
	{
		var trajectory;
		trajectory = Array.rand(50, 200.0, 5000.0);
		trajectory.size - 2 do: { | i |
			{ SinOsc.ar(
				Line.kr(trajectory[i], trajectory[i + 1], 0.2, doneAction: 2),
				0, 0.1
			)}.play;
			0.1.rrand(0.9).wait;
		};
	}.fork
} ! 20;
//:Extension 3: Play The same trajectory with delay ("canon")
{
var trajectory;
trajectory = Array.rand(50, 200.0, 5000.0);
{
	{
		trajectory.size - 2 do: { | i |
			{ SinOsc.ar(
				Line.kr(trajectory[i], trajectory[i + 1], 0.2, doneAction: 2),
				0, 0.1
			)}.play;
			// different rhythm in each voice
			0.1.rrand(0.9).wait;
		};
	}.fork;
	1.wait;
} ! 20;
}.fork;
//:Extension 3b: Play The same trajectory with delay ("canon") - same time values
{
	var trajectory, times;
	trajectory = Array.rand(50, 200.0, 5000.0);
	times = Pseq(Array.rand(trajectory.size, 0.1, 0.4));
{
	{
		var timestream;
		timestream = times.asStream;
		trajectory.size - 2 do: { | i |
			{ SinOsc.ar(
				Line.kr(trajectory[i], trajectory[i + 1], 0.2, doneAction: 2),
				0, 0.1 / 5
			)}.play;
			// different rhythm in each voice
			(timestream.next * 5).wait;
		};
	}.fork;
	1.wait;
} ! 20;
}.fork;
//:Extension 3b: Play The same trajectory with delay ("canon") - same time values
{
	var trajectory, times;
	trajectory = Array.rand(50, 200.0, 5000.0);
	times = Pseq(Array.rand(trajectory.size, 0.1, 0.4));
{
	{
		var timestream;
		timestream = times.asStream;
		trajectory.size - 2 do: { | i |
			
			{ SinOsc.ar(
				Line.kr(trajectory[i], trajectory[i + 1], 0.2, doneAction: 2),
				0, 0.1 / 5
			)}.play;
			// different rhythm in each voice
			(timestream.next * 5).wait;
		};
	}.fork;
	[0.25, 1, 2].choose.wait;
} ! 20;
}.fork;
//:Extension 3b: Play The same trajectory with delay ("canon") - same time values
{
	var trajectory, times;
	trajectory = Array.rand(50, 200.0, 5000.0);
	times = Pseq(Array.rand(trajectory.size, 0.1, 0.4));
{
	{
		var timestream, stretchfactor;
		stretchfactor = [0.5, 1, 2, 4, 8].choose;
		timestream = (times * stretchfactor).asStream;
		trajectory.size - 2 do: { | i |
			
			{ SinOsc.ar(
				Line.kr(trajectory[i], trajectory[i + 1],
					0.2 * stretchfactor, doneAction: 2),
				0, 0.1 / 5
			)}.play;
			// different rhythm in each voice
			(timestream.next * 5).wait;
		};
	}.fork;
	[0.25, 1, 2].choose.wait;
} ! 20;
}.fork;