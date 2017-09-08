/* 15 Jul 2017 20:35

	Utility for playing arrays.
	For educational purposes mainly: How an array of numbers can be played as signal.
*/

+ Array {
	play { | doScope = true |
		if (doScope) { Server.default.scope };
		^Buffer.loadCollection (
			Server.default,
			this,
			1,
			{ | b |
				postf ("loading done. Result: %\n", b);
				b.play;
			}
		)
	}

	plotPlay { | doScope = true |
		this.plot;
		this.play (doScope);
	}
}