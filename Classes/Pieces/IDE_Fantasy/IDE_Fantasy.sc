// 19 May 2019 18:01
/* 
Based on version used on March 23 for the performance at LAC19.

This version is for the performance at Musraramix on May 30.

It does not boot the server and load the sound files at startup.
Instead it requires message "boot" to start.

*/
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
	var <busnames, <buses; // dicts containing names and buses: one bus array per PI name.
	// busnames serve for reference and also to free buses when reinitializing.
	var <oscFuncs; // one func per PI
	var <localGraphicsAddr; // forward data from pis to this address
	//	var <>pollRate = 0.1; // speed of polling loop. See startUpdateLoop

	boot {
		Server.default.waitForBoot({
			var server, bname;
			"\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
			"Server booted. Loading Sounds".postln;
			"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n".postln;
			server = Server.default;
			"Found % sound files: ".post;
			(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch.postln;
			(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch do: { | p |				
				bname = PathName(p).fileNameWithoutExtension.asSymbol;
				postf("Loading %\n", bname);
				// PathName(p).allFolders.postln;
				Registry(\buffers, bname, {
					Buffer.read(server, p);
				})
			};
			"\n================ SOUNDS LOADED ================\n".postln;
		});
	}
	
	default {
		// ^Registry(this, \default { });
		^this;
	}

	startLocally { | where = \corfu |
		// for tests, start without connecting to remote clients
		this.start(where, false);
	}
	
	start { | where = \corfu, enableRemote = true |
		// per default, do connect to hamachi.
		// if enableRemote is true, then connect to hamachi.
		mylocation = where;
		this.initLocationsAndBuses;
		this.clearHamachi;
		this.makeOSCFuncs;
		// this.startUpdateLoop;
		if (enableRemote) { this.connectHamachi };
		{
			this.loadMainScript;
		}.defer(1); // give enough time for all buses to be created.
	}

	loadMainScript {
		// Server must be still up and running from compile / StartUp time!
		var path;
		path = PathName(IDE_Fantasy.filenameSymbol.asString).pathOnly ++ "IDE_Fantasy_Musraramix.scd";
		"LOADING: ".post; path.postln;
		path.load;
		
	}

	initLocationsAndBuses {
		localGraphicsAddr = NetAddr("127.0.0.1", 14000);
		locations = (
			athens: [\pi1, \pi2],
			corfu: [\pi3, \pi4],
			stanford: [\pi5, \pi6]
		);
		this.makeBuses;
	}
	
	makeBuses {
		var base, names;
		"Freeing previous buses for security".postln;
		busnames do: { | a | a do: _.freeBus };  // free previous buses if restarting
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
			//	NOTE: Using busnames, not buses.
			// going back to earlier setting parameters idea.
			if (localpis includes: p) {
				postf("==== local: % ==== \n", p);
				postf("%'s buses are: %\n", p, busnames[p]);
				this.makeLocalOscFunc(p, busnames[p]);
			}{
				postf("==== remote: % ==== \n", p);
				postf("%'s buses are: %\n", p, busnames[p]);
				this.makeRemoteOscFunc(p, busnames[p]);
			}
		}
	}

	/*
		Use already tested mechanism of sc-hacks 
		to connect to sound and to display
	*/
	makeLocalOscFunc { | pie, buses |
		var myBuses;
		// myBuses = buses[pie];
		OSCFunc({ | msg |
			clientIPs do: { | addr | addr.sendMsg(*msg) };
			this.playLocally(msg, buses); // only plays graphics
			// for sound, use sc-hacks techniques
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
		// only play graphics
		// for sound, use sc-hacks techniques
		/*
			buses do: { | bus, index |
			// bus.set(msg[index + 1]);
			\ide.changed(bus, msg[index + 1]);
		};
		*/
		// set buses
		// postf("My pie is: %\n. I will set these buses: %\n", msg[0], buses)
	}

	/*
	startUpdateLoop {
		// only starts with start method.
		// only stops with command-.
		{
			loop {
				this.changed(\data);
				pollRate.wait;
			};
		}.fork(AppClock);
		
	}
	*/
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