/*
Persistency for lists of files that need to be loaded at startup.
Includes 2 categories:
- .scd files are loaded upon startup with path.load
- .wav, .aiff, .aif files are loaded when Server.default is running or boots, as audio buffers.
*/

LoadFile {
	classvar <>archivePath; // Location of archive storing list of paths
	classvar <>types;       // dict of extensions for classifying to file types audio/code.
	classvar <libPath = 'LoadFile'; // root of LoadFile data tree in Registry
	classvar <filesNotFound = 'FilesNotFound'; // store paths of files not found here
	classvar <totalAudioBytes = 0;
	
	var <path, <id, <type, <name, <size, <buffer;

	*initClass {
		Class.initClassTree(Library);
		StartUp add: {
			var files;
			"\n ================ STARTING FILE LOADING ================\n".postln;
			archivePath ?? {
				archivePath = Platform.userAppSupportDir ++ "/LoadFileList.sctxar";
			};
			types = (scd: \code, wav: \audio, aiff: \audio, aif: \audio);
			if (File.exists(archivePath)) {
				files = Object.readArchive(archivePath);
			}{
				files = IdentityDictionary();
			};
			Registry.put(libPath, files);
			files[\code] do: { | f | f.init.loadCode };
			ServerBoot add: {
				{  // if done without defer, then no info is updated, 
					// and this is a conflict with buffer.play default method.
					files[\audio] do: { | f | f.init };
				}.defer(1); 
			};
			"\n ================ FILE LOADING DONE ================\n".postln;
		}
	}

	loadCode {
		File.doIfExists(path, {
			postf("Loading code file: %\n", path);
			path.load;
		},{
			postf("**************** FILE NOT FOUND ****************:\n%\n", path);
			Registry(filesNotFound, { List.new }).add(path);
		})
	}

	*new { | path |
		var instance;
		instance = this.basicNew(path);
		^Registry(libPath, instance.type, instance.id, { instance; })
	}

	*basicNew { | path |
		^this.newCopyArgs(path).init;
	}

	init {
		var pn;
		pn = PathName(path);
		name = pn.fileNameWithoutExtension;
		id = (pn.pathOnly ++ name).asSymbol;
		type = types[pn.extension.asSymbol];
		name = name.asSymbol;
		
		if (type === \audio and: { Server.default.serverRunning }) {
			File.doIfExists(path, {
				size = File.fileSize(path);
				this.loadAudio;
				this.class changed: type;
			},{
				postf("**************** AUDIO FILE NOT FOUND ****************:\n%\n", path);
				Registry(filesNotFound, { List.new }).add(path);
			}) 
		};
	}

	loadAudio {
		postf("Loading audio file: %\n", path);
		buffer = Buffer.read(Server.default, path, action: { | b |
			this.class.calculateTotalAudioBytes;
			Library.put(\buffers, name, b);
			postf("LOADED: %\n", b);
		});
	}

	*calculateTotalAudioBytes {
		totalAudioBytes = this.files(\audio).collect(_.size).sum;
	}

	*save {
		Registry.at(libPath).writeArchive(archivePath);
	}

	*remove { | instance |
		instance.remove;
		this.save;
		this.calculateTotalAudioBytes;
		this.changed(instance.type);
	}

	remove {
		if (type === \audio) { buffer.free; };
		Registry.remove(libPath, type, id);
	}

	*previewAudio { | path |
		// only listen to the buffer, then clear it.
		Buffer.read(Server.default, path, action: { | buffer |
			var synth;
			"previewing buffer: ".post;
			buffer.postln;
			synth = buffer.play;
			synth.onEnd(buffer, {
				"removing buffer: ".post;
				buffer.postln;
				buffer.free;
			})
		})
	}

	*files { | key = \code |
		^(Registry.at(libPath, key) ?? { () }).values.asArray;
	}
	// ================================================================
	// GUI
	*gui {
		var window, files, codeListView, bufferListView, audioBytesView;
		window = \loadFileGUI.window;
		window.closeChildren;
		window.bounds = (Rect(0, 0, 300, 800));
		window.name = "Loaded Code and Buffer Files";
		window.view.layout = VLayout(
			StaticText().string_("Code files loaded at startup:"),
			codeListView = ListView()
			.keyDownAction_ ({ | view, char, mod, asc |
				switch (asc,
					127, { this remove: files[view.value] }
				)
			})
			.maxHeight_(100),
			audioBytesView = StaticText().string_(
				format ("% audio files loaded (% bytes)", 0, totalAudioBytes)),
			bufferListView = ListView()
			.keyDownAction_ ({ | view, char, mod, asc |
				switch (asc,
					// return key:
					13, { files[view.value].buffer.play },
					// space key. TODO: make this open soundfile view.
					32, { files[view.value].buffer.play },
					// delete key:
					127, { this remove: files[view.value] }
				)
			})
		);

		window.front;
		
		codeListView.addNotifier(this, \code, {
			files = this.files (\code).sort({ | a b | a.name < b.name });
			codeListView.items = files collect: { | f | format("% (% bytes)", f.name, f.size)};
		});
		bufferListView.addNotifier(this, \audio, {
			files = this.files (\audio).sort({ | a b | a.name < b.name });
			bufferListView.items = files collect: { | f |
				format("% (% KB)", f.name, (f.size / (2 ** 10)) round: 0.001)};
			audioBytesView.string = format (
				"% audio files loaded (% MB)",
				files.size,
				(totalAudioBytes / (2 ** 20)) round: 0.001
			);
		});
		this changed: \code;
		this changed: \audio;
	}
	
	*codeGUI {
		var files, codeListView;
		\loadFileCodeGUI.hlayout(
			codeListView = ListView()
			.keyDownAction_ ({ | view, char, mod, asc |
				switch (asc,
					127, { this remove: files[view.value] }
				)
			})
		).name_("Autoload Code Files").front;
		codeListView.addNotifier(this, \code, {
			files = this.files (\code).sort({ | a b | a.name < b.name });
			codeListView.items = files collect: { | f | format("% (%)", f.name, f.size)};
		});
		this changed: \code;
		
	}

	*bufferGUI {
		var files, bufferListView;
		\loadFileCodeGUI.hlayout(
			bufferListView = ListView()
			.keyDownAction_ ({ | view, char, mod, asc |
				switch (asc,
					// return key:
					13, { files[view.value].buffer.play },
					// space key. TODO: make this open soundfile view.
					32, { files[view.value].buffer.play },
					// delete key:
					127, { this remove: files[view.value] }
				)
			})
		).name_("Autoload Buffer Files").front;
		bufferListView.addNotifier(this, \audio, {
			files = this.files (\audio).sort({ | a b | a.name < b.name });
			bufferListView.items = files collect: { | f | format("% (%)", f.name, f.size)};
		});
		this changed: \audio;
	}

	*dialog {
		FileDialog({ | selection |
			selection do: { | path |
				this.new(path);
			};
			this.save;
		}, fileMode: 3)
	}
}