/* 14 Dec 2019 14:51
Play a pattern as stream in a player with *>

Symbol: player :: name of player (and envir) where pattern will play
Function: func :: evaluated with the next value from the patterns stream
   at each iteration.
Pattern / number dt: (Pattern producing:) values for timing next iteration.
Symbol: key :: Names key where routine will be stored in envir. 
Defaults to player. Streaming a new pattern stops the routine of the previous
pattern playing under the same key in that player's envir.

Key is used to name the routine playing the pattern.
It defaults to player.

*/

+ Pattern {
	stream { | player = \player, func = \freq, dt = 0.1, key |
		// Play a pattern as stream in a player with *>
		var stream, envir;
		stream = this.asStream;
		dt = dt.asStream(player.target);
		func = func.asStreamFunction(player.target);
		envir = player.ev;
		envir.playRoutine(key ? player, { 
			stream do: { | value |
				func.(value, player);
				dt.next.wait;
			}
		});
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