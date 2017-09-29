// 28 Sep 2017 18:49
// PLay a routine in a Nevent. function *> symbol;
//: Preparing
currentEnvironment.playRoutine(\test, { loop {
	~target.postln;
	0.25.wait;
}});
//: Preparing
currentEnvironment.playRoutine(\test, { loop {
	~freq = 400 rrand: 4000;
	~freq.postln;
	currentEnvironment.changed(\freq);
	currentEnvironment.postln;
	currentEnvironment.put(\freq, 400 rrand: 4000);
	currentEnvironment.players;
	1.wait;
}});
//:
\default +> \test;
//:*
~freq = 400 rrand: 1000;
0.1.wait;
//:
{ SinOsc.ar(\freq.kr(300), 0, 0.1) } +> \test2;
//:
\default +> \test;
//:
\test.e.playRoutine(\blah,
	{
			loop {
		~freq = 400 rrand: 1000;
		0.1.wait;

		
	}	
}
)
//:
\test.e.playLoop(\blah, {
	~freq = 400 rrand: 1000;
	0.5.wait;
})
//:
\default.play;
//:
\default +> \default;
//:
{ SinOsc.ar(\freq.kr(400) * [1, 1.2], 0, 0.1) } +> \default;
{
	~freq = 400 rrand: 4000;
	0.1.wait;
} **> \d1;
//:
{ Ringz.ar(WhiteNoise.ar(0.1), \freq.kr(400), \rq.kr(0.1)) } +> \test;
//:
{
	~freq = 400 rrand: 4000;
	0.3.wait;
} **> \d1;
//:
{ Ringz.ar(WhiteNoise.ar(0.1), \freq.kr(400), \rq.kr(0.1)) } +> \test;
//:
~rq = 0.01;
//:
{
	~rq = 0.001 exprand: 0.1;
	0.01.exprand(1.0).wait;
} **> \var;
//:
var freq;
freq = Pbrown(100, 2000, 10).asStream;
{
	~freq = freq.next;
	0.01.exprand(0.1).wait;
} **> \freq;

//:

{
	~freq = 400 rrand: 4000;
	0.3.wait;
} **> \d1;
//:
{
	~rq = [0.01, 0.5].choose;
	0.3.wait;
} **> \d2