// 17 Mar 2019 13:32
// planned for lac19

IDE_Fantasy : Singleton {
	var <>localpis, <locations, <>mylocation;
	var <>clientIPs, <>clientNames; // only the remote clients are listed here
	// the local client is localhost. ...
	var <busnames;
	/*
		each bus must have a unique name. There are 54 buses, one per sensor:
		2                 * 3       * 9
		// pi's per perf, num perf, params per pi
		// total num params: 54.  54 names. 
		// naming convention: 
		location_num_sensor
		where:
		location is one of: stanford, corfu athens
		num is one of: 1 (=master/left) 2 (=slave, right)
		sensor is one of: 
		ax, ay, az, 
		mx, my, mz
		gx, gy, gz, 
		where a = accellerometer, m = magnetormeter, g = gyroscope
	*/
	var <buses; // dict containing one bus array per pie name.
	var <oscFuncs; // one func per pi
	var <localGraphicsAddr;
	/*
	*initClass {
		StartUp add: {
			// { postf("will init now: %\n", this); } ! 100;
			Nymphs.getClients;
			{
				// postf("IDE found these clients: %\n", Nymphs.clients);
				this.clientIPs = Nymphs.clients.values.array;
				this.clientNames = Nymphs.clients.keys;
				postf("IDE: client names are: %\nclient IPs are: %\n",
					this.clientIPs, this.clientNames
				);
			}.defer(1);
		}	
	}	
	*/

	start { | where = \corfu |
		mylocation = where;
		this.init;
	}

	init {
		localGraphicsAddr = NetAddr("127.0.0.1", 14000);
		locations = (
			athens: [\pi1, \pi2],
			corfu: [\pi3, \pi4],
			stanford: [\pi5, \pi6]
		);
		// this.makeBuses;
		this.connectOSC;
	}

	makeBuses {
		//		buses do: _.free;  // free previous buses if restarting
		
	}

	freeBuses {
		// nothing at the moment
		
	}
	
	connectOSC {
		localpis = locations[mylocation];
		Nymphs.getClients;
		{
			// postf("IDE found these clients: %\n", Nymphs.clients);
			this.clientIPs = Nymphs.clients.values.array;
			this.clientNames = Nymphs.clients.keys;
			postf("IDE: client names are: %\nclient IPs are: %\n",
				this.clientIPs, this.clientNames
			);
			postf("my location is: %\n", mylocation);
			this.makeOSCFuncs;
		}.defer(1);
	}
	
	makeOSCFuncs {
		/*
			make busses and oscfuncs for all 6 rpis.
			for all 6 rpis: set the busses.
			for local rpis only: additionally broadcast the data to the 2 remoteClient ips

			
		*/
		"\n\nResetting for security. Freeing any previous oscfuncs.\n\n".postln;
		oscFuncs do: _.free;
		postf("my localpis are: %\n", localpis);
		oscFuncs = ();
		locations.values.asArray.flat do: { | p |
			//			p.postln;
			if (localpis includes: p) {
				postf("p is local! %\n", p);
				postf("p's buses are: %\n", buses[p]);
				this.makeLocalOscFunc(p, buses[p]);
			}{
				postf("p is remote! %\n", p);
				postf("p's buses are: %\n", buses[p]);
				this.makeRemoteOscFunc(p, buses[p]);
			}
		}
	}

	makeLocalOscFunc { | pie, buses |
		var myBuses;
		// myBuses = buses[pie];
		OSCFunc({ | msg |
			clientIPs do: { | addr | addr.sendMsg(*msg) };
			this.playLocally(msg, buses);
		}, pie);
	}
	
	makeRemoteOscFunc { | pie, buses |
		OSCFunc({ | msg |
			// DO NOT BROADCAST osc received from remote clients
			//		clientIPs do: { | addr | addr.sendMsg(*msg) };
			this.playLocally(msg, buses);
		}, pie);
	}

	playLocally { | msg, buses |
		// send to graphics locally
		postf("sending %, %\n", localGraphicsAddr, msg);
		localGraphicsAddr.sendMsg(*msg);
		// set buses
		postf("My pie is: %\n. I will set these buses: %\n", msg[0], buses)
	}

}

/*
IDE_Fantasy start: \stanford;
IDE_Fantasy start: \corfu;
IDE_Fantasy start: \athens;

IDE_Fantasy.clientIPs;
IDE_Fantasy.pis = ;

IDE_Fantasy();
IDE_Fantasy.default.clientIPs;

*/