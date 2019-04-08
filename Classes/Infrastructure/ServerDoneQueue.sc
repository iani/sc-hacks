/*  8 Apr 2019 09:26
An implementation of server sync which I can understand and use.

To load SynthDefs, allocate or read buffers, add functions which do these one at a time to ServerDone with: 

ServerDone add: { /*a SynthDef sending or Buffer alloc/read action here */ }

If ServerDone is not already loading previous actions, it will start.
Otherwise it will add the new action after all already added actions and proceed with loading.
When all actions have been done, the ServerDone instance which loaded them issues a 
'emptiedQueue' message.

\test.addNotifier(ServerDone(), 'emptiedQueue', { "Now I can go about my business".postln; });

ServerDone add: { Buffer.alloc(Server.default, 44100 ) };

TODO: Define method "loadQueue" for SynthDefs and Functions that return synthdefs or buffers

*/

ServerDone : Singleton {
	var <actions;
	var <waitRoutine;

	*initClass {
		StartUp add: {
			OSCFunc({
				"I received done message and will notify done".postln;
				Server.default changed: '/done';
			}, '/done');
		}
		
	}

	add { | action |
		actions ?? { actions = List() };
		actions add: action;
		if (actions.size == 1) {
			this.start;
			postf("now I execute the action that I was passed: %\n");
			action.value.postln; // boot the action list with the first action
		};
	}

	start {
		var action;
		"Starting now".postln;
		waitRoutine = {
			while {
				actions.size > 0;
			}{
				this.yield;
				postf("before doing next action: %\n", actions);
				action = actions removeAt: 0;
				action.value;
				postf("the action is %\n", action);
				postf("after doing next action: %\n", actions);
			};
			"will notify changed now".postln;
			this.changed('emptiedQueue');
		}.fork;
		this.addNotifier(Server.default, '/done', {
			waitRoutine.next;
		})
	}
}