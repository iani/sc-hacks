/* Note 17 Feb 2019 06:26
Version 3.10.1 seems to have removed the OSCFunc part from the 
sendNotifyRequest method, and I cannot get my fix of sendNotifyRequest to work 
any more. 

I will incorporate the OSCFunc part below into Hacks 
to ensure that SuperDirt loads buffers *after* the root node has been created. 

 OSCFunc({|msg|
				server.changed(\notified); // this fixes things
				if(flag) { server.clientID = msg[2] };
				failOSCFunc.free;
			}, '/done', server.addr, argTemplate:['/notify', nil])

*/
+ ServerStatusWatcher {
	sendNotifyRequest { |flag = true|
		var doneOSCFunc, failOSCFunc;
		if(server.serverRunning.not) { ^this };
		notified = flag;
		// this.post;
		// { " : now running sendNotifyRequest".postln; } ! 100;
		if(server.userSpecifiedClientID.not) {
			doneOSCFunc = OSCFunc({|msg|
				server.changed(\notified); // this fixes things
				if(flag) { server.clientID = msg[2] };
				failOSCFunc.free;
			}, '/done', server.addr, argTemplate:['/notify', nil]).oneShot;

			failOSCFunc = OSCFunc({|msg|
				doneOSCFunc.free;
				Error(
					"Failed to register with server '%' for notifications: %\n"
					"To recover, please reboot the server.".format(server.name, msg)).throw;
			}, '/fail', server.addr, argTemplate:['/notify', nil, nil]).oneShot;

		};

		if(flag){
			"Receiving notification messages from server '%'\n".postf(server.name)
		} {
			"Switched off notification messages from server '%'\n".postf(server.name);
		};
		server.sendMsg("/notify", flag.binaryValue);
	}	
}