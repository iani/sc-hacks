// 21 Aug 2018 13:30
// Experimental: Store history of snippets sharing a title.
// Only add new code if it is different from the last stored one.

SnippetHistory {
	var <name, <snippet, <time;

	code { ^snippet.code }

	*initClass {
		ShutDown add: {
			this.save;
		}
		
	}
	
	*new { | name, snippet |
		"DEBUGGING SnippetHistory".postln;
		["snippet is: ", snippet].postln;
		^this.newCopyArgs(name, snippet, Date.localtime);
	}

	add { | type |
		Player.changed(\history, Registry.add(type, name.asSymbol, this))
	}
	
	*save {
		Registry.at(\CodeSnippets).writeArchive(
			Platform.userAppSupportDir +/+ "SnippetHistory_" ++ Date.localtime.stamp ++ ".sctxar"
		);
		Registry.at(\PlayerSnippets).writeArchive(
			Platform.userAppSupportDir +/+ "PlayerHistory_" ++ Date.localtime.stamp ++ ".sctxar"
		)
	}

	guiWidget {
		^HLayout(
			// StaticText().string_(snippet.code).background_(Color.rand),
			TextView()
			.string_(snippet.code)
			.background_(snippet.color)
			//.mouseLeaveAction_({ | me |
			//	me.string.postln;
			// 	snippet.code = me.string;
			//})
			,
			Button()
			.maxWidth_(50)
			.states_([["RUN"]])
			.action_({ snippet.run; })
		)
		
	}
	
}
