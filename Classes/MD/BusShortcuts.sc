/*
16 Nov 2020 10:08
Use these shortcuts in coding Synth Functions sent to players,
in order to access busses created by SenseBus.

{ SinOsc.ar(X(1).urange(400, 800), 0, 0.1) } +> \test; 

is equivalent to:

{ SinOsc.ar(In.kr(\x1.kr(0)).urange(400, 800), 0, 0.1) } +> \test; 

*/

X {
	*new { | id = 1 |
		^In.kr(format("x%", id).asSymbol.bus.index, 1)
	}
}

Y {
	*new { | id = 1 |
		^In.kr(format("y%", id).asSymbol.bus.index, 1)
	}
}

Z {
	*new { | id = 1 |
		^In.kr(format("z%", id).asSymbol.bus.index, 1)
	}
}

