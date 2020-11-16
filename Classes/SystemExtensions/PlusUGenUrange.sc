/* Notes 16 Nov 2020 11:07

urange and expurange may become obsolete when I figure out how to work
with data mapped to bipolar range and yet monitor them on scope or gui sliders.

Short explanation: urange and expurange forces the range operator to work as if
the input signal is *not* of type \bipolar, for cases where the input UGen says
that it is \bipolar.

Long explanation: 

The range ugen is designed to work with an input ranging from -1 to 1.
For example:

myInput.range(400, 800);

produces output like this:

when myInput is -1, output is 400
when myInput is 1, output is 800

However, when the range of the input is from 0 to 1, range will not 
work as specified:

when myInput is 0, output is 600.
when myInput is 1, output is 800.

urange is designed to work with inputs whose range is from 0 to 1. That is:

For 

myInput2.range(400, 800);

when myInput2 is 0, output is 400
when myInput2 is 1, output is 800

You can test this with the following example:

(
{
	var input, trig;
	input = Line.kr(-1, 1, 10); // LFPulse.kr(2);
	trig = Impulse.kr(4);
	input.poll(trig, "=== input ====");
	input.range(400, 800).poll(trig, "range");
	input.urange(400, 800).poll(trig, "urange");
}.play;


)



*/

+ UGen {
	urange { | lo = 0, hi = 1 |
		// explicitly map from range 0-1 to target range
		// adapted from UGen::range
		var mul, add;
		mul = (hi - lo);
		add = lo;
		^MulAdd(this, mul, add);
	}

	/* // removed  9 Mar 2020 12:32
	linexp { | lo = 1.0, hi = 2 |
		// shortcut for linexp of sources whose range is 0-1
		if (rate == \audio) {
			^LinExp.ar(this, 0, 1, lo, hi);
		}{
			^LinExp.kr(this, 0, 1, lo, hi);
		}
	}
	*/
}

/*
LinExp : PureUGen {
	checkInputs { ^this.checkSameRateAsFirstInput }
	*ar { arg in=0.0, srclo = 0.0, srchi = 1.0, dstlo = 1.0, dsthi = 2.0;
		^this.multiNew('audio', in, srclo, srchi, dstlo, dsthi)
	}
	*kr { arg in=0.0, srclo = 0.0, srchi = 1.0, dstlo = 1.0, dsthi = 2.0;
		^this.multiNew('control',  in, srclo, srchi, dstlo, dsthi)
	}
}
*/
	
