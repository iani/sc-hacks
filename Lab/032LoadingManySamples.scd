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
//:
~paths;
~names;
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
Server.default.options.numBuffers = 3000;
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