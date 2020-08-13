/* 13 Aug 2020 16:01 Debug version
12 Aug 2020 14:31
Simple implementation of a que of actions.
Used for building and testing CompleteActionTests ...

*/

QueDebug {
	var <actions;   // list of actions to execute sequentially
	var <server;    // send sync and expect responses from this server
	var <id;        // used to match separate sequential synced message receipts
	var <responder; // permanent OSCFunc matching changing msg id
	var <waiting = false;

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
				postf("received id % and will eval next deferred now\n", id);
				{ this.prNext; }.defer;
				// { \b_alloc_DONE.postln; }.defer; // post after receiving msg
			};
		}, '/synced' /* server.addr */).fix;
	}

	add { | action |
		postf("que actions before adding: %\n", actions);
		actions add: action;
		postf("que actions after adding: %\n", actions);
		if (waiting) {
			"que is waiting for sync".postln;
			// don't eval the action now, but wait for sync from server
		}{  // if not waiting, make sure server is booted, then eval action
			"que is not waiting for sync".postln;
			server.waitForBoot({ this.prNext; })
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
			postf("que now executing action: %\n", next);
			postf("que remaining actions are:%\n", actions);
			waiting = true;
			next.value;
			id = UniqueID.next;
			// server.sendMsg("/sync", this.id);
			postf("que now waiting to sync with id %\n", id);
		}	
	}

	// for debugging order only
	*sendSync { this.new.sendSync; }
	sendSync { // for debugging order only
		// simulate synced response from server
		NetAddr.localAddr.sendMsg('/synced', this.id);
	}
}