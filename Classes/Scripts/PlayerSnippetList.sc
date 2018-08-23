// Testing subclass

PlayerSnippetList : SnippetList {
	*initClass {
		StartUp add: {
			ServerQuit add: {
				// prepare to load before and/or head snippets at next run
				this.snippetOnServer = 0;
			};
		}
	}

	*folderPath {
		^PathName(this.filenameSymbol.asString).pathOnly ++ "Players/"
	}

	*popupMenu {
		^PopUpMenu()
		.items_([
			"--- UTILITIES MENU ---",
			"Browse Classes and Methods",
			"Recompile",
			"Snippet Gui",
			"Meter",
			"Scope",
			"Frequency Scope"
		])
		.action_({ | me |
			[
				{},
				{ Class.extensionsGui },
				{ thisProcess.platform.recompile; },
				{ SnippetList.gui },
				{ ServerMeter(Server.default) },
				{ Server.default.scope },
				{ Server.default.freqscope }
			][me.value].value;
		})
	}
	
	readAll {
		^PlayerSnippet.readAll(path);
	}

	init {
		// ensure that the server will be booted before running any snippets
		// do not require an explicit server or preload snippet to be present.
		super.init;
		before = before add: Snippet("server", "", PathName(""));
	}
}

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
		code.postln.interpret +> playerName;
	}

	init {
		super.init;
		playerName = pathName.fileNameWithoutExtension.asSymbol;
	}
	
}