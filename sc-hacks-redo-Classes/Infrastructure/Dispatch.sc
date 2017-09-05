/* 10 Aug 2017 12:31
Acts as dispatcher for EnvironmentRedirect put, in Pevent.
Uses dispatcher variable as dictionary to match actions to the class of the object that was set. 
See Nevent:new for use.
*/

Dispatch {
	var <pevent, <dispatcher;
	value { | key, obj |
		pevent.changed(
			*(dispatcher[obj.class] ?? { [\unknown, key, obj]}).value(key, obj)
		)
	}	
}