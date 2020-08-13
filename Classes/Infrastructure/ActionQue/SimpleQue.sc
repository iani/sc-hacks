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
	var <current; // currently syncing element

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
				// postf("received id % and will eval next deferred now\n", id);
				{ this.prNext; }.defer; // (5); // (5);
				// { \b_alloc_DONE.postln; }.defer; // post after receiving msg
			};
		}, '/synced' /* server.addr */).fix;
	}

	add { | action |
		// DEBUGGING OSC SYNCED MESSAGES:
		// OSCFunc.trace(true, true);

		// postf("que actions before adding: %\n", actions);
		actions add: action;
		// postf("que actions after adding: %\n", actions);
		// postf("Checking waiting value % at: %\n", waiting, Process.elapsedTime);
		// postf("currently executing: %\n", current);
		if (waiting) {
			// "// que is waiting for sync".postln;
			// don't eval the action now, but wait for sync from server
		}{  // if not waiting, make sure server is booted, then eval action
			//	"que is not waiting for sync".postln;
			waiting = true;
			server.waitForBoot({
				// OSCFunc.trace(true);
				this.prNext;
			})
		}
	}
	
	prNext {
		var next;
		next = actions[0];
		current = next;
		if (next.isNil) {
			waiting = false;
			"Que ended!".postln;
			// { OSCFunc.trace(false); }.defer(0.1); 
		}{
			actions remove: next;
			// postf("que now executing action: %\n", next);
			// postf("que remaining actions are:%\n", actions);
			// waiting = true;
			// postf("Set waiting to true at: %\n", Process.elapsedTime);
			next.value;
			id = UniqueID.next;
			server.sendMsg("/sync", this.id);
			// postf("que now waiting to sync with id %\n", id);
		}	
	}

	// for debugging order only
	*sendSync { this.new.sendSync; }
	sendSync { // for debugging order only
		// simulate synced response from server
		NetAddr.localAddr.sendMsg('/synced', this.id);
	}
}