/* 14 Dec 2019 14:51
Play a pattern as stream in a player with *>
*/

+ Pattern {
	stream { | player = \player, func = \freq, dt = 0.1 |
		// Play a pattern as stream in a player with *>
		var stream;
		stream = this.asStream;
		dt = dt.asStream(player.target);
		func = func.asStreamFunction(player.target);
		{ 
			stream do: { | value |
				func.(value, player);
				dt.next.wait;
			}
		} *> player;
	}
}

+ Function {
	asStreamFunction { ^this }
}

+ Symbol {
	asStreamFunction { | target |
		^{ | val | target.set(this, val) };
	}
}