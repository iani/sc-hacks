//  8 Mar 2019 15:31
1 respondsTo: \play;

1 respondsTo: \postln;

//:
Object respondsTo: \size;

Object.dumpClassSubtree;

1.size;

Collection.dumpClassSubtree;
//:
();
//:
().play;
//:
a = ();
//:
a.freq;
//:
a.play;
//:
b = ();
//:
b isKindOf: Dictionary;
//:
b isKindOf: Object; 
Class isKindOf: Object;
b isKindOf: Class;
b.class isKindOf: Class;
b.class isKindOf: Object;
//:
b;
//:
b.size
//:
b.keys;
//:
b.values;
//:
b.values.size;
//:
b.put(\freq, 500);
b.play;
//:
b.put(\freq, 1500);
b.play;

//:
b[\freq] = 1500.rand + 100;
b.play;
//:
b.at(\freq);
//:
b[\freq];
//:
b.keys;
//:
b.values;
//:
b.values.class;
//:
b.values do: { | value |
	value.postln;
}

//:
b.values do: { | value |
	value.class.postln;
}
//:
b.values select: { | value |
	value isKindOf: SimpleNumber;
}
//:
b.values select: { | value |
	value isKindOf: SimpleNumber;
} collect: { | value |
	b.findKeyForValue(value)
};
//:
r = {
	loop {
		"I am routine R".postln;
		0.5.wait;
	};
}.fork;
q = {
		loop {
		"I am routine QQQQQ".postln;
		1.5.wait;
	}
}.fork;
//:
r.stop;
//:
f = {
	var period = 1;
	var routine;
	(
		start: {
			routine.stop;
			routine = {
				loop {
					(degree: 10.rand, dur: 0.1).play;
					period.wait;
				};
			}.fork;
		},
		setPeriod: { | me, value |
			period = value;
		}
	);

};
//:
p = f.value;
//:
p.start;
p.setPeriod(0.1);
p.setPeriod(0.2);