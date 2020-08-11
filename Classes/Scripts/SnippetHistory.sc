// 21 Aug 2018 13:30
// Experimental: Store history of snippets sharing a title.
// Only add new code if it is different from the last stored one.

SnippetHistory {
	classvar <>doSave = false; // 11 Aug 2020 22:36 disable saving - softly
	var <name, <snippet, <time;

	code { ^snippet.code }

	*initClass {
		ShutDown add: {
			this.save;
		}
		
	}
	
	*new { | name, snippet |
		^this.newCopyArgs(name, snippet, Date.localtime);
	}

	add { | type |
		Player.changed(\history, Registry.add(type, name.asSymbol, this))
	}
	
	*save {
		if (doSave.not) { ^"get out of here and abort." };
		
		Registry.at(\CodeSnippets).writeArchive(
			Platform.userAppSupportDir
			+/+ "SCHacksHistory/SnippetHistory_" ++ Date.localtime.stamp ++ ".sctxar"
		);
		Registry.at(\PlayerSnippets).writeArchive(
			Platform.userAppSupportDir
			+/+ "SCHacksHistory/PlayerHistory_" ++ Date.localtime.stamp ++ ".sctxar"
		)
	}

	guiWidget {
		^HLayout(
			// StaticText().string_(snippet.code).background_(Color.rand),
			TextView()
			.string_(snippet.code)
			.font_(Font("Courier"))
			.background_(snippet.color)
			.addNotifier(this, \runButton, { | n |
				if (n.listener.string == snippet.code) {
					snippet.run;			
				}{
					PlayerSnippet(name.asString, n.listener.string,
						PathName(Player.autoPath(name.asString))).run;
				}
			}),
			Button()
			.maxWidth_(50)
			.states_([["RUN"]])
			.action_({ | me |
				this.doAfterBooting({
					this.changed(\runButton);
				});
			})
		)
		
	}
}
