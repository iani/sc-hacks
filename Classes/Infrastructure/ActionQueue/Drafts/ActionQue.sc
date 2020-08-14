// 11 Aug 2020 15:46
/*
que synthdefs, buffers and functions so that they are executed in a 
fixed sequence while ensuring that each synthdef or buffer in the sequence
is loaded (or allocated or read) to the server before going on to the 
next one. 

Draft:

Wait for the loaded notification from the server in order to go on to the
next item in the que. 
Does not require use of a Routine or Condition or forking a separate thread.

Store the buffers allocation or path specs, the synthdefs and the functions in a list.
Send the message sync to each element in the list.
When 

SynthDef or buffer [possibly also Synth and Group] objects (or template-objects) call ActionQue.next as completion messages. 

Function objects call ActionQue.next immediately after evaluating. 

a = List();
a add: \ppp1;

a remove: \ppp1;

a[0]
*/

ActionQue {
	var <server, <actions;

	*add { | object, server |
		^this.new(server ?? { Server.default }).add(object);
	}
	
	*new { | server |
		^Registry(\ActionQue, server, {
			this.newCopyArgs(server, List.new);
		})
	}

	add { | object |
		actions add: object;
		if (actions.size == 1) {
			this.start;
		}
	}

	start {
		server.waitForBoot({
			actions[0].sync(/* this */);
		});
	}

	next { | completed |
		var next;
		actions remove: completed;
		next = actions[0];
		next !? { next.sync(/* this */) };	
	}
}