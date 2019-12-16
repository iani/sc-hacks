
+ SimpleNumber {
	formatTime {
		/* Adapted from History::formatTime */
		var val, h, m, s;
		val = this;
		h = val div: (60 * 60);
		val = val - (h * 60 * 60);
		m = val div: 60;
		val = val - (m * 60);
		s = val;
		if (h > 0) {
			^"%:%:%".format(h, m, s.round(0.01))
		}{
			^"%:%".format(m, s.round(0.001))
		}
	}

	longFormatTime {
		var val, h, m, s;
		val = this;
		h = val div: (60 * 60);
		val = val - (h * 60 * 60);
		m = val div: 60;
		val = val - (m * 60);
		s = val;
		if (h > 0) {
			^"% hours, % minutes: % seconds".format(h, m, s.round(0.01))
		}{
			^"% minutes, % seconds".format(m, s.round(0.001))
		}
	}

	minsec {
		/* convert to seconds
			Treat integer part as minutes, decimal part * 100 truncated to 60 as
			seconds after the minutes
			0.50 -> 50 seconds
			0.9 -> 59 seconds (truncated to 1 minute - 1 second)
			1.10 -> 1 minute 10 seconds
			1.6 -> 1 minute 59 seconds (truncated)
		*/
		^this.floor(1) * 60 + (this.frac * 100 min: 59);
	}

	secmin {
		// convert to [minutes, seconds]
		var min, sec;
		min = this div: 60;
		sec = this - (min * 60);
		^[min, sec]
	}
}