/* 23 Feb 2019 11:27
For Nymphs: Dancing Through Phantasmata project

Nymphs.getClients;

*/
Nymphs : Singleton {
	var <clients; // dictionary of client names and ip's used for display.
	var <ips;     // array of NetAddr used for fast forwarding.
	var <localPis;
	getClients {
		var hamachi, addr;
		"Nymphs: getting client names and ip's from Hamachi.".postln;
		clients = ();
		ips = [];
		hamachi = "hamachi list".unixCmdGetStdOut;
		hamachi[hamachi.findRegexp("\\[ide-fantasy\\]")[0][0]..]
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

	makePis { | ... names |
		localPis do: _.clear;
		localPis = names collect:  Pi(_);
	}

	/*
	map { | synth, pi, param |
		
	}
	*/
}

LocalPi {
	/* 
		Handle communication and action for osc messages received from one RPI
	*/
	var <name;
	var <buses;
	var <oscForwardingFunc;
	var <ips; // cache ips from Nymphs for speed
	var <paramNames; 
	var <inspecs, <outspecs, <envir;
	

	*new { | name |
		^this.newCopyArgs(name.asSymbol).init;
	}

	init {
		//	this.makeBuses;
		paramNames = [
			\ax, \ay, \az, \mx, \my, \mz, \gx, \gy, \gz
		];
		envir = name.envir;
		inspecs = paramNames collect: { | param |
			// inspecs[param] = ControlSpec(-40, 40);
			ControlSpec(-40, 40);
		};
		outspecs = paramNames collect: { | param |
			// outspecs[param] = \freq.asSpec;
			\freq.asSpec;
		};
		this.initForwarding;
	}

	initForwarding {
		ips = Nymphs.ips;
		this.disableForwarding; // prevent double forwarding
		oscForwardingFunc = OSCFunc({ | msg |
			ips do: { | addr | addr.sendMsg(*msg) };
			msg[1..] do: { | val, i |
				envir[paramNames[i]] = outspecs[i].map(inspecs[i].unmap(val));
			}
		}, name);
	}

	makeBuses {
		/*
		var bus, envir;
		envir = name.envir;
		buses = ();
		paramNames do: { | param |
			bus = Bus.control(Server.default, 1);
			buses[param] = bus;
			envir.put(param, bus);
		}
		*/
	}

	disableForwarding {
		oscForwardingFunc !? { oscForwardingFunc.free; };		
	}

	clear {
		this.disableForwarding;
		buses do: _.free;
	}
}

RemotePi : LocalPi {
	
	initForwarding {
		ips = Nymphs.ips;
		this.disableForwarding; // prevent double forwarding
		oscForwardingFunc = OSCFunc({ | msg |
			// ips do: { | addr | addr.sendMsg(*msg) };
			msg[1..] do: { | val, i |
				envir[paramNames[i]] = outspecs[i].map(inspecs[i].unmap(val));
			}
		}, name);
	}

}