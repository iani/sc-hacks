//: port (+ip) for graphics (Godot!)

// Use localhost + port 14000
var godot;

godot = NetAddr("127.0.0.1", 14000);


//: useless stuff
Registry.put(\test, (corfu: 1, athens: 2));
//:
Registry.at(\test);
//:
"hamachi list".unixCmd;
//:
var answer;
answer = "hamachi list".unixCmdGetStdOut;
answer.postln;
answer.split(Char.nl) do: { | line, num | postf("this is line number: %\n%\n", num, line) };
answer.size;
//:
/*
 * [magnetic-dance]  capacity: 3/5, subscription type: Free, owner: budos (227-352-918)
this is line number: 1
       227-352-918   budos                      25.0.0.0          alias: not set                                                     
this is line number: 2
     ! 227-366-342   budos                      25.0.0.0          alias: not set                                                       This address is also used by another peer
this is line number: 3
 * [magneticdancetest]  capacity: 2/5, subscription type: Free, owner: budos (228-742-800)
this is line number: 4
     * 228-742-800   budos                      25.80.47.40       alias: not set           2620:9b::1950:2f28                          direct      UDP  10.3.141.100:32822
this is line number: 5

-> 661
*/
// ================================================================
// We hardwire the local address of the sending pi.
/* Note: If we need more than one pi in one space locally, then
one pi has to be the wifi server, and the other pi's must log in 
to that pi-server and obtain their ip from it.
Note that the logical ID of the sending device is given 
by the name of the message, not by the IP.
*/
//:dummy prototype 1 - v.0
var localpiIP;
localpiIP = "10.3.141.1";
thisProcess.addOSCRecvFunc({ | ... args |
	args.postln;
})
//:dummy prototype 1 - v.1
var localpiIP;
localpiIP = 168004865; // "10.3.141.1";
thisProcess.addOSCRecvFunc({ | msg, time, ip |
	ip.addr.postln;
	if(ip.addr == localpiIP) {
		postf("Received from local ip this: %\n", msg[..4]);
	}{
		"not local???????".postln;
		
	}
})
//:dummy prototype 1 - v.1
var localpiIP, remoteClients;
localpiIP = 168004865; // "10.3.141.1";δ
remoteClients = ();
(budos: "25.80.47.40") keysValuesDo: { | name, ip |
	remoteClients[name] = NetAddr(ip, 57120);
};
// remoteClients;
thisProcess.addOSCRecvFunc({ | msg, time, ip |
	// ip.addr.postln;
	if(ip.addr == localpiIP) {
		// postf("Received from local ip this: %\n", msg[..4]);
		remoteClients do: { | addr | addr.sendMsg(*msg) };
	}{
		// "not local???????".postln;
		
	}
})
//:other stuff
OSCFunc.trace(true);

NetAddr.localAddr.hostname;
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//:developing the parsing - step 1
var answer;
answer = "hamachi list".unixCmdGetStdOut;
answer.postln;
answer.split(Char.nl) do: { | line, num | postf("this is line number: %\n%\n", num, line) };
answer.size;

//:developing the parsing - step 2
var answer;
answer = "hamachi list".unixCmdGetStdOut;
answer[answer.findRegexp("\\[nymphs-phantasmata\\]")[0][0]..].split(Char.nl)[1..] do: { | line, index |
	postf("\n\nThis is line number % FOLLOWING:\n", index + 1);
	line.split($ ).select({ | s | s.size > 1 }).postln;
}

//:developing the parsing - step 3
var answer;
answer = "hamachi list".unixCmdGetStdOut;
answer[answer.findRegexp("\\[nymphs-phantasmata\\]")[0][0]..].split(Char.nl)[1..].select({ | s |
	s.size > 1
}).collect({ | line | line.split($ ).select({ | s | s.size > 1})}).collect({ | a | a[1..2]});
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//:Testing Nymphs:getClients;
Nymphs.getClients;
//:Testing Nymphs:ping;
Nymphs.ping;
//:ips found?
Nymphs.ips;
//:send test once
Nymphs.ips.first.postln.sendMsg('/test');
//:Xreate a  osc fun for testing
f = OSCFunc({ | msg ... args | msg.postln;}, '/atest');
//:create routine sending to /atest
r = {
	loop {
		NetAddr.localAddr.sendMsg('/atest', 50, 50, 50);
		0.25.wait;
	}
	
}.fork;
//:
f.free;