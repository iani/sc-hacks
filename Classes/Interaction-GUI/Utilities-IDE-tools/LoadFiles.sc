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

	getItems {
		^all ? [] collect: _.asName;
	}
}

StartupFiles : LoadFiles {
	classvar <>all;

	*initClass { StartUp add: { this.new.loadFromArchive.loadAll } }

	gui {
		this.window({ | w |
			var listview;
			w.bounds = Rect(400, 0, 600, 400);
			w.view.layout = VLayout(
				HLayout(
					listview = ListView().items_(this.getItems)
					.keyDownAction_({ | view, char, mod, key |
						switch (key,
							// Delete / backspace key:
							127, { this.remove(this.all[view.value]) },
							// Enter key
							13, { this.prLoad(this.all [view.value]) },
							// Space key
							32, { this.toggle(this.all [view.value]) },
							0, {}, // cursor keys: IGNORE
							{ key.postln }
						)
					})
					.addNotifier(this, \all, { | notification |
						notification.listener.items = this.getItems.postln;
					})
					.action_({ | me |
						this.changed(\item, all[me.value]);
					})
					.focus(true), // focus here, away from load button.,
					VLayout(
						Button()
						.states_([["load file"]])
						.action_({ this.loadDialog })
						.maxWidth_(90),
						/*
							Button()
							.states_([["save"]])
							.action_({ this.changed(\save) })
							.maxWidth_(90),
						*/
						StaticText().string_(this.actionString)
						.align_(\center)
					)
				),
				StaticText()
				// .background_(Color(0.5, 0.9, 1.0))
				.font_(Font("Helvetica", 10, true))
				.addNotifier(this, \item, { | item, notification |
					notification.listener.string = item
				})
				.addNotifier(this, \save, { | notification |
					this.changed(\saveItem, notification.listener.string)
				}),
				TextView().font_(Font("Monaco", 10))
				.tabWidth_(20)
				.mouseLeaveAction_({ this.changed(\save) })
				.addNotifier(this, \item, { | item, notification |
					File.readFunc(item, { | string |
						notification.listener.string = string;
						// notification.listener.syntaxColorize; // does not work?
					});
				})
				.addNotifier(this, \saveItem, { | item, notification |
					File.writeFunc(item, {
						postf("Saving code in file:\n%\n", item);
						notification.listener.string
					})
				})
			);
			listview.valueAction_(0);
		})
	}

	archivePath {
		^Platform.userAppSupportDir ++ "/StartupFiles.sctxar";
	}

	loadAll { all do: this.load(_) }

	prLoad { | path |
		postf("loading: %\n", path);
		path.load;
		// this changed: \all;
	}

	actionString { ^"List view keyboard commands:

Backspace: delete entry.
Enter: evaluate file code now.


File code is auto-saved\n when mouse leaves code edit field." }

	performEnterAction { | item |
		postf("performing enter action. item is: % \n", item);
		item.load;
	}
}


AudioFiles : LoadFiles {

	*initClass { StartUp add: { this.default.loadFromArchive.loadOnBoot } }

	*loadBuffer { | path, preview = false | this.default.loadBuffer(path, preview) }
	*getBuffer { | name | ^this.default.getBuffer(name) }
	getBuffer { | name | ^this.at_(\buffers, name) }
	
	loadOnBoot {
		ServerBoot add: {
			Library.put(this, nil); // right after boot, there are no buffers.
			this.loadAll;
		}
	}
	loadAll { all do: this.loadBuffer(_) }
	loadBuffer { | path, preview = false |
		var name;
		name = path.asName;
		if (this.getBuffer(name).notNil) {
			postf("Buffer named % already exists. Try a different filename.\n", name);
			^this;
		};
		path.doIfExists(
			{
				Buffer.read(Server.default, path, action: { | b |
					// this.buffers[name] = b;
					this.put_(\buffers, name, b);
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