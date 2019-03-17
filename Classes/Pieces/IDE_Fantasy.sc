// 17 Mar 2019 13:32
// planned for lac19

IDE_Fantasy : Singleton {
	var <>localpis, <locations, <>mylocation;
	var <>clientIPs, <>clientNames; // only the remote clients are listed here
	var <oscFuncs;
	var <localGraphicsAddr;
	// the local client is localhost. ...
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

	init {
		localGraphicsAddr = NetAddr("127.0.0.1", 14000);
		locations = (
			athens: [\pi1, \pi2],
			corfu: [\pi3, \pi4],
			stanford: [\pi5, \pi6]
		);
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
	
	start { | where = \corfu |
		mylocation = where;
		this.init;
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