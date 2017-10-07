// 27 Sep 2017 13:59
/*  Any object can create a unique, re-opening window for itself.
	To open multiple objects for the same object, use keys other than \default
	as argument to the method call.
	
	Similar methods can be used to add instance-variable-like data attachment points to any object.
	For example, the window method uses Registry(\windowRects ...) to store the bounds associated with a window
	of an object in additional pseudo-variable "windowRects".

	Note: The Object:window method initializes the window so that it saves its bounds when 
	the user changes these with the mouse.
	The saved bounds can be used when re-creating a closed window, in order 
	to restore the windows bounds when opening to the last position it was before closing.
*/

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
			initFunc.(window, this);
			window;
		}).front;	
	}
}
