


DataFiles : StartupFiles {

	gui {
		this.window({ | w |
			var listview;
			w.bounds = this.rect;
			w.view.layout = VLayout(
				HLayout(
					listview = this.fileSelectionListView,
					this.buttonsAndNewFilePane
				),
				this.codeDisplay,
				this.selectedFilePathDisplay,
				this.dataDisplay;		
			);
			if (all.size > 0) { listview.valueAction_(0) };
		})
	}

	buttonsAndNewFilePane {
		^VLayout(
			HLayout(
				Button() 
				.states_([["add data file"]])
				.action_({ this.loadDialog })
				.maxWidth_(90),
				Button() 
				.states_([["save code now in file:"]])
				.action_({ this.changed( \fileCreationRequest);  })
				.maxWidth_(140)
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
			.align_(\center),
			Button()
			.states_([["load data"]])
			.action_({ this changed: \performDataLoadFunction })
		)
	}

	actionString { ^"File List View keyboard commands:

Backspace: delete entry.
Enter: load data now.
"
	}

	codeDisplay {
		^TextView().string_("Placeholder for SC code.");
	}
	dataDisplay {
		^TextView().font_(Font("Monaco", 10)) 
		.tabWidth_(20)
		.mouseLeaveAction_({ this.changed(\save) })
		.addNotifier(this, \item, { | item, notification |
			File.readFunc(item, { | string |
				notification.listener.string = string;
				// notification.listener.syntaxColorize; // does not work?
			});
		})
	}

	rect { ^Rect(400, 0, 600, 600) }

	archivePath {
		^Platform.userAppSupportDir ++ "/DataFiles.sctxar";
	}
}
