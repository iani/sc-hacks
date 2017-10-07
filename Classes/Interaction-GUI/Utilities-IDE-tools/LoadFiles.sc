// 25 Sep 2017 22:30
// Redo from scratch

LoadFiles {
	*initClass {
		StartUp add: { this.allSubclasses do: _.loadFromArchive; };
	}
	
	*loadFromArchive {
		this.archivePath.doIfExists({ | path |
			postf("% getting paths from %\n", this, path);
			this.all = Object readArchive: path;
			postf("% will load % files\n", this, this.all.size);
		}, { | path |
			postf("% could not find file to load paths:\n %\n", this, path);
		});
		// copy array because we will remove non-existing files from original.
		this.all.copy do: this.load(_);
	}

	*save {
		this.all.writeArchive(this.archivePath);
	}

	*add { | path, loadNow = false |
		if (this.all.containsString(path)) {
			^postf("% skipped loading existing:\n %\n", this, path);			
		};
		this.all = this.all add: path;
		this.save;
		if (loadNow) { this load: path };
	}

	*remove { | path |
		this.all = this.all.removeUniqueString(path);
		this.save;
		this.freeAudio(path); // CodePlayer ignores this
		this.changed(\all);
	}

	*freeAudio { /* AudioFiles adds code to free buffer here" */ }

	*loadDialog {
		Dialog.openPanel({ | paths |
			paths do: this.add(_);
		}, {
			"cancelled".postln;
		},
			true
		)
	}

	*load { | path |
		path.doIfExists({
			postf("% loading %\n", this, path);
			this prLoad: path;
		}, {
			postf("% could not find %\n", this, path);
			"removing file from paths".postln;
			this remove: path;
			this.changed(\all)
		});
	}

	*gui {
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
					notification.listener.items = this.all ? []
				})
				.focus(true); // focus here, away from load button.
			)
		})
	}

	*toggle { /* only AudioFiles uses this */ }
}

StartupFiles : LoadFiles {
	classvar <>all;

	*archivePath {
		^Platform.userAppSupportDir ++ "/StartupFiles.sctxar";
	}

	*prLoad { | path |
		path.load;
		this changed: \all;
	}

	*actionString { ^"backspace: delete, enter: load file" }

	*performEnterAction { | item |
		postf("loading: %\n", item);
		item.load; 
	}
}

AudioFiles : LoadFiles {
	classvar <>all;
	classvar buffers;

	*previewAudio { | path |
		// add+load buffer and play it immediately for preview
		if (this.all.containsString(path)) {
			this.buffers[path.asName].play;
			^postf("% :\n %\n playing buffer which is already loaded!\n", this, path);			
		};
		this.all = this.all add: path;
		this.save;
		this.loadBuffer(path, true); // true: preview when loaded	
	}
	*archivePath {
		^Platform.userAppSupportDir ++ "/AudioFiles.sctxar";
	}

	*buffers {
		buffers ?? { buffers = () };
		^buffers;
	}

	*prLoad { | path |
		// Only load if server is already running.
		if (Server.default.serverRunning) { this.loadBuffer(path) };
	}

	*initClass {
		StartUp add: {
			ServerBoot add: { this.all do: this.loadBuffer(_) }
		};
	}

	*loadBuffer { | path, preview = false |
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
				this remove: path;
			}
		);
		this.changed(\all);
	}

	*freeAudio { | path |
		this.getBuffer(path).free;
	}

	*getBuffer { | path |
		^path.asName.b;
	}
	*actionString { ^"backspace: delete, enter: set bufnum, space: toggle play" }

	*performEnterAction { | item |
		currentEnvironment.put(\bufnum, item.asName.postln.b.bufnum.postln);
	}

	*toggle { | item |
		item.asName.postln.toggleBuf; 
	}
	
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