/* 13 Mar 2019 09:56
Manage tempo clocks for Nevent.
Reset tempo clocks when stopped (by Main.stop etc.).
Help Nevent instances share TempoClock instances.
*/

Clocks {
	classvar <clocks;
	classvar <>quant = 1;
	classvar <>defaultQuant = 1, <>defaultTempo = 1;

	
	*initClass {
		clocks = ();
	}

	*getClock { | envir |
		^TempoClock.default;
	}
	
}