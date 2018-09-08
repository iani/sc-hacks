// 21 Aug 2018 17:27
/*
Experimental : send result of running a snippet to the selected player.
*/

PlayerSnippet : Snippet {
	var <playerName;
	run {
		var rootDir, currentDir, interpretedSource;
		// experimental: keep history of snippets ////////////////
		// SnippetHistory(playerName, this).add(\PlayerSnippets);
		this.add2History;
		////////////////////////////////////////////////////////////////
		rootDir = PlayerSnippetList.rootDir;
		currentDir = pathOnly;
		postf("running snippet: %\n", name);
		includes do: { | i |
			if (i[0] === $/) {
				currentDir = rootDir ++ i[1..]
			}{
				postf("includes are: %\n", (currentDir +/+ i ++ ".scd").pathMatch);
				(currentDir +/+ i ++ ".scd").pathMatch do: { | p |
					postf("Running include: %\n", p);
					p.load;
				};
			}
		};
		try {
			interpretedSource = code.postln.interpret;			
		};
		if (interpretedSource.isNil) {
			postf("Could not interpret source code for player %\n", playerName);
		}{
			interpretedSource +> playerName;
		}
	}

	init {
		super.init;
		playerName = pathName.fileNameWithoutExtension.asSymbol;
	}

	add2History {
		SnippetHistory(playerName, this).add(\PlayerSnippets);		
	}
}