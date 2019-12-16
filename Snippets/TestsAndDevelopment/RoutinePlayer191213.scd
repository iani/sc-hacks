//:basic principle
//loops forever
//use *> operator (because +> is for synths)
// the loop must be explicitly written!{

loop { 
		100.rand.postln; 1.wait
	}
} *> \myloop;
//:replace previous routine by sending to same player
{
	loop { 
		postf("this is new: %\n",
			100.rand);
		1.wait;
	}
} *> \myloop;
//:loop over a collection of data
//primitively - without streams
{
	// data are initialized  once only.
	// at the beginning
	var data;
	data = (1..10); // count from 1 to 10;
	data do: { | i |
		postf("counting from 1 to 10: %\n", i);
		0.1.wait;
	};
	"I reached 10 and therefore I stop now".postln;
} *> \myloop;

//=================================================
//:streams offer great flexibility and expressive power
// (but require more abstract thought...)
{
	var data;
	// use a stream instead of an array:
	data = Pseq((1..10)).asStream;
	data do: { | i |
		postf("counting from 1 to 10: %\n", i);
		0.1.wait;
	};
	"I reached 10 and therefore I stop now".postln;
} *> \myloop;

//=================================================
//:why streams? demo!: Create nested sequences
{
	var phrase1, phrase2, phrase3, data;
	phrase1 = Pseq((1..3), 3);
	phrase2 = Prand((10..12), 5); // include some random stuff
	phrase3 = Prand(["some", "text!!!!!"], 2); // and text
	// play the sequence 3 times
	data = Pseq([phrase1, phrase2, phrase3], 3).asStream;
	data do: { | i |
		postf("counting from 1 to 10: %\n", i);
		0.1.wait;
	};
	"I reached 10 and therefore I stop now".postln;
} *> \myloop;

//=================================================
//:using for osc streaming
// instead of postln use addr.sendMsg ..
{
	var data, addr;
	// use a stream instead of an array:
	data = Pseq((0, 0.001..1)).asStream;
	addr = NetAddr("127.0.0.1", 51000); // hydra default port
	data do: { | i |
		postf("sending count from 1 to 10: %\n", i);
		addr.sendMsg('/test', i);
		0.1.wait;
	};
	"I reached 10 and therefore I stop now".postln;
} *> \myloop
//:using for osc streaming
// sIMPLE: INSTEAD OF postln use addr.sendMsg ..
{
	var data, addr;
	// use a stream instead of an array:
	data = Pseq((0, 0.01..2pi).sin).asStream;
	addr = NetAddr("127.0.0.1", 51000); // hydra default port
	data do: { | i |
		postf("sending count from 1 to 10: %\n", i);
		addr.sendsg('/test', i);
		0.1.wait;
	};
	"I reached 10 and therefore I stop now".postln;
} *> \myloop
//: