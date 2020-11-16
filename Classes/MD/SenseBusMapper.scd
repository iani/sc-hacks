/* 16 Nov 2020 13:16 OBSOLETE

SEE SenseBus, X, Y, Z
u
14 Nov 2020 09:52 reviewing this - 
will redo simplifying structure, by attaching dependants
directly to SenseServer rather than via mediating XBeeArray.

================================================================
OBSOLETE
================================================================

11 Nov 2020 09:54

Process data received from SenseStage via OSC, in response to 
\update message sent by SenseServer.

Data structure is: 
    args message, timestamp;
where: 
message is: ['/minibee/data', x, y, z, beeID]

XBeeArray: Holds an array of SenseMapper Instances, and 
delegates to them the data received from SenseServer, so that they
may process the data and set their bus values.

Works as dependant of SenseServer.

SenseMapper contains an array of 3 busses and specs correspoding to the 
3 values (x, y, z) received from XBeeArray.  It sets each bus to a value
calculated by mapping the data received from XBeeArray according to the specs.

This creates a structure of 3 levels. In more detail: 

Level 1: XBeeArray received data from SenseStage via SenseServer.

The data are of the form:
['/minibee/data' x, y z, id]
where: 
'/minibee/data' is the name of the OSC message sent by SenseStage
x, y, z are the data from the accellerometer. Each one of these must be mapped
and processed further. 
id is the id of the xbee that sent the data, that is used as index to access the appropriate xbee. Each xbee will have separate mappers and separate bus names for each of the data. The XBeeArray selects SenseMapper corresponding to the xbee that sent the data by accessing using the numeric id as index.

Level 2: The SenseMapper selected by XBeeArray processes the data and sets busses

The SenseMapper selected by XBeeArray at level 1 above processes the array of data received from the XBeeArray, using its specs to map the data and then to set its busses. A SenseMapper instance contains 3 busses, corresponding to x, y, z data received from an XBee.  Each bus is stored with its spec in an instance of SenseMapper - in Level 3:

Level 3: SenseMapper maps a single data item and sets its bus
For each data number received from XBeeArray, SenseMapper uses its spec to map it, and then sets the bus corresponding to it. SenseMapper creates the name of the bus on the basis of the ID number and the prefix x, y or z. Example: 

For id number 1 and dimension x the bus name is x1.
For id number 1 and dimension y the bus name is y1.
Etc.

Producing the following triplets of busses for each xbee:
Xbee id 1: [x1, y1, z1].
Xbee id 2: [x2, y2, z2].
etc.

To change the spec for any dimension (x, y or z) of any xbee of any id, 
send it XBeeArray instance the message spec_:

anXBeeArray.spec_(id, dimension, argSpecSpec)

where: 

- id is the id of the XBee whose spec should be modified.
- dimension is one of \x, \y or \z indicating the dimension whose spec should be modified. 
- argSpecSpec is the new spec, given as a a spec or any object that 
creates a spec in response to the message 'spec', such as \freq, or [0, 1, \linear].

XBeeArray().inspect;

*/

XBeeArray {
	var <mappers;
	*new { | ... specs |
		^super.new.init(specs);
	}

	init { | specs |
		var new, ids, maxid;
		// provide default specs if not given
		if (specs.size == 0) {
			specs = { | i |
				[i + 1, [0.47, 0.53, \linear]]
			} ! 4;
		};
		ids = specs collect: _.first;
		maxid = ids.maxItem + 1;
		maxid.postln;
		mappers = Array.newClear(maxid);
		specs do: { | spec |
			mappers[spec[0]] = SenseMapper(*spec);
		};
	}
	
	update { | data, timestamp |
		data.postln;
		timestamp.postln;
		/*
			SenseMapper.map(data);
		*/
	}
}

SenseMapper {
	classvar <>busnames = #["x", "y", "z"];
	var id, specs, busses, funcs, synths;
	*new { | id, specs |	
		^this.newCopyArgs(id, specs).init;
	}

	// create both busses and i/o function
	init {
		// for each spec in specs, create name of bus and get the bus
		busses = IdentityDictionary.new;
		busnames do: { | name |
			name = format("%%", name, id).asSymbol;
			busses[name] = name.bus;
		}
	}

	map { | data |
		// map data received from XBeeArray and set busses
		/*
			[data[1..], busses].flop do: { | data, bus |
			}
		*/
	}
}

