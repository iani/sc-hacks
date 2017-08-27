// 13 Aug 2017 11:01
// Shortcut for InFeedback + control rate ugen for bus number

Fin {
	*new { | ctl = \in, bus = 0, numChannels = 1 |
		^InFeedback.ar(ctl.kr(bus), numChannels)
	}
}