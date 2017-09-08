

+ Event {
	eplay { |  name = \ePlayer, envir |
		var previousPattern, newPattern;
		envir = envir.asEnvironment;
		previousPattern = name.asEventStreamPlayer (envir);
		previousPattern !? {
			previousPattern.stop;
		};
		this [\envir] = envir;
		this [\type] = \envEvent;
		newPattern = name.asEventStreamPlayer (envir, this);
		this.addNotifier (newPattern, \stopped, {
			newPattern.objectClosed;
		});
		this.addNotifier (newPattern, \userStopped, {
			newPattern.objectClosed;
		});		
		^newPattern;
	}
}