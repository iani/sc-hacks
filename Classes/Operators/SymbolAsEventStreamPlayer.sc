+ Symbol {
    asEventStreamPlayer { | envir, event |
		if (event.isNil) { // only create if event was provided
			^Registry.at (envir, \ePlayers, this); 
		}{
			^Registry.put(envir, \ePlayers, this, EventPattern (event).play);
		}
	}
}