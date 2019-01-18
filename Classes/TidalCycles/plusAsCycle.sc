/* 
convert a TidalCycles-style string into a tree of Cycles.

Syntax constraints: each beat name string must be enclosed in spaces " hh ".

String is converted into a (nested) array of arrays or event names, and then into a Cycle.

Array is converted in to Cycle with a Pseq-Stream of Cycles or Events.

Event is converted into a CycleEvent, that just plays the single event 
after calculating its duration from the parent cycle.


*/
+ String {
	asCycle {
		/*
			Split string, separate event strings with \ and commas, 
			interpret into (nested) Array, and create Cycle from the Array.
		*/
		var inputArray, last, first;
		inputArray = this.split($ );
		last = inputArray.size - 1;
		^"[".catArgs(*inputArray.collect{ | i, index |
			first = i[0];
			if (first.isAlpha) {
				if (index == last) { "\\" ++ i } { "\\" ++ i ++ ", " }
			} {
				if (i.last === $] and: { index < last }) { i ++ "," } { i }
			}
		}.add("]")).interpret.asCycle;
	}
}

+ Symbol {
	asCycle {
		^(instrument: this).asCycle;
	}
}

+ Event {
	asCycle {
		^CycleEvent(this);
	}
}

+ Array {
	asCycle {
		^Cycle03(Pseq(this.collect(_.asCycle)), 1);
	}
	
}