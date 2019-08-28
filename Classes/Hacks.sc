/* 29 Jul 2018 14:02
Return path of the home directory of sc-hacks library.
In future possibly also perform other global management tasks.
*/

Hacks : Singleton {

	homedir {
		^PathName(this.filenameSymbol.asString).pathOnly;
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

	loadAudioFiles { | path |
		/* Load audio files contained in folder specified by path
			and it subfolders. 
		*/
		var filePaths, server;
		filePaths = List();
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
	
}