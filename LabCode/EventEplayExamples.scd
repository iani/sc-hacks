// 24 Jun 2017 22:13
//:
(freq: Pwhite (400, 20000, inf).sqrt, dur: 0.1).eplay;
\window.vlayout (CSlider (\freq)).front;
//:
(freq: Pwhite (400, 2000, inf), dur: 0.1).eplay;
//:
\test splay: { SinOsc.ar (\freq.kr (400), 0, 0.1) };
//:
(degree: Pbrown (0, 20, 2, inf), dur: 0.1).eplay;
//:
~fadeTime = 2;
{
	var players;
	players = Pseq ([
		{ LFPulse.ar (\freq.kr (400) / [2, 3], 0, 0.5, 0.1) },
		/*
		{ Blip.ar (\freq.kr (400 * [1, 1.2]),
			LFNoise0.kr (5).range (5, 250),
			0.3)
		},
		*/
		{
			LPF.ar (
				Ringz.ar (PinkNoise.ar (0.1), \freq.kr (400) * [1, 1.5], 0.1),
				LFNoise2.kr (1).range (400, 1000)
			)
		}
	], inf).asStream;
	loop {
		\test splay: players.next;
		2.5.wait;
	}
}.fork;

//: NOTE: other keys are overwritten in the source event of the other
//: pattern, every time the pattern produces an event
(mtranspose: Pseq ((0..7), inf), dur: 0.7 ).eplay (\mtranspose);
//:
(degree: Pbrown (0, 20, 2, inf), dur: 0.7).eplay;
//:
/* In the above example, two patterns write on the 
freq key of currentEnvironment separately.
In 1. freq is computed from the change in degree.
In 2. freq is computed from the change in mtranspose.
*/
