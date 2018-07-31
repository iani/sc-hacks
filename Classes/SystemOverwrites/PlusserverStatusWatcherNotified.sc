+ ServerStatusWatcher {
	sendNotifyRequest { |flag = true|
		var doneOSCFunc, failOSCFunc;
		if(serverRunning.not) { ^this };
		notified = flag;
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