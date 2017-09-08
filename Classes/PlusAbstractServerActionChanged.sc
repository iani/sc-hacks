// 15 Jul 2017 12:04

+ AbstractServerAction {
	*run { arg server;
		var selector = this.functionSelector;
		// selector.postln;
		(server ?? { Server.default }).changed (selector);
		this.performFunction(server, { arg obj; obj.perform(selector, server) });
	}
}