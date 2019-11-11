/* 29 Jul 2018 14:02
Return path of the home directory of sc-hacks library.
In future possibly also perform other global management tasks.
*/

Hacks : Singleton {

	homeDir {
		^PathName(this.class.filenameSymbol.asString).pathOnly;
	}

	snippetDir {
		^PathName(this.homeDir).parentPath ++ "Snippets/";
	}

	synthdefDir {
		^this.snippetDir ++ "SynthDefs/";
	}
	

	defaultGui {
		this.br_.v(
			{ SnippetList.gui }.button("Snippet List"),
			{ PlayerSnippetList.gui }.button("Player Snippet List"),
			{ PlayerGui() }.button("Player Gui"),
			{ OSCRecorder.gui }.button("OSC recorder"),
			{ ServerConfig.gui }.button("Configure Server"),
			[
				["Boot Server", Color.black, Color.green], { Server.default.boot },
				["Quit Server", Color.white, Color.red], { Server.default.quit}
			].button.addServerNotifier
		);
	}

	
	
	loadAudioFiles { | path = "~/sounds" |
		/* Load audio files contained in folder specified by path
			and it subfolders. 
		*/
		var filePaths, server;
		filePaths = List();
		postf("LOADING AUDIO FILES FROM FOLDER: %\n", path);
		this.audioFilePaths(path ? "~/sounds", filePaths);
		server = S.default; // cache server for iteration over file paths
		filePaths do: { | afpath |
			ServerBoot.add({ this.loadAudioFile(afpath) }, server);
			if (server.serverRunning) { this.loadAudioFile(afpath); };
		};
		^filePaths;
	}

	audioFilePaths { | path, filePaths |
		// 1: Add all sound files in this folder to filePaths
		["wav", "WAV", "aif", "AIF", ".aiff", "AIFF"] do: { | type |
			(path +/+ format("*.%", type )).pathMatch
			.select({ | p | p.last != $/}) do: filePaths.add(_);
		};
		// 2: Call audioFilePaths on each subfolder of this folder
		(path +/+ "*").pathMatch.select({ | p | p.last === $/ })
		do: this.audioFilePaths(_, filePaths);
		^filePaths;
	}

	loadAudioFile { | path |
		/* Load audiofile from path into buffer, to default server.
			Always reload to server whenever it (re)boots.
			If default server is booted, then load now.
		*/
		var buffer, name;
		path = path.standardizePath;
		name = 	PathName(path).fileNameWithoutExtension.asSymbol;
		name.addNotifier(S.default, \booted, {
			this.loadOrAlloc(path, name);
		});
		if (S.serverRunning) { this.loadOrAlloc(path, name) };
	}

	loadOrAlloc { | path, name |
		/* Presuming that the server is booted,
			load audiofile from path to buffer.
			If file does not exist, then allocate buffer instead.
			Store buffer in Registry under \buffers, name.
		*/
		var buffer, alreadyLoadedBuffer;
		// Free preexisting buffer:
		alreadyLoadedBuffer = Registry.at(\buffers, name);
		alreadyLoadedBuffer !? { "freeing ".post; alreadyLoadedBuffer.postln.free };
		buffer = path.doIfExists({ | thepath |
			postf("loading buffer % from \n  %\n", name, thepath);
			Buffer.read(Server.default, thepath /*, action: func */);
		},{ | thepath |
			postf("Could not find audio file:\n  %\n", thepath);
			"=== Allocating empty buffer of 1 second duration ===".postln;
			Buffer.alloc(S.default, S.sampleRate, 1).path_(thepath)
		});
		^Registry.put(\buffers, name, buffer)
	}
	/*
	bufferListGui {
		var bufferListModel; // contains list of buffers and names
		// Updates buffers and names and list when they change
		// Returns name list for listview
		// Returns single buffer for listview for playing or other purposes.
		bufferListModel = BufferListModel()
		\buffers.v(
			ListView()
			.font_(Font("Helvetica", 32))
			.items_
			.action_({ | me |
				me.items[me.selection].postln;
			})
		)
	}
	*/
	buffers {
		^this.buffersOrDict.values;
	}

	buffersOrDict {
		^(Registry.at(\buffers) ?? { IdentityDictionary.new })
	}

	bufferNames {
		^this.buffersOrDict.keys;
	}
	}

/* Adapted from History::formatTime
*/

+ SimpleNumber {
	formatTime {
		var val, h, m, s;
		val = this;
		h = val div: (60 * 60);
		val = val - (h * 60 * 60);
		m = val div: 60;
		val = val - (m * 60);
		s = val;
		if (h > 0) {
			^"%:%:%".format(h, m, s.round(0.01))
		}{
			^"%:%".format(m, s.round(0.001))
		}
	}
}