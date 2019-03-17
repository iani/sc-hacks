// 17 Mar 2019 13:32
// planned for lac19

IDE_Fantasy : Singleton {
	var <>localpis, <locations, <>mylocation;
	var <>clientIPs, <>clientNames; // only the remote clients are listed here
	// the local client is localhost. ...
	var <busnames; /*

		2                 * 3       * 9
		// pi's per perf, num perf, params per pi
		// total num params: 54.  54 names. 
		// naming convention: 
		location_num_sensor
		where:
		location is one of: stanford, corfu athens
		num is one of: 1 (=master/left) 2 (=slave, right)
		sensor is one of: 
		ax, ay, az, gx, gy, gz, mx, my, mz
		where a = accellerometer, g = gyroscope, m = magnetormeter
		
	*/
	var <buses;
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
		this.makeBuses;
		this.connectOSC;
	}

	makeBuses {
		this.freeBuses; // free previous buses if restarting
		
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
		var ct; // strange compilation problem?

		"\n\nResetting for security. Freeing any previous oscfuncs.\n\n".postln;
		oscFuncs do: _.free;
		postf("my localpis are: %\n", localpis);
		oscFuncs = ();
		locations.values.asArray.flat do: _.postln;
		ct = locations.values.asArray.flat;

		ct do: { | p |
			p.postln;
			if (localpis includes: p) {
				postf("p is local! %\n", p);
				this.makeLocalOscFunc(p);
			}{
				postf("p is remote! %\n", p);
				this.makeRemoteOscFunc(p);
			}
		}
	}

	makeLocalOscFunc { | pie |
		OSCFunc({ | msg |
			clientIPs do: { | addr | addr.sendMsg(*msg) };
			this.playLocally(msg);
		}, pie);
	}
	
	makeRemoteOscFunc { | pie |
		OSCFunc({ | msg |
			//		clientIPs do: { | addr | addr.sendMsg(*msg) };
			this.playLocally(msg);
		}, pie);
	}

	playLocally { | msg |
		postf("sending %, %\n", localGraphicsAddr, msg);
		localGraphicsAddr.sendMsg(*msg);
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