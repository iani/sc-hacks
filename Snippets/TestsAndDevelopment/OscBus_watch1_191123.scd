//:+Test OSCFunc with template
/*
This oscfunc will only act if message ['/test1', 1 ...] is received.
*/
var oscfunc, addr;
oscfunc = OSCFunc({ | msg |
	postf("received: %\n", msg);
}, '/test', argTemplate: 1.asArray);
addr = NetAddr.localAddr;
loop
{
	0.25.wait;
	addr.sendMsg('/test', 1, 2, 3, "only '/test' 1 is received");
	addr.sendMsg('/test', 2, 2, 3, "THIS IS NOT RECEIVED");
};
//:+Nil argTemplate:
// This will act both for \test1, 1 and \test1, 2 etc.
var oscfunc, addr;
oscfunc = OSCFunc({ | msg |
	postf("received: %\n", msg);
}, '/test', argTemplate: nil.asArray);
addr = NetAddr.localAddr;
loop
{
	0.25.wait;
	addr.sendMsg('/test', 1, 2, 3, "other '/test' are also received");
	addr.sendMsg('/test', 2, 2, 3, "THIS IS RECEIVED BECAUSE TEMPLATE IS NIL");
};
//:Test insert before using it in watch1 method code
[1, 2, 3, 4, 5].insert(1, \myName);
//:
nil.asArray;
//: