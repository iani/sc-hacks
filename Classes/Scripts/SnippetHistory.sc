// 21 Aug 2018 13:30
// Experimental: Store history of snippets sharing a title.
// Only add new code if it is different from the last stored one.

SnippetHistory {
	var <name, <history;

	*new { | name, code |
		^Registry(this, name.asSymbol, {
			this.newCopyArgs(name, []);
		}).addIfNew(code);
	}

	addIfNew { | argCode |
		if (argCode != history.last) { history = history add: argCode }
	}

	*save {
		Registry.at(this).writeArchive(
			Platform.userAppSupportDir +/+ "History_" ++ Date.localtime.stamp ++ ".sctxar"
		)		
	}
}
