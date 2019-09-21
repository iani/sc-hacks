//  9 Sep 2019 14:17
/*
Hack to run the startup script with a keyboard command from EMACS.
*/

Startup : Singleton {
	run {
		var filename;
		filename = format("%d", this.class.filenameSymbol);
		postf("running: %\n", filename);
		filename.load;
	}
	
}