/* 16 Nov 2020 13:17

A SenseServer dependant which maps the x y z data to bipolar range, and 
sends their values to control busses.

Busses naming scheme:

For SenseStage XBee with ID n: \Xn, \Yn, \Zn

Per default, create 4 sets of busses (3 x 4 = 12 busses in all), 
corresponding to the 4 Xbees currently in use.
Can be increased to a larger number of busses.

\x1.bus;

*/

SenseBus : SenseDependant {
	classvar <>defaultSpec = #[0.47, 0.53];
	classvar <>defaultMaxID = 4;
	var <maxID, <specs, <busses;
	// for testing purposes (temporary):
	var verbose = true;
	
	init { | argName, argMaxID, argSpec |
		var specTemplate;
		// postf("SenseBus calling init with argName: %\n", argName);
		super.init(argName);
		maxID = argMaxID ? defaultMaxID;
		if (argSpec.isNil) {
			specTemplate = defaultSpec.asSpec;
		}{
			specTemplate = argSpec.asSpec;
		};
		specs ={ | i |
			{ specTemplate.copy } ! 3
		} ! maxID;

		busses = { | i |
			i = i + 1;
			["x", "y", "z"] collect: { | n | format("%%", n, i).asSymbol.bus.postln };
		} ! maxID;
	}

	update { | data, time |
		if (verbose) {
			postf("SenseBus % testing %, %, %\n", name, data, time);
		};
	}

	// for testing. (temporary):
	verbose { verbose = true }
	mute { this.silent }
	silent { verbose = false }
}