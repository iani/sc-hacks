//: 20 Dec 2020 23:26
/*
Utility for testing patterns.
Return first n values from stream.  Default n = 10;
*/

+ Pattern {
	test { | n = 10 |
		^this.asStream.nextN(n);
	}
}