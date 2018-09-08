+ Object {
	doAfterBooting { | afterBootAction, alreadyRunningAction, server |
		server ?? { server = Server.default };
		alreadyRunningAction ?? { alreadyRunningAction = afterBootAction };
		if (server.serverRunning) {
			alreadyRunningAction.value;
		}{  // Defer prevents action from causing Clock conflict when updating views:  
			this.addNotifierOneShot(server, \notified, { afterBootAction.defer });
			server.boot;
		}
	}
}