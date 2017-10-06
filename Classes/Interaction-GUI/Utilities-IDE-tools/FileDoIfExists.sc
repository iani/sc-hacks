+ String {
	doIfExists { | yesAction, noAction |
		^File.doIfExists(this, yesAction, noAction)
	}
}

+ File {
	*doIfExists { | path, yesAction, noAction |
		if (this exists: path) {
			^yesAction.(path)
		}{
			^noAction.(path);
		}
	}	
}