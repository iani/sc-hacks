// 12 Oct 2017 13:24
// Manage the loading of buffers and save their paths in a list on file. 
// Create a gui for adding and playing buffers.

AudioFiles : LoadFiles {
	archivePath { ^Platform.userAppSupportDir ++ "/AudioFiles.sctxar" }

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
				ListView()
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
				  	{ notification.listener.items = this.getItems; }.defer;
				})
				.focus(true); // focus here, away from load button.
			)
		})
	}

	getItems {
		^Library.at(\buffers).keys.asArray.sort;
	}

	remove { | path |
		super remove: path;
		this.freeAudio(path); // ok if buffer does not exist.
	}

	freeAudio { | path |  path.asName.b.free } // ok if buffer does not exist.

	actionString { ^"backspace: delete, enter: set bufnum, space: toggle play" }

	performEnterAction { | item |
		currentEnvironment.put(\bufnum, item.asName.postln.b.bufnum.postln);
	}

	toggle { | item | item.asName.postln.toggleBuf }
}