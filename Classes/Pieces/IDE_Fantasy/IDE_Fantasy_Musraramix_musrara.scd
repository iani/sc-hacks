// script run at musrara only
{
	var addr, sendText;
	addr = NetAddr.localAddr;
	// addr.postln;
	sendText = { | text |
		addr.sendMsg('/text', text);
		postf("sent: %\n", text);
	};

	1.wait;
	sendText.("TESTING");
	1.wait;
	sendText.("TESTING 2");
	1.wait;
	sendText.("TESTING 3");
	1.wait;
	"DONE".postln;
}.fork;