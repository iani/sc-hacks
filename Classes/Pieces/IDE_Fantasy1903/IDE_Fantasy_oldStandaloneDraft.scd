// 17 Mar 2019 13:32
// planned for lac19

IDE_Fantasy : Singleton {
	var <>localpis, <locations, <>mylocation;
	var <>clientIPs, <>clientNames; // only the remote clients are listed here
	// the local client is localhost. ...
	/* busnames and buses are stored in dictionaries, one array per pie.
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
	var <busnames, <buses; // dicts containing names and buses: one bus array per pie name.
	// busnames serve for reference and also to free buses when reinitializing.
	var <oscFuncs; // one func per pie
	var <localGraphicsAddr; // forward data from pies to this address
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

	start { | where = \corfu, enableRemote = false |
		// per default, do not connect to hamachi.
		// if enableRemote is true, then connect to hamachi.
		mylocation = where;
		this.initLocationsAndBuses;
		this.clearHamachi;
		this.makeOSCFuncs;
		if (enableRemote) { this.connectHamachi };
	}

	standalone { | where = \corfu |
		// develop locally without net connection
		mylocation = where;
		this.initLocationsAndBuses;
		// "standalone method is not yet implemented. Nothing will happen".postln;
		this.connectOSCstandalone;
	}

	connectOSCstandalone {
		localpis = locations[mylocation];
		"\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
		postf("================ my location is: % ================\n", mylocation);
		"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
		"\n\nResetting for security. Freeing any previous oscfuncs.\n\n".postln;
		oscFuncs.postln;
		"these were the oscfuncs".postln;
		oscFuncs do: _.free;

		locations.values.asArray.flat do: { | p |
			//			p.postln;
			postf("==== MAKING Remote - non forwarding oscfunc for: % ==== \n", p);
			postf("%'s buses are: %\n", p, buses[p]);
			this.makeRemoteOscFunc(p, buses[p]);
		}
	}

	
	initLocationsAndBuses {
		localGraphicsAddr = NetAddr("127.0.0.1", 14000);
		locations = (
			athens: [\pi1, \pi2],
			corfu: [\pi3, \pi4],
			stanford: [\pi5, \pi6]
		);
		this.makeBuses;
		/* // this is for standalone only. Mistakenly here:
		locations.values.asArray.flat do: { | p |
			//			p.postln;
			this.makeDevOscFunc(p, buses[p]);
		};
		*/
		//		this.connectOSC;
	}
	
	makeBuses {
		var base, names;
		busnames do: { | a | a do: _.free };  // free previous buses if restarting
		busnames = ();
		buses = ();
		locations = (
			athens: [\pi1, \pi2],
			corfu: [\pi3, \pi4],
			stanford: [\pi5, \pi6]
		);
		locations.keys.asArray do: { | location |
			locations[location] do: { | p, num |
				base = format("%%", location, num + 1);
				names = [
					\ax, \ay, \az,
					\mx, \my, \mz,
					\gx, \gy, \gz
				].collect({ | n |
					format("%%", base, n).asSymbol
				});
				busnames[p] = names;
				buses[p] = names.collect({ | n | n.bus});
			}
		};		
	}

	clearHamachi {
		// set names and ips to []
		// This disables sending of local sensor input to remote hosts.
		"\n\nDisabling remote forwarding of local data. Setting clientIPs to [].\n\n".postln;
		clientIPs = [];
		clientNames = [];
	}
	
	connectHamachi {
		// get remote names and ips from hamachi
		Nymphs.getClients;
		{
			// postf("IDE found these clients: %\n", Nymphs.clients);
			this.clientIPs = Nymphs.clients.values.array;
			this.clientNames = Nymphs.clients.keys;
			postf("IDE: client names are: %\nclient IPs are: %\n",
				this.clientIPs, this.clientNames
			);
			"\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
			postf("================ my location is: % ================\n", mylocation);
			"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
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
		oscFuncs = ();		
		localpis = locations[mylocation];
		postf("my localpis are: %\n", localpis);
		locations.values.asArray.flat do: { | p |
			//			p.postln;
			if (localpis includes: p) {
				postf("==== local: % ==== \n", p);
				postf("%'s buses are: %\n", p, buses[p]);
				this.makeLocalOscFunc(p, buses[p]);
			}{
				postf("==== remote: % ==== \n", p);
				postf("%'s buses are: %\n", p, buses[p]);
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
		// postf("sending %, %\n", localGraphicsAddr, msg);
		localGraphicsAddr.sendMsg(*msg);
		// set buses
		// postf("My pie is: %\n. I will set these buses: %\n", msg[0], buses)
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