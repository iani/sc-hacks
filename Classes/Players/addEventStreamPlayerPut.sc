+ EventStreamPlayer {
	put { | key, value |
		originalStream.event[key] = value.asStream;
	}
}