// 21 Aug 2018 17:27
/*
Experimental : send result of running a snippet to the selected player.

INCOMPLETE
*/

PlayerSnippet : Snippet {
	run {
		var rootDir, currentDir;
		// experimental: keep history of snippets ////////////////
		SnippetHistory(name, code);
		////////////////////////////////////////////////////////////////
		rootDir = SnippetList.rootDir;
		currentDir = pathOnly;
		postf("running snippet: %. includes are: %\n", name, includes);
		includes do: { | i |
			if (i[0] === $/) {
				currentDir = rootDir ++ i[1..]
			}{
				(currentDir ++ i ++ ".scd").doIfExists({ | p |
					postf("Running include:\n%\n", p);
					p.load;
				},{ | p |
					postf("Did not find include:\n%\n", p);
				})
			}
		};
		// TODO: send the result of intrpreting the snippet to the selected player
		//		code.postln.interpret;
	}
	
}