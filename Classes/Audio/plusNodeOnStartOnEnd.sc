+ Node {
	onStart { | listener, action |
		NodeWatcher.register(this);
		//		this.isPlaying = true; // dangerous
		listener.addNotifierOneShot(this, \n_go, action);
	}

	onEnd { | listener, action |
		NodeWatcher.register(this);
		listener.addNotifierOneShot(this, \n_end, action);
		// added 12 Mar 2019 14:55: Remove all notifications
		// do this deferred to permit multiple on ends
		// Note: This is a hack, until we get a better solution for multiple actions.
		// { this.objectClosed }.defer(0.0001);
	}
}
