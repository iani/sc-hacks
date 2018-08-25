// 21 Aug 2018 13:30
// Experimental: Store history of snippets sharing a title.
// Only add new code if it is different from the last stored one.

SnippetHistory {
	var <name, <code, <time;

	*new { | type, name, code |
		^Registry.add(type, name.asSymbol, this.newCopyArgs(name, code, Date.localtime));
	}

	*save {
		Registry.at(this).writeArchive(
			Platform.userAppSupportDir +/+ "History_" ++ Date.localtime.stamp ++ ".sctxar"
		)		
	}
}
