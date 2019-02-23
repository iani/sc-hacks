/* 23 Feb 2019 11:27
For Nymphs: Dancing Through Phantasmata project

*/
Nymphs : Singleton {
	var clients; // dictionary of client names and ip's used for display.
	var ips;     // array of NetAddr used for fast forwarding.
	getClients {
		var hamachi, addr;
		"Nymphs: getting client names and ip's from Hamachi.".postln;
		clients = ();
		ips = [];
		hamachi = "hamachi list".unixCmdGetStdOut;
		hamachi[hamachi.findRegexp("\\[nymphs-phantasmata\\]")[0][0]..]
		.split(Char.nl)[1..].select({ | s |
			s.size > 1
		}).collect({ | line |
			line.split($ )
			.select({ | s | s.size > 1})
		}).collect({ | a | a[1..2]})
		.do({ | pair |
			addr = NetAddr(pair[1], 57120);
			clients[pair[0].asSymbol] = addr;
			ips = ips add: addr;
		});
		postf("Found these clients: %\n", clients);
	}

	ping {
		postf("Starting ping test for these clients:\n%\n", clients);
		{
			loop {
				postf("sending to: %\n", ips);
				ips do: { | addr |  addr.sendMsg('/test', 1, 2, 3) };
				0.25.wait;
			}
		}.fork;
	}
	
}