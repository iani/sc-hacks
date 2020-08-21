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
// collect all files in an array
(Quarks.folder +/+ "Dirt-Samples" +/+ "*").pathMatch do: { | folder |
postf("adding files from folder: %\n", folder);
(folder +/+ "*").pathMatch do: { | path |
Registry(\samplepaths, { List() }) add: path;
};
};
//:See the result from the above:
Registry(\samplepaths);
//:
Registry(\samplepaths)[30..34];
//:
Registry(\samplepaths).size; /// 2029
//:Set server options to fit enough buffer numbers:
Server.default.options.numBuffers = 3000;
//:Boot server;
Server.default.boot;
//:+Load all buffers:
Registry(\samplepaths) do: { | p |
     postf("Loading: %\n", p);
     Registry(\samples, p.asSymbol, { Buffer.read(Server.default, p) } );
};
//:Do the above  again - but exclude non-audio files.
// Use code for testing file type, from SuperDirt lib.

//:
