// 21 Aug 2018 13:30
// Experimental: Store history of snippets sharing a title.
// Only add new code if it is different from the last stored one.

SnippetHistory {
	var <name, <code, <snippet, <time;

	*initClass {
		ShutDown add: {
			this.save;
		}
		
	}
	
	*new { | type, name, code, snippet |
		Player.changed(\history,
			Registry.add(
				type, name.asSymbol, this.newCopyArgs(name, code, snippet, Date.localtime))
		);
	}

	*save {
		Registry.at(\CodeSnippets).writeArchive(
			Platform.userAppSupportDir +/+ "SnippetHistory_" ++ Date.localtime.stamp ++ ".sctxar"
		);
		Registry.at(\PlayerSnippets).writeArchive(
			Platform.userAppSupportDir +/+ "PlayerHistory_" ++ Date.localtime.stamp ++ ".sctxar"
		)
	}
}
