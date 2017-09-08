/*
Using onObjectClosed method for actions that need to be done when the server boots.

Here are some tests to see if and how this works.   6 Jul 2017 22:58

*/
//: Step 1: When server tree inits, remove a buffer from the registry.
ServerTree add: { | server |
	server changed: \treeInited;
}
//:
Registry (currentEnvironment, \audiobus, \out, { Bus.audio; });
//:
Registry (currentEnvironment, \audiobus, \out, { Bus.audio; })
.addNotifier (Server.default, \treeInited, { | notification |
	notification.listener.objectClosed;
});
//:
Registry.at (currentEnvironment, \audiobus, \out);
//:
Server.default.reboot;

//: ================================================================
// Step 2: When server tree inits, replace old buffer with newly allocated one.
//: ================================================================
ServerTree add: { | server |
	server changed: \treeInited;
}
//:
Registry (currentEnvironment, \audiobus, \out, { Bus.audio; });
//:
var func;
ServerTree add: { | server |
	server changed: \treeInited;
};
func = { | argWriter, argReader, numChans = 1, argWriterParam = \out, argReaderParam = \in |
	var bus, server;
	server = argReader [\target].asTarget.server;
	bus = Registry.at (argReader, \audiobus, argReaderParam);
	bus !? { bus.objectClosed;
		postf ("I just removed this bus: %, %\n", bus, bus.identityHash);
	};
	bus = Registry.put (argReader, \audiobus, argReaderParam, Bus.audio (server, numChans));
	postf ("I just registered this bus: %, %\n", bus, bus.identityHash);
	bus.addNotifier (server, \treeInited, {
		func.(argWriter, argReader, numChans, argWriterParam, argReaderParam)
	});
	Registry.put (argWriter, \audiobus, argWriterParam, bus);
	argWriter [argWriterParam] = bus.index;
	argReader [argReaderParam] = bus.index;
};
func.(nil.asEnvironment, \reader.asEnvironment);
//:
Registry.at (currentEnvironment, \audiobus, \in);
//:
Server.default.reboot;
//:
currentEnvironment;
nil.asEnvironment;

//: ================================================================
// Step 3: Test new class: (/not ServerTreeActions) -> Servers
// ================================================================
//: Initial test:
Servers.default addDependant: { | ... b | b.postln; "tree inited".postln };
Servers.default.server.reboot;
//:
var func;
func = { | argWriter, argReader, numChans = 1, argWriterParam = \out, argReaderParam = \in |
	var bus, server;
	server = argReader [\target].asTarget.server;
	bus = Registry.at (argReader, \audiobus, argReaderParam);
	bus !? { bus.objectClosed;
		postf ("I just removed this bus: %, %\n", bus, bus.identityHash);
	};
	bus = Registry.put (argReader, \audiobus, argReaderParam, Bus.audio (server, numChans));
	postf ("I just registered this bus: %, %\n", bus, bus.identityHash);
	bus.addNotifier (ServerTreeActions.default, \initTree, {
		func.(argWriter, argReader, numChans, argWriterParam, argReaderParam)
	});
	Registry.put (argWriter, \audiobus, argWriterParam, bus);
	argWriter [argWriterParam] = bus.index;
	argReader [argReaderParam] = bus.index;
};
func.(nil.asEnvironment, \reader.asEnvironment);
//:
ServerTreeActions.default.server.reboot;

