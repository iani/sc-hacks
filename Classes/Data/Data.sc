// 18 Jul 2017 19:32
/*
	Read data from file using CSVFileReader.
	Handle default data directory from UserAppSupportDir.
	Store in Library under file name.
	Load data lazily upon request.

	Also store buffers to files with both raw and normalized data.
	Data is converted based on the format known from VLI data received from
	NOA via Fiori Anastasia Metallinou.

	================================================================
	Tests:

	Data.names;

	Data.at(Data.names[1]).vliColumns[4].first.class;

	Data.at(Data.names[1]).vliData[2];
	Data.at(Data.names[1]).vliData[0];
	Data.at(Data.names[1]).vliData[1];

	Data.at(Data.names[1]).x;
	Data.at(Data.names[1]).y;
	Data.at(Data.names[1]).z;

	Data.at(1).vliData;
	Data.at(1).buffer;

	Data.at(1).buffer.play;

	Server.default.scope;

*/

Data {
	classvar <dataDir, default;
	var <path, <filename, array, <numCols;
	var vliData;
	var buffer, xbuffer, ybuffer, zbuffer;
	var nbuffer, nxbuffer, nybuffer, nzbuffer;
	
	*initClass {
		this.readFiles; // create 1 instance per data file found
		// When Server boots, prepare all buffers for default instance:
		ServerBoot add: {
			{ this.prepareAll }.defer (3); // defer needed for server to be ready for buffers
		};
	}

	*readFiles {
		var filename;
		Class.initClassTree (Library);
		dataDir = Platform.userAppSupportDir ++ "/Data";
		(dataDir ++ "/*.dat").pathMatch do: { | path |
			filename = PathName (path).fileNameWithoutExtension.asSymbol;
			postf ("Data reading file: %\n", filename);
			Library.put (\data, filename,		
				this.newCopyArgs (path, filename))
			;
		};
	}

	*at { | name |
		^switch (name.class,
			Integer, {
				Library.at(\data, this.names[name]);
			},
			Symbol, {
				Library.at (\data, name);
			}
		);
	}

	*names {
		^Library.at (\data).keys.asArray.sort;
	}

	printOn { arg stream;
		stream << this.class.name << "( " << filename <<" )"
	}

	array {
		if (array.isNil) {
			array = CSVFileReader.read(path);
			numCols = array.collect({|r|r.size}).maxItem;
		};
		^array;
	}

	rows { ^this.array } // synonym...

	*xyz { ^this.default.xyz }
	xyz { ^this.vliData }
	vliData {
		^vliData ?? {
			vliData = this.vliColumns;
		}
	}
	
	vliColumns {
		this.array.select ({ | r | r.size == 7 }).flop;
		^this.array.select ({ | r | r.size == 7 })
		.flop [[2, 3, 4]]
		.collect ({ | col |
			col.collect ({ | s | s.vliValue })
		});
	}

	x { ^this.vliData [0] }
	y { ^this.vliData [1] }
	z { ^this.vliData [2] }
	
	buffer {
		/* 
			This is wrong: The buffer has the same signal in all channels,
			instead of x, y, z.
			Therefore use xyzbuffer method instead of this.
		*/
		^buffer ?? {
			Buffer.load2File (
				dataDir ++ "/" ++ filename.asString ++ "3.aiff",
				this.vliData.flat,
				3,
				{ | b  |
					b.postln;
					buffer = b;
				}
			)
		}
	}

	xyzbuffer {
		/* returns all 3 x,y,z buffers for use in doWith */
		// in place of a 3channel buffer - which does not work yet.
		^[this.xbuffer, this.ybuffer, this.zbuffer];
	}

	xbuffer {
		^xbuffer ?? {
			Buffer.load2File (
				dataDir ++ "/" ++ filename.asString ++ "x.aiff",
				this.vliData [0],
				1,
				{ | b  |
					b.postln;
					xbuffer = b;
				}
			)
		}
	}

	ybuffer {
		^ybuffer ?? {
			Buffer.load2File (
				dataDir ++ "/" ++ filename.asString ++ "y.aiff",
				this.vliData [1],
				1,
				{ | b  |
					b.postln;
					ybuffer = b;
				}
			)
		}
	}

	zbuffer {
		^zbuffer ?? {
			Buffer.load2File (
				dataDir ++ "/" ++ filename.asString ++ "z.aiff",
				this.vliData [2],
				1,
				{ | b  |
					b.postln;
					zbuffer = b;
				}
			)
		}
	}

	// var nbuffer, nxbuffer, nybuffer, nzbuffer;
	nbuffer {
		/* 
			This is wrong: The buffer has the same signal in all channels,
			instead of x, y, z. 
			See nxyzbuffer instead
		*/
		^nbuffer ?? {
			Buffer.load2File (
				dataDir ++ "/" ++ filename.asString ++ "n.aiff",
				this.vliData.flat.normalize (-1.0, 1.0),
				3,
				{ | b  |
					b.postln;
					nbuffer = b;
				}
			)
		}
	}

	nxyzbuffer {
		/* returns all 3 x,y,z buffers for use in doWith */
		// in place of a 3channel buffer - which does not work yet.
		^[this.nxbuffer, this.nybuffer, this.nzbuffer];
	}

	nxbuffer {
		^nxbuffer ?? {
			Buffer.load2File (
				dataDir ++ "/" ++ filename.asString ++ "nx.aiff",
				this.vliData [0].normalize (-1.0, 1.0),
				1,
				{ | b  |
					b.postln;
					nxbuffer = b;
				}
			)
		}
	}

	nybuffer {
		^nybuffer ?? {
			Buffer.load2File (
				dataDir ++ "/" ++ filename.asString ++ "ny.aiff",
				this.vliData [1].normalize (-1.0, 1.0),
				1,
				{ | b  |
					b.postln;
					nybuffer = b;
				}
			)
		}
	}

	nzbuffer {
		^nzbuffer ?? {
			Buffer.load2File (
				dataDir ++ "/" ++ filename.asString ++ "nz.aiff",
				this.vliData [2].normalize (-1.0, 1.0),
				1,
				{ | b  |
					b.postln;
					nzbuffer = b;
				}
			)
		}
	}

	// ================================================================
	// Facilitate sonification experiments here:
	*default { // default instance for experimentation
		^default ?? { this.setDefault };
	}
 
	*setDefault { | index = 1 |
		// set a default instance for experimentation
		^default = this.at (index);
	}

	doWith { | selector, func |
		// get data with selector and play them with func
		func.(*this.perform (selector));
	}

	*doWith { | selector, func |
		// get data with selector and play them with func
		this.default.doWith (selector, func);
	}

	prepareAll {
		// prepare all buffers for immediate performance
		// var buffer, xbuffer, ybuffer, zbuffer;
		// var nbuffer, nxbuffer, nybuffer, nzbuffer;
		"PREPARING ALL BUFFERS".postln;
		buffer = nil;
		xbuffer = nil;
		ybuffer = nil;
		zbuffer = nil;
		nbuffer = nil;
		nxbuffer = nil;
		nybuffer = nil;
		nzbuffer = nil;
		//	this.buffer; // multichannel buffer from data not working
		this.xbuffer;
		this.ybuffer;
		this.zbuffer;
		// this.nbuffer; // multichannel buffer from data not working
		this.nxbuffer;
		this.nybuffer;
		this.nzbuffer;
	}

	*prepareAll { this.default.prepareAll }
}