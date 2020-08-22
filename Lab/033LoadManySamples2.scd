/* 23 Aug 2020 02:45
Load all files from Dirt-Samples,
store them in environment variables using first part
of name as key.
*/
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
//:Load buffers from all paths
var buffers;
buffers = IdentityDictionary();
Server.default.quit;
Server.default.options.numBuffers = ~paths.size + 100;
Server.default.waitForBoot({
	~paths do: { | p, i |
		var buf;
		postf("% ", i);
		if (i % 17 == 0) { "".postln; };
		buf = p.readbuffer;
		buf !? { buffers[p.bufname] = buf };
	};
	postf("\nLoaded % buffers\n", buffers.size);
	~buffers = buffers;
});
//:Create environment variables with dictionaries for the buffers
// collect variable name set
var names, fnamef, lnamef;
names = Set();
fnamef = { | b | b.asString.split($_).first.asSymbol };
lnamef = { | b |
	var h;
	b = b.asString;
	b[b.indexOf($_) + 1..].asSymbol;
};
~buffers.keys do: { | b |
	names add: fnamef.(b);
};
names do: { | n | currentEnvironment[n] = IdentityDictionary() };
~buffers keysValuesDo: { | name, buffer |
	currentEnvironment[fnamef.(name)].put(
		lnamef.(name), buffer;
	);
};
//:see what has been stored
currentEnvironment.keys;
//:access one group;
~toys;
//:access individual buffers;
~toys['Colors-Words'].play;
~toys['Numbers-Words'].play;
//:are all buffers stereo? 1560 are mono!
~buffers.values.select({ | b | b.numChannels < 2 }).size;


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
