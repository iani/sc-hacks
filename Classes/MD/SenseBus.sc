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
	classvar <>defaultSpec = #[0.47, 0.53, \linear];
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
		// To start, coding this very explicitly, for clarity and checking
		var xspec, yspec, zspec;
		var msg, id, x, y, z;
		var xmapped, ymapped, zmapped;
		var xbus, ybus, zbus;
		#msg, id, x, y, z = data;
		id = id - 1; // to account for index starting at 0 in sclang
		#xspec, yspec, zspec = specs[id];
		// convert 0-1 (unipolar) range to bipolar range -1 - 1 (\bipolar);
		// This is good for using range, exprange on In.kr
		// whose UGen signalrange is \bipolar.
		// Later add using unipolar version to update gui elements.
		xmapped = xspec.unmap(x) * 2 - 1; 
		ymapped = yspec.unmap(y) * 2 - 1;
		zmapped = zspec.unmap(z) * 2 - 1;
		#xbus, ybus, zbus = busses[id];

		xbus.set(xmapped);
		ybus.set(ymapped);
		zbus.set(zmapped);
		
		if (verbose) {
			postf("SenseBus % testing %, %, %\n", name, data, time);
			postf("x %, y %, z % \n - mapped: x %, y %, z %\n\n", x, y, z,
				xmapped, ymapped, zmapped
			);
		};
	}

	// for testing. (temporary):
	verbose { verbose = true }
	mute { this.silent }
	silent { verbose = false }
}