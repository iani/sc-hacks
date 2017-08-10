/* 10 Aug 2017 12:31
Acts as dispatcher for EnvironmentRedirect put, in Pevent.
*/

Dispatcher : Event {
	var pevent;
	value { | key, obj |
		pevent.changed(
			*(this[obj.class] ?? { [\unknown, obj]}).(obj)
		)
	}
	
}