/*  3 Sep 2017 15:09
Add modification support to playing EventPatterns through their player: EventStreamPlayer.
*/

+ EventStreamPlayer {
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