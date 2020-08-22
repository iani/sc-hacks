/* 22 Aug 2020 06:23
Testing and Adapting code from Buffer:readWithInfo from SuperDirt Quark
*/

// ================================================================
// COLLECT PATHS FROM ALL SUPERDIRT SOUND FILES TO TEST
//:Find the directory of SuperDirt samples quark
// finding the name of the quark. Search output on post buffer manually ... ;
Quarks.directory.keys.asArray.sort.asCompileString;
// ... Use found name to get quark
Quarks.directory["Dirt-Samples"];
// Quarks root folder:
Quarks.folder;
// Contents of downloaded quarks root folder:
(Quarks.folder +/+ "*").pathMatch;
// Using the name of the quark from above to find its path and folders:
(Quarks.folder +/+ "Dirt-Samples" +/+ "*").pathMatch;
//: collect all files in an array
var check = [];
(Quarks.folder +/+ "Dirt-Samples" +/+ "*").pathMatch do:
{ | folder |
	postf("adding files from folder: %\n", folder);
	(folder +/+ "*").pathMatch do:
	{ | path |
		path = path.asSymbol;
		if (check includes: path) { postf("duplicate found: %\n", path) };
		check = check add: path;
		Registry(\samplepaths, { List() }) add: path;
		Registry(\samplepathset, { Set() }) add: path;
	};
};
//:

//:See the result from the above:
Registry(\samplepaths).size;
//:
Registry(\samplepathset).size;
//:
Registry(\samplepathset).asArray.first.class;
//:
Registry(\samplepaths).first.class;
//:
Registry(\samplepaths)[30..34];
//:
Registry(\samplepaths).size; /// 2029
// ================================================================
// Repeat the above, checking for file name duplicates
//: collect all files in an array
var paths, names, count = 0, nduplicates = 0, duplicates, dupindexes;
paths = List.new;
names = List.new;
duplicates = List.new;
dupindexes = List.new;
(Quarks.folder +/+ "Dirt-Samples" +/+ "*").pathMatch do:
{ | folder |
	postf("adding files from folder: %\n", folder);
	(folder +/+ "*").pathMatch do:
	{ | path |
		var name;
		count = count + 1;
		paths add: path;
		name = PathName(path).fileNameWithoutExtension.asSymbol;
		if (names includes: name) {
			postf("duplicate name: %\npath: %\n", name, path);
			nduplicates = nduplicates + 1;
			duplicates add: [name, path, names indexOf: name,
				paths[names indexOf: name]
			];
		};
		names add: name;
	};
};
~paths = paths;
~names = names;
~count = count;
~nduplicates = nduplicates;
~duplicates = duplicates;
/
//: collect names and paths combining folder+filename in buffer naming scheme
var paths, names, count = 0, nduplicates = 0, duplicates, dupindexes;
paths = List.new;
names = List.new;
duplicates = List.new;
dupindexes = List.new;
(Quarks.folder +/+ "Dirt-Samples" +/+ "*").pathMatch do:
{ | folder |
	postf("adding files from folder: %\n", folder);
	(folder +/+ "*").pathMatch do:
	{ | path |
		var name;
		count = count + 1;
		name = path.bufname;
		if (names includes: name) {
			postf("duplicate name: %\npath: %\n", name, path);
			nduplicates = nduplicates + 1;
			duplicates add: [name, path, names indexOf: name,
				paths[names indexOf: name]
			];
		};
		paths add: path;
		names add: name;
	};
};
~paths = paths;
~names = names;
~count = count;
~nduplicates = nduplicates;
~duplicates = duplicates;
//:test loading a path using new method
~paths.first.postln;
~paths.first.readbuffer; // OK. Returns the buffer
//:test with wrong path: Should return nil.
(~paths.first ++ "abcde").readbuffer;  // ok. posts warning and returns nil.
//:test with all paths:
var buffers;
buffers = IdentityDictionary();
Server.default.quit;
Server.default.options.numBuffers = ~paths.size + 100;
Server.default.waitForBoot({
	~paths do: { | p, i |
		var buf;
		postf("% ", i);
		if (i % 20 == 0) { "".postln; };
		buf = p.readbuffer;
		buf !? { buffers[p.bufname] = buf };
	};
	postf("\nLoaded % buffers\n", buffers.size);
	~buffers = buffers;
});
//:
//:fast way of combining paths with names - for next step below
~namespaths = [~names, ~paths].flop;
//:read buffers with paths from above and store in names from above;
var buffers, namespaths;
buffers = IdentityDictionary();
namespaths = [~names, ~paths].flop;
Server.default.options.numBuffers = ~paths.size + 100;
Server.default.waitForBoot({
	namespaths do: { | np |
		var name, path;
		#name, path = np;
		SoundFile.use(path, { | file |
			var buffer;
			if (file.numFrames == 0) {
				postf("This is not an audio file: %\n", file.path);
			}{
				buffer = Buffer(Server.default);
				buffer.allocRead(file.path, 0, -1);
				buffer.sampleRate = file.sampleRate;
				buffer.numFrames = file.numFrames;
				buffer.numChannels = file.numChannels;
				buffers[name] = buffer;
			};
		})
	};
	postf("Loaded % buffers\n", buffers.size);
	~buffers = buffers;
});
//:
~buffers;
//:testing if all buffers have info
~buffers.values.asArray detect: { | b | b.numFrames.isNil }; // OK!
//:grouping buffers in dictionaries by folder using _ in name as separator.
~buffers.keys.asArray.first.asString.split($_);

