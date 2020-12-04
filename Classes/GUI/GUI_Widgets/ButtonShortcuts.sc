/* 23 Oct 2018 07:12
Experimental shortcuts for buttons.
*/

+ Function {
	button { | string = "button", foreground, background |
		^HButton()
		.states_([[string, foreground, background]])
		.action_(this)
	}
}


+ Array {
	button {
		// this keysValuesDo: { | a, b | [a, b].postln; }
		var states;
		states = this.clump(2).flop;
		^Button()
		.states_(states[0].collect({ | st |
			if (st isKindOf: String) { [st] } { st }
		}))
		.action_({ | me | (states[1]@@(me.value - 1)).value});
	}
}