//:
{ SinOsc.ar (\freq.kr (440), 0, \amp.kr (0.1)) } +> \sine;
//:
\window.vlayout (
	CSlider (\freq),
	CSlider (\amp)
).front;
//:
1000 => \freq;
0.1 => \amp;

~amp = 0.02;
//:

\amp.asSpec.default = 0.8;

//:
currentEnvironment;
//:

{ SinOsc.ar (\freq.kr (440), 0, \amp.kr (0.1)) }.asSynthDef
.allControlNames select: { | c | c.rate !== \scalar }
collect: { | c | c.defaultValue }
//: