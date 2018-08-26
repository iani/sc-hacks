// Testing subclass

PlayerSnippetList : SnippetList {
	*windowBounds { ^Rect(350, 150, 1000, 700) }
	*initClass {
		StartUp add: {
			this.gui;
			ServerQuit add: {
				// prepare to load before and/or head snippets at next run
				this.snippetOnServer = 0;
			};
		}
	}

	*folderPath {
		^PathName(this.filenameSymbol.asString).pathOnly ++ "Players/"
	}

	*utilitiesMenu {
		^ActionMenu(
			"--- UTILITIES MENU ---",
			"Browse Classes and Methods", { Class.extensionsGui },
			"Recompile", { thisProcess.platform.recompile; },
			"Snippet Gui", { SnippetList.gui() },
			"Player Gui", { PlayerGui() },
			"Meter", { ServerMeter(Server.default) },
			"Scope", { Server.default.scope },
			"Frequency Scope", { Server.default.freqscope }
		)
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

