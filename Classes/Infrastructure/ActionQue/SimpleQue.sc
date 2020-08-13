/* 12 Aug 2020 14:31
Simple implementation of a que of actions.
Used for building and testing CompleteActionTests ...

*/

Que {
	var <actions;   // list of actions to execute sequentially
	var <server;    // send sync and expect responses from this server
	var <id;        // used to match separate sequential synced message receipts
	var <responder; // permanent OSCFunc matching changing msg id
	var <waiting = false; // = false;

	*add { | action |
		this.new add: action;
	}
	
	*new { | server |
		server = server ?? { Server.default };
		// one Que instance per server;
		^Registry(\Que, server, { // initialize empty que as List
			this.newCopyArgs(List(), server).init;
		});
	}

	init {
		// create id and OSCFunc. Do not start. Start only when adding.
		responder = OSCFunc({ | msg |
			if (msg[1] == this.id) {
				{ this.prNext; }.defer; // (5); // (5);
			};
		}, '/synced', server.addr).fix;
	}

	add { | action |
		actions add: action;
		if (waiting) {
			// don't eval the action now, but wait for sync from server
		}{  // if not waiting, make sure server is booted, then eval action
			waiting = true; // must be before waitForBoot !!!!!!!
			server.waitForBoot({ // because waitForBoot messes with more delay
				this.prNext;
			})
		}
	}
	
	prNext {
		var next;
		next = actions[0];
		if (next.isNil) {
			waiting = false;
			"Que ended!".postln;
		}{
			actions remove: next;
			next.value;
			id = UniqueID.next;
			server.sendMsg("/sync", this.id);
		}	
	}

	// for debugging order only
	*sendSync { this.new.sendSync; }
	sendSync { // for debugging order only
		// simulate synced response from server
		NetAddr.localAddr.sendMsg('/synced', this.id);
	}
}