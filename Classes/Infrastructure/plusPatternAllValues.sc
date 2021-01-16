//: 16 Jan 2021 16:13
/*
Create a stream from a pattern and return all values of that stream,
until it has ended (i.e. until it returns nil), or until limit size is reached.
Default limit size is 1000000.

This is safe also for Patterns of infinite lenght.

Pseries(1, 1, 5).allValues;
Pseries(1, 1, 5).allValues.sum;
Pseries(1, 1, inf).allValues.size;
Pseries(1, 1, inf).allValues[999990..];
Pbrown(1, 10, 2, 5).allValues;
*/

+ Pattern {
	allValues { | limit = 1000000 |
		var stream, values, currentvalue, count = 0;
		stream = this.asStream;
		while {
			((currentvalue = stream.next).notNil and: {
				(count) < limit			
			})
		}{
			values = values add: currentvalue;
			count = count + 1;
		};
		^values
	}

	sum { | limit = 1000000 |
		^this.allValues(limit).sum;
	}
}