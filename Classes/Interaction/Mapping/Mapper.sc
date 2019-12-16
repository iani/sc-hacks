/* 16 Dec 2019 15:26
Store and retrieve specs for sensors.

Also use these specs for mapping values received via osc or otherwise.

Use Registry for simple access.  This is slower but offers an easier interface.
Other classes can use this to cache the specs which they need. 

nil.asSpec;

\freq.asSpec;
\amp.asSpec;
[0, 100].asSpec;
[0, 100, \exp].asSpec;

Mapper.map(1.5, \sensor1, \x);

Mapper.getSpec(\sensor1, \y);

Mapper.getSpec(\sensor1, \z);

Mapper.setSpec(\sensor1, \z, [-0.5, 0.5]);

Mapper.map(1.0, \sensor1, \z);

Mapper.setSpec(\sensor1, \y, { | val | val.linlin(0.2, 0.8, 100, 2000) });

Mapper.map(0.2, \sensor1, \y);

Mapper.map(0.8, \sensor1, \y);

Mapper.map(1.8, \sensor1, \y);

linlin

{ | x | x.postln; };
	

*/

Mapper : Singleton {
	getSpec { | sensorName, itemName |
		/*  Example: 
			sensorname: \sensor1;
			itemName: \x; // or \gyroscopeX;
		*/
		^Registry(Mapper, sensorName, itemName, {
			this.makeMapperFunc(nil);
		});
	}

	map { | value, sensorName, itemName |
		// user spec in item under sensor to map incoming value
		^this.getSpec(sensorName, itemName).value(value).postln;
	}

	setSpec { | sensorName, itemName, spec |
		Registry.put(Mapper, sensorName, itemName, this.makeMapperFunc(spec));
	}

	makeMapperFunc { | specOrFunc |
		var theSpec;
		if (specOrFunc.isKindOf(Function)) {
			^specOrFunc;
		}{
			theSpec = specOrFunc.asSpec;
			^{ | val |  theSpec.map(val) };
		}
	}
	
}
