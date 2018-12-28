// Testing subclass

PlayerSnippetList : SnippetList {
	*windowBounds { ^Rect(150, 50, 1000, 700) }
	
	*initClass {
		StartUp add: {
			//	this.gui;
			ServerQuit add: {
				// prepare to load before and/or head snippets at next run
				this.snippetOnServer = 0;
			};
		}
	}
	
	*folderPath {
		^"../../".resolveRelative ++ "Players/";
		// ^PathName(this.filenameSymbol.asString).pathOnly ++ "Players/"
	}

	*utilitiesMenu {
		^ActionMenu(
			"--- UTILITIES MENU ---",
			"Browse Classes and Methods", { Class.extensionsGui },
			"Open Buffer GUI", { BufferGUI() },
			"Recompile", { thisProcess.platform.recompile; },
			"Snippet Gui", { SnippetList.gui() },
			"Player Gui", { PlayerGui() },
			"Meter", { ServerMeter(Server.default) },
			"Scope", { Server.default.scope },
			"Frequency Scope", { Server.default.freqscope }
		)
	}

	*runTailSnippets {
		// this.snippets.runSnippet(this.snippets.tail)
		"You should not run all snippets on the same player at the same time".postln;
		"Please select one snippet from the snippet list to run it.".postln;
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

	*runSnippetSelection {
		//  PlayerSnippetList only runs snippets with index > 0
		if (this.snippetIndex == 0) {
			"PlayerSnippetList never runs the part before the first snippet".postln;
		}{
			this.snippets.runSnippet([this.snippets.all[this.snippetIndex]]);
		}
		
	}
}

