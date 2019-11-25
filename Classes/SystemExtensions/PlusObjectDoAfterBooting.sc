/*
Experimental. Added Aug 12 2019.
Evaluate usage cases and compare to doWhenBooted, waitForBoot.
*/
+ Object {
	doAfterBooting { | afterBootAction, alreadyRunningAction, server |
		server ?? { server = Server.default };
		alreadyRunningAction ?? { alreadyRunningAction = afterBootAction };
		if (server.serverRunning) {
			alreadyRunningAction.value;
		}{  // Defer prevents action from causing Clock conflict when updating views:  
			this.addNotifierOneShot(server, \notified, { afterBootAction.defer });
			server.boot;
		}
	}

	*readFromClassPath { | filename |
		// this.filenameSymbol.postln;
		var string = "";
		(PathName(this.filenameSymbol.asString).pathOnly +/+ filename).doIfExists(
			{ | path |
				string = File.readAllString(path);
			},
			{ | path |
				postf("Could not find file: %\n%\n", path);
			}
		);
		^string;
	}
}