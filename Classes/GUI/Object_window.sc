// 27 Sep 2017 13:59
// Any object can create a unique, re-opening window for itself.
// To open multiple objects for the same object, add a name other than \default
// as argument to the method call.

+ Object {
	window { | initFunc, key = \default |
		var rect;
		rect = Registry(\windowRects, this, key, {
			Rect(0, 0, 400, 400)}
		);
		^Registry(\windows, this, key, {
			var window;
			// when window closes it removes itself from registry.
			// see Notification:onObjectClosed, and Regsitry class.
			window = Window(this.asString, rect);
			// save window rect for use when re-opening:
			window.view.mouseLeaveAction_({ | topview |
				Registry.put(\windowRects, this, key, topview.findWindow.bounds)
			});
			window.view.mouseUpAction_({ | topview |
				Registry.put(\windowRects, this, key, topview.findWindow.bounds);
			});
			window;
		}).front;	
	}
}
