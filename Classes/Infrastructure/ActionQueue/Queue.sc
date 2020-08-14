/* 12 Aug 2020 14:31
Simple implementation of a queue of functions, alternative approach to
the functionality of Server.sync.

Ensures that each function in the queue will be run after the server has 
synced (completed) any async commands resulting from the previous action. 


Execute each action in the que only after receiving \synced message from

*/

Queue {
	var <actions;   // list of actions to execute sequentially
	var <server;    // send sync and expect responses from this server
	var <id;        // used to match separate sequential synced message receipts
	var <responder; // permanent OSCFunc matching changing msg id
	var <inactive = true; // If inactive, start. Else wait for synced message.
	var <next, <result; // last executed code and the result it returned.
	var <preboot;  // Function to execute before booting server. (Set options, etc)/

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

	preboot_ { | function |
		// Function to execute before booting server. (Set options, etc)/
		// Warn if the server is running: Prompt user to reboot server.
		if (server.serverRunning) {
			postf("Server % is running, its options cannot be modified.\n", server);
			"Quit the server, then start this Queue to apply changes.".postln;
		}
		preboot = function;
	}
	
	add { | action |
		actions add: action;
		if (inactive) {  // make sure server is booted, then eval first action
			inactive = false; // must be before waitForBoot !!!!!!!
			preboot.(this);
			server.waitForBoot({ // because waitForBoot messes with more delay
				this.changed(\started, Process.elapsedTime);
				this.prNext;
			})
		}
		// if active, wait for sync message from server.
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
			inactive = true;
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
		// default functionality provided here:
		var startTime;
		watcher ?? { watcher = \queueWatcher };
		onStart ?? { onStart = { | time |
			startTime = time;
			postf("started at: %\n", startTime);
		}};
		onSync ?? { onSync = { | action, result |
			postf("evaluated: %, got: %\n", action, result);
		}};
		onStop ?? { onStop = { | time |
			postf("stopped at: %\n", time);
			postf("total duration: %\n", time - startTime);
		}};
		// Connect actions to notifier:
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