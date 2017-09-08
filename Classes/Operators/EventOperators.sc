/* // 25 Jun 2017 00:39

@> play

@>+ addEvent

@>! setEvent

@>@ addKey

*/

+ Event {
	@> { | name, envir | ^this.eplay (name, envir) }
	@>+ { | name, envir | ^name.asEventStreamPlayer(envir.asEnvironment).addEvent (this) }
	@>! { | name, envir | ^name.asEventStreamPlayer(envir.asEnvironment).setEvent (this) }
	// @>@ { | name, envir | ^name.asEventStreamPlayer.addKey (this, envir) }
	<@ { | key, ownLabel = \eventStream |
		var eventStream;
		eventStream = EventPattern (this).asStream;
		ownLabel.addNotifier (currentEnvironment, key, {
			eventStream.next.play;
		})
	}
	
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

+ EventPattern {
	*initClass {
		StartUp add: {
			//: An event type that pushes values to an environment:
			Event.parentEvents.default.eventTypes [\envEvent] = #{ | server |
				
				var envir;
				~freq = ~detunedFreq.value;
				~amp = ~amp.value;
				~sustain = ~sustain.value;
				envir = ~envir;
				~getmsgfunc.valueEnvir.valueEnvir pairsDo: { | key, val | envir [key] = val };
				currentEnvironment pairsDo: { | key, val |
				 	if (key != \envir) { envir [key] = val };
				};
				envir.patterns do: { | p | p.next.play };
			};
		}
	}
}
