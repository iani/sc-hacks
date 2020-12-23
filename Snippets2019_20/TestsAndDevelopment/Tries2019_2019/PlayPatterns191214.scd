//:play patterns with a function and player using *>
/* Stepping through data produced by a patterns.
Based on work with Alex Ch. See RoutinePlayer191213.scd
*/
//:starting point is this example from RoutinePlayer191213.scd
{
	var data, addr;
	// use a stream instead of an array:
	data = Pseq((1..10)).asStream;
	addr = NetAddr("127.0.0.1", 51000); // hydra default port
	data do: { | i |
		postf("sending count from 1 to 10: %\n", i);
		addr.sendMsg('/test', i);
		0.1.wait;
	};
	"I reached 10 and therefore I stop now".postln;
} *> \myloop
//:Define stream method for pattern.
// (play method is already defined)
/*
aPattern.play(playername, functionOrParameter, timePattern);
Prototype for Pattern:streamp
*/
var dt = 1, pattern, stream, player = \player, func = \freq;
pattern = Pseq((60..72));
stream = pattern.asStream;
{
	stream do: { | val |
		player.set(func, val); // default func for symbol as parameter name
		(dt.next ? 1).wait;
	};
} *> player;
//:
{ SinOsc.ar(\freq.kr(1000), 0, 0.1).stereo } +> \test;
//:
\test.set(\freq, 1500);