// 25 Sep 2017 22:30
// Redo from scratch

LoadFiles {
	var <all;

	*new { | name = \default |
		^Registry(this, name, { super.new });
	}
	
	*default { ^this.get_(\guis, \default, { this.new }) }
	*gui { ^this.default.gui }
	// TODO: Replace this method by separate implementations in subclasses?
	gui {
		this.window({ | w |
			w.view.layout = VLayout(
				HLayout(
					Button()
					.states_([["load file"]])
					.action_({ this.loadDialog })
					.maxWidth_(90),
					StaticText().string_(this.actionString)
					.align_(\center),
				),
				ListView().items_(this.all)
				.keyDownAction_({ | view, char, mod, key |
					switch (key,
						// Delete / backspace key:
						127, { this.remove(this.all[view.value]) },
						// Enter key
						13, { this.performEnterAction(this.all [view.value]) },
						// Space key
						32, { this.toggle(this.all [view.value]) },
						0, {}, // cursor keys: IGNORE
						{ key.postln }
					)
				})
				.addNotifier(this, \all, { | notification |
					notification.listener.items = this.getItems;
				})
				.focus(true); // focus here, away from load button.
			)
		})
	}
	loadFromArchive {
		this.archivePath.doIfExists({ | path |
			postf("% getting paths from %\n", this, path);
			all = Object readArchive: path;
			postf("% read % files.\n", this, all.size);
		}, { | path |
			postf("% could not find file to load paths:\n %\n", this, path);
		});
		// copy array because we will remove non-existing files from original.
		// all.copy do: this.load(_);
	}

	save { all.writeArchive(this.archivePath); }

	add { | path, loadNow = false |
		// Add path to the list of paths in all.
		// If loadNow is true, then load the file of this path now.
		if (all.containsString(path)) {
			^postf("% skipped loading existing:\n %\n", this, path);			
		};
		postf("% adding file: \n%\n", this, path);
		all = all add: path;
		this.save;
		this.changed(\all);
		if (loadNow) { this load: path };
	}

	remove { | path |
		all = all.removeUniqueString(path);
		this.save;
		this.changed(\all);
	}

	loadDialog {
		Dialog.openPanel({ | paths |
			paths do: this.add(_);
		}, {
			"cancelled".postln;
		},  // allow multiple selection:
			true
		)
	}

	load { | path |
		path.doIfExists({
			postf("% loading %\n", this, path);
			this prLoad: path;
		}, {
			postf("% could not find %\n", this, path);
			"removing file from paths".postln;
			this remove: path;
		});
	}

	*toggle { /* only AudioFiles uses this */ }

	*getItems {
		^this.all ? [] collect: _.asName;
	}
}

StartupFiles : LoadFiles {
	classvar <>all;

	*initClass { StartUp add: { this.new.loadFromArchive.loadAll } }

	archivePath {
		^Platform.userAppSupportDir ++ "/StartupFiles.sctxar";
	}

	loadAll { all do: this.load(_) }

	prLoad { | path |
		postf("loading: %\n", path);
		path.load;
		// this changed: \all;
	}

	actionString { ^"backspace: delete, enter: load file" }

	performEnterAction { | item | item.load }
}

AudioFiles : LoadFiles {

	*initClass { StartUp add: { this.new.loadFromArchive.loadOnBoot } }

	loadOnBoot { ServerBoot add: { this.loadAll } }
	loadAll { all do: this.loadBuffer(_) }
	loadBuffer { | path, preview = false |
		var name;
		path.doIfExists(
			{
				Buffer.read(Server.default, path, action: { | b |
					name = b.path.asName;
					this.buffers[name] = b;
					postf("Loaded %\n", b);
					this.changed(\buffer, name, b);
					if (preview) { b.play };
				});
			},{
				postf("% could not find %\n", this, path);
				"Removing file from paths".postln;
				this remove: path; // ok if buffer does not exist.
			}
		);
		// this.changed(\all);
	}
	previewAudio { | path |
		// add+load buffer and play it immediately for preview.
		// This method can be refactored to use add (!?)
		if (all.containsString(path)) {
			this.buffers[path.asName].play;
			^postf("% :\n %\n playing buffer which is already loaded!\n", this, path);			
		};
		this.all = this.all add: path;
		this.save;
		this.loadBuffer(path, true); // true: preview when loaded	
	}
	archivePath {
		^Platform.userAppSupportDir ++ "/AudioFiles.sctxar";
	}

	buffers {
		^Buffer.get_(\buffers, \default,{ () } ) ;
	}

	prLoad { | path |
		// Only load if server is already running.
		if (Server.default.serverRunning) { this.loadBuffer(path) };
	}

	remove { | path |
		super remove: path;
		this.freeAudio(path); // ok if buffer does not exist.
	}
	
	freeAudio { | path |  this.getBuffer(path).free } // ok if buffer does not exist.

	getBuffer { | path | ^path.asName.b }
	actionString { ^"backspace: delete, enter: set bufnum, space: toggle play" }

	performEnterAction { | item |
		currentEnvironment.put(\bufnum, item.asName.postln.b.bufnum.postln);
	}

	toggle { | item | item.asName.postln.toggleBuf }
}


+ Nil {
	containsString { | string | ^false; }
	addUniqueString { | string |
		^[string]
	}

	removeUniqueString { | string |
		^[]
	}
	
}

+ Array {
	containsString { | string | ^this.detect({ | s | s == string }).notNil; }

	addUniqueString { | string |
		if (this containsString: string) {
			postf("prevented adding duplicate string:\n%\n", string);
			^false;
		}{
			^this add: string;
		}		
	}

	removeUniqueString { | string |
		var found;
		found = this.detect({ | s | s == string });
		if (found.isNil) {
			postf("could not remove string because it was not found:\n%\n", string);
		}{
			this remove: found;
		}
	}
}

+ String {
	asName { ^PathName(this).fileNameWithoutExtension.asSymbol }
	
}