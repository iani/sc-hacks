// 12 Oct 2017 13:23
// Maintain a list of paths to load at system startup (or lang recompile).
// Create a gui for managing this list.

StartupFiles : LoadFiles {
	classvar <>all;

	*initClass { StartUp add: { this.new.loadFromArchive.loadAll } }

	loadAll { all.copy do: this.load(_); }
	
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
						notification.listener.items = this.getItems;
						if (notification.listener.items.size > 0) {
							notification.listener.valueAction_(notification.listener.value);
						}
					})
					.addNotifier(this, \index, { | index, notification |
						notification.listener.value = index;
					})
					.action_({ | me |
						this.changed(\item, all[me.value]);
					})
					.focus(true), // focus here, away from load button.,
					VLayout(
						HLayout(
							Button()
							.states_([["load file"]])
							.action_({ this.loadDialog })
							.maxWidth_(90),
							Button()
							.states_([["save code now in file:"]])
							.action_({ this.changed(\fileCreationRequest);  })
							.maxWidth_(140)
							
							/*
								Button()
								.states_([["save"]])
								.action_({ this.changed(\save) })
								.maxWidth_(90),
							*/
						),
						HLayout(
							StaticText().string_("New file name:"),
							TextField().string_("startup_" ++ Date.getDate.stamp ++ ".scd")
							// .mouseLeaveAction_({ | me | this.changed(\saveItem, this makeSavePath: me.string) })
							.addNotifier(this, \fileCreationRequest, { | notification |
								this.changed(\saveItem, this makeSavePath: notification.listener.string) }
							)
						),
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
						{ this.changed(\index, all.indexOfString(item)) ? 0 }.defer(0.5);
						notification.listener.string
					})
				})
			);
			if (all.size > 0) { listview.valueAction_(0) };
		})
	}

	getItems { ^all.collect(_.asName) }

	makeSavePath { | filename |
		^Platform.userAppSupportDir ++ "/" ++ filename;
	}
	archivePath {
		^Platform.userAppSupportDir ++ "/StartupFiles.sctxar";
	}
	
	load { | path |
		path.doIfExists({
			postf("loading code: %\n", path);
			path.load;
		},{
			postf("removing missing file: %\n", path);
			"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
			all removeUniqueString: path;
			this changed: \all;
		})
	}

	actionString { ^"File List View keyboard commands:

Backspace: delete entry.
Enter: evaluate file code now.

Note: File code is auto-saved
when mouse leaves code edit field." }

	performEnterAction { | item |
		postf("performing enter action. item is: % \n", item);
		item.load;
	}
}