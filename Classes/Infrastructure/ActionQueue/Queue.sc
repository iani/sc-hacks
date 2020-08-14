/* 12 Aug 2020 14:31
Simple implementation of a que of actions.
Used for building and testing CompleteActionTests ...

*/

Queue {
	var <actions;   // list of actions to execute sequentially
	var <server;    // send sync and expect responses from this server
	var <id;        // used to match separate sequential synced message receipts
	var <responder; // permanent OSCFunc matching changing msg id
	var <waiting = false; // = false;
	var <next, <result; // last executed code and the result it returned.

	*add { | action |
		this.new add: action;
	}
	
	*new { | server |
		server = server ?? { Server.default };
		// one Que instance per server;
		^Registry(\Queue, server, { // initialize empty que as List
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
				this.changed(\started, Process.elapsedTime);
				this.prNext;
			})
		}
	}
	
	prNext {
		/* runs when receiving sync from previous evaluation,
			or, when starting, at the very beginning evaluating
			the first element.
			
			Use changed method to broadcast the last evaluated function
			and the result of evaluating it. 

			Obtain the next element and evaluate it.
			Store the next element and the result of its evaluation.
		*/
		// First broadcast the function and result from the previous evaluation.
		this.changed(\eval, next, result);
		next = actions[0];
		if (next.isNil) {
			waiting = false;
			this.changed(\stopped, Process.elapsedTime);
			"Que ended!".postln;
		}{
			actions remove: next;
			result = next.value;
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

	// watch execution messages broadcast via changed
	*watch { | watcher, onStart, onSync, onStop |
		this.new.watch(watcher, onStart, onSync, onStop);
	}

	watch { | watcher, onStart, onSync, onStop |
		watcher.addNotifier(this, \started, { | time |
			onStart.(time, watcher, this);
		});
		watcher.addNotifier(this, \eval, { | action, result |
			onSync.(action, result, watcher, this);
		});
		watcher.addNotifier(this, \stopped, { | time |
			onStop.(time, watcher, this);
		});
	}
}