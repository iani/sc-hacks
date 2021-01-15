//: 16 Jan 2021 01:35
/*
Allow using observer pattern.

CmdPeriod addDependant: { | ... args | postf("cmd period args: %\n", args) };

\test.addNotifier(CmdPeriod, \cmdPeriod, { "yes i respond to command period".postln; });

*/

+ CmdPeriod {
	*initClass {
		StartUp add: {
			CmdPeriod add: {
				{ CmdPeriod.changed(\cmdPeriod); }.defer;
			}
		};
	}
}