/* 10 Aug 2017 12:31
Acts as dispatcher for EnvironmentRedirect put, in Pevent.
*/

Dispatch {
	var <pevent, <dispatcher;
	value { | key, obj |
		pevent.changed(
			*(dispatcher[obj.class] ?? { [\unknown, key, obj]}).value(obj)
		)
	}	
}