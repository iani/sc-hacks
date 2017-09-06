/*  3 Sep 2017 15:09
Add modification support to playing EventPatterns through their player: EventStreamPlayer.
*/

+ EventStreamPlayer {
		clear {
		// empty process of PatternPlayer
			// remove all keys except for target nodes
			var prEvent;
			prEvent = originalStream.event;
			postf("clearing event: %\n", prEvent);
			prEvent keysDo: { | key |
				postf("key is: %\n", key);
				if (key !== \target) { prEvent[key] = nil }
			}
	}

	addKeyValue { | key, object | stream.event [key] = object.asStream }

	addEvent { | argEvent |
		var prEvent;
		prEvent = originalStream.event;
		argEvent keysValuesDo: { | key, value |
			prEvent [key] = value.asStream;
		}
	}

	setEvent { | argEvent |
		var prEvent;
		prEvent = originalStream.event;
		prEvent.clear;
		argEvent keysValuesDo: { | key, value |
			prEvent [key] = value.asStream;
		}
	}
 }