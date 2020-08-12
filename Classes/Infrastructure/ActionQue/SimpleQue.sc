/* 12 Aug 2020 14:31
Simple implementation of a que of actions.
Used for building and testing CompleteActionTests ...

*/

Que {
	var <actions;  // list of actions to execute sequentially
	var <server;    // send sync and expect responses from this server
	var <id;       // used to match separate sequential synced message receipts
	var <responder; // permanent OSCFunc matching changing msg id

	//	var <que;

	*new { | server |
		server = server ?? { Server.default };
		// one Que instance per server;
		^Registry(\Que, server, { // initialize empty que as List
			this.newCopyArgs(List(), server).init;
		});
	}

	init {
		// create id and OSCFunc. Do not start. Start only when adding.
		id = UniqueID.next;
		responder = OSCFunc({ | msg |
			if (msg[1] == this.id) {
				{ this.next; }.defer;
				// { \b_alloc_DONE.postln; }.defer; // post after receiving msg
			};
		}, '/synced', server.addr).fix;
	}

	add {
		
		
	}
	
	next {
		var next;
		next = actions[0];
		if (next.isNil) {
			"Que done!".postln;
		}{
			actions remove: next;
			postf("now executing action: %\n", next);
			postf("remaining actions are:%\n", actions);
			next.value;
			id = UniqueID.next;
			postf("now watching to sync with id %\n", id);
			server.sendMsg("/sync", this.id.postln);
		}	
	}
}