//:Displaying the buffers in a list view by name
\buffers.window({ | w |
	w.bounds = Rect(1800, 0, 1000, 1800);
	w.layout = VLayout(
		ListView()
		.font_(Font("Helvetica", 24))
		.items_(~buffers.keys.asArray.sort)
		.action_({ | me |
			me.item.postln;
			~buffers[me.item.asSymbol].play;
		})
	)
});
//:

//: ================================================================
// more tests and earlier drafts
~buffers[\gabba_000_0].play;
~buffers[\gabba_000_1].play;
//:
\buffers.window({ | w |
	w.bounds = Rect(1800, 0, 1000, 1800);
	w.layout = VLayout(
		ListView()
		.font_(Font("Helvetica", 24))
		.items_(~buffers.keys.asArray.sort)
		.action_({ | me |
			me.item.postln;
			~buffers[me.item.asSymbol].play;
		})
	)
});
//:Displaying the buffers in a list view by name
\buffers.br_(1000, 1000).v(ListView());



~paths.size;
~names.size;
~duplicates;
//:
~duplicates do: _.postln;
//:
~duplicates do: { | d |
	postf("duplicate % at: % vs %\n",
		PathName(d[1]).fileNameWithoutExtension,
		PathName(d[1]).folderName,
		PathName(d[3]).folderName
	)
};

//:Set server options to fit enough buffer numbers:

//:Boot server;
Server.default.boot;
//:Iterate SoundFile over all buffers to check their type:
Registry(\samplepaths) do: { | p |
SoundFile.use(p, { | file |
	var buffer;
	if (file.numFrames == 0) {
		postf("This is not an audio file: %\n", file.path);
	}{
		buffer = Buffer(Server.default);
		buffer.allocRead(file.path, 0, -1);
		buffer.sampleRate = file.sampleRate;
		buffer.numFrames = file.numFrames;
		buffer.numChannels = file.numChannels;
		Registry.put(
			\samples,
			file.path.asSymbol,
			buffer
		)
	}
});
};
//:Checking possible naming scheme for samples
//:Construct name based on filename
PathName(Registry.at(\samplepaths).first).fileNameWithoutExtension;
//:
Registry.at(\samplepaths) do: { | p |
Registry(\samplenamelist, { List() }) add: PathName(p).fileNameWithoutExtension.asSymbol
};
//:
Registry(\samplenameList).size;
//:
var namelist, pathlist;
namelist = Registry(\samplenameList);
pathlist = Registry.at(\samplepaths);
~dups = pathlist collect: { | p |
var name, matches;
name = PathName(p).fileNameWithoutExtension.asSymbol;
namelist do: { | n, i | if (n===name) { matches = matches add: [i, name, p] } };
matches;
};
//:
~dups.size;
~filtereddups = ~dups select: { | i | i.size > 1 };
//:
~filtereddups.size;
~filtereddups[0..5];
x//:
Registry(\samplenameList).first;
//:
Registry(\samplenames).size;
//:
Registry(\samples).keys.asArray
//: ================================================================
//: Checking for the source of duplicates
// collect all files in an array
var folders;
(Quarks.folder +/+ "Dirt-Samples" +/+ "*").pathMatch do: { | folder |
postf("checking folder: %\n", folder);
folders = folders add: folder;
folders.select({ | f | f == folder }).size.postln;
};
//:
~filtereddups;
//:
a = ["abcde".asSymbol];
a includes: "abcde".asSymbol;