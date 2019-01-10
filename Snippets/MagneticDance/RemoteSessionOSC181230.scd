// 30 Dec 2018 22:05 with Nikos Charalambidis
// Ekaterini <-> Tokyo
//:add oscfunc for forwarding.
//Use Registry to keep the trace function:
Registry(\forwardfunc, {
	var forwardAddr, hosts;
	forwardAddr = NetAddr("25.80.47.40", 57120);
	// you can add more hosts here!
	// var forwardAddr2; // example of one more host
	// then you need to send to all of them.
	hosts = [forwardAddr /*, forwardAddr2 */];
	{ | msg, time, addr |
		if (addr.port == 12345) {
			hosts do: { | host |
				host.sendMsg(*msg);				
			};
		}
	}
});
//:Now add the function to activate it
// this will run whenever OSC is received.
thisProcess.addOSCRecvFunc(
	Registry.at(\forwardfunc)
);
//:How to change the osc func
// Note To replace the above func with something else,
// You need to do 4 things:
// 1. Remove the old func from thisProcess
// 2. Remove the old func from Registry
// 3. Store the new func in registry
// 4. Add the new func from registry to thisProcess
// Here are the first 2 steps from above: 
// Remove forward funct to replace it if needed
/* if you want to change the above function, then
you need to remove it both from the OSCRecvFunc and
from the registry before repeating the process
	to add a new function; */
thisProcess.addOSCRecvFunc(Registry.at(\forwardfunc));
Registry.at(\forwardfunc).objectClosed;
//:
NetAddr.localAddr.port;

