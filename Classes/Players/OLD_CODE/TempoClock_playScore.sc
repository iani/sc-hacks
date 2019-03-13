// 20 Nov 2017 21:19
// Play a score based on a pattrn/stream that produces symbols.

+ TempoClock {
	playScore { | pattern |
		pattern = pattern.asStream;
		this.schedAbs(this.beats.ceil, {
			this.changed(pattern.next);
			1
		})
	}
}
