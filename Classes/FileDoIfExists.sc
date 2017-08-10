+ File {
	*doIfExists { | path, yesAction, noAction |
		if (this exists: path) {
			yesAction.(path)
		}{
			noAction.(path);
		}
	}
	
}