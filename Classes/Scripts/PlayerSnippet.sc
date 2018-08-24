// 21 Aug 2018 17:27
/*
	Experimental : send result of running a snippet to the selected player.

	INCOMPLETE
*/

PlayerSnippet : Snippet {
	var <playerName;
	run {
		var rootDir, currentDir;
		// experimental: keep history of snippets ////////////////
		// SnippetHistory(name, code);
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
		// TODO: send the result of intrpreting the snippet to the selected player
		code.postln.interpret +> playerName;
	}

	init {
		super.init;
		playerName = pathName.fileNameWithoutExtension.asSymbol;
	}
}