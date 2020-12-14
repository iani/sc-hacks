//: 14 Dec 2020 08:47 Arithmetic on rational numbers
/* draft 

1 -- 2;

15 -- 10;


(1 -- 2) == (2 -- 4);
(1 -- 2) == (2 -- 5);

(1 -- 2) < (2 -- 5);

(1 -- 3) < (2 -- 5);

(1--2)*(1--2);
(1--2)+(1--2);
(1--2)+(1--4);
(1--2)-(1--4);
(1--2)*(2--4);

*/

Rational {
	var <numerator, <denominator;

	*new { | numerator, denominator |
		^this.newCopyArgs(numerator, denominator).init;
	}

	init {
		//? canonical form
		var gcd;
		gcd = numerator gcd: denominator;
		numerator = (numerator / gcd).asInteger;
		denominator = (denominator / gcd).asInteger;
		// canonical form: only numerator may be negative
		if (denominator < 0) {
			denominator = denominator * -1;
			numerator = numerator * -1;
		}
	}

	printOn { arg stream;
		if (stream.atLimit, { ^this });
		stream << "(" ;
		stream << numerator.asString;
		stream << "/";
		stream << denominator.asString;
		stream << ")" ;
	}

	+ { | rational |
		var c, d;
		c = rational.numerator;
		d = rational.denominator;
		^Rational(
			(numerator * d) + (denominator * c),
			denominator * d
		)
	}

	- { | rational |
		var c, d;
		c = rational.numerator;
		d = rational.denominator;
		^Rational(
			(numerator * d) - (denominator * c),
			denominator * d
		)
	}

	* { | rational |
		var c, d;
		c = rational.numerator;
		d = rational.denominator;
		^Rational(
			(numerator * c),
			denominator * d
		)
	}

	/ { | rational |
		var c, d;
		c = rational.numerator;
		d = rational.denominator;
		^Rational(
			numerator * d,
			denominator * c
		)
	}

	== { | rational |
		^(numerator * rational.denominator) == (denominator * rational.numerator)
	}

	< { | rational |
		var c, d;
		c = rational.numerator;
		d = rational.denominator;
		^(numerator * d) < (denominator * c);
	}

	inverse { ^this.reciprocal }

	reciprocal {
		^Rational(denominator, numerator);
	}
}


+ Integer {
	-- { | denominator |
		^Rational(this, denominator);
	}
	
}