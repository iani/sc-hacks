/* New notes 11 Apr 2019 03:13

Load synthdefs, allocate and read buffers.

Make sure that all synthdef or buffers are loaded in a sequence (not concurrently).

If server is not booted, then prompt user with gui or command to boot it.

================================================================

Notes 8 Apr 2019 09:26: 
An implementation of server sync which I can understand and use.

To load SynthDefs, allocate or read buffers, add functions which do these one at a time to ServerDone with: 

ServerDone add: { /*a SynthDef sending or Buffer alloc/read action here */ }

If ServerDone is not already loading previous actions, it will start.
Otherwise it will add the new action after all already added actions and proceed with loading.
When all actions have been done, the ServerDone instance which loaded them issues a 
'emptiedQueue' message.

\test.addNotifier(ServerDone(), 'emptiedQueue', { "Now I can go about my business".postln; });

ServerDone add: { Buffer.alloc(Server.default, 44100 ) };

TODO: Define method "que" ("loadQueue") for SynthDefs and prototypes that allocate or read buffers.

SynthDef:que
Note: we still need to provide names for storing buffers: How?
"path string".que(name)
[Float or Integer (num seconds or num frames), numChannels].que(name)

*/

ServerQueue : Singleton {
	var <actions;
	var <waitRoutine;

	add { | action |
		actions ?? { actions = List() };
		actions add: action;
		if (actions.size == 1) {
			this.checkServerThenStart;
			postf("now I execute the action that I was passed: %\n", action);
			action.(this).postln; // start the action loading with the first action
			// If there are more actions in the list, then do not start,
			// Because it means that there are still actions being processed.
		};
	}

	checkServerThenStart {
		if (Server.default.serverRunning) {
			this.start;
		}{
			Server.default.waitForBoot({ this.start; });
		}
	}

	start {
		var action;
		waitRoutine = {
			while {
				actions.size > 0;
			}{
				this.yield;
				postf("actions before doing next action: %\n", actions);
				action = actions removeAt: 0;
				action.(this);
				postf("the action is %\n", action);
				postf("actions remaining after doing next action: %\n", actions);
			};
			"will notify changed now".postln;
			this.changed(\emptiedQueue);
		}.fork;
	}
}