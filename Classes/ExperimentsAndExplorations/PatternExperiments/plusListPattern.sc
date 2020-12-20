//: 20 Dec 2020 06:08 experimental extensons for list pattern
/*
isFinite : true if repeats is not infinite
maxItem : largest item - or inf if lenghth is infinite
minItem : smallest item - or -inf if lenghth is infinite
reverse: Reverse order of playback
invert: vertical mirror 
*/

/*
	1 != inf; // true 
	inf != inf;// false
	10 max: inf; // inf
    10 min: inf; // 10.0
*/

+ Pattern {
	finitep {
		// note: Only certain subclasses of Pattern can answer true to this 
		^false;
	}

	maxItem { ^inf } // only certain subclasses return a smaller number

}

+ ListPattern {
	finitep { ^repeats != inf }
	maxItem {
		^list.collect(_.maxItem).max;
	}
}

+ Pseries {
	finitep { ^length != inf }
	
}

+ Pfuncn {
	finitep { ^repeats != inf }
}

+ Ptime {
	finitep { ^repeats != inf }
}

+ Pn {
	finitep { ^repeats != inf }
}

+ Pgate {
	finitep { ^repeats != inf }
}