//: 18 Jan 2021 18:40 Redo of NEvent as NamedSingleton.
/* 
Experimental.
To be used with Player2.
*/

Event2 : NamedSingleton {
	var <event;

	prInit {
		event = EnvironmentRedirect();
		event.dispatch = Dispatch.newCopyArgs(
			this, 
			() putPairs: [
				Integer, { | key, object |
					[key, object]
				},
				Float, { | key, object |
					[key, object]
				},
				Bus, { | key, object |
					[\mapBus, key, object]
				}
			]
		)
	}
	
	push {
		if (currentEnvironment === this) {} {
			// let listeners switch listening from old to new environment:
			Event2.changed(\oldEnvir, currentEnvironment); // GUIs remove old envir
			super.push;
			Event2.changed(\newEnvir, this); // dependent GUIs start listening to
			                                 // new envir updates
		}
	}
}
