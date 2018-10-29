/* 29 Jul 2018 14:02
Return path of the home directory of sc-hacks library.
In future possibly also perform other global management tasks.
*/

Hacks {

	*initClass {
		StartUp add: {
			this.gui;
		}
		
	}
	*homedir {
		^PathName(this.filenameSymbol.asString).pathOnly;
	}

	*gui {
		this.br_.v(
			{ SnippetList.gui }.button("Snippet List"),
			{ PlayerSnippetList.gui }.button("Player Snippet List"),
			{ PlayerGui() }.button("Player Gui"),
			{ OSCRecorder.gui }.button("OSC recorder"),
			{ ServerConfig.gui }.button("Configure Server"),
			[
				["Boot Server", Color.black, Color.green], { Server.default.boot },
				["Quit Server", Color.white, Color.red], { Server.default.quit}
			].button.addServerNotifier
		);
	}
}