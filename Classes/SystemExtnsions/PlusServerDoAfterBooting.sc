+ Object {
	doAfterBooting { | afterBootAction, alreadyRunningAction, server |
		server ?? { server = Server.default };
		alreadyRunningAction ?? { alreadyRunningAction = afterBootAction };
		if (server.serverRunning) {
			alreadyRunningAction.value;
		}{
			this.addNotifierOneShot(server, \notified, afterBootAction);
			server.boot;
		}
	}
}