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
	window { | initFunc, key = \default, rect |
		rect ?? {
			rect = this.bounds(key)
		};
		^Registry(\windows, this, key, {
			var window;
			// when window closes it removes itself from registry.
			// see Notification:onObjectClosed, and Regsitry class.
			window = Window(this.asString, rect, false);
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

	bounds_ { | rect, key = \default |
		Registry.put(\windowRects, this, key, rect);
	}

	// defers are done here, because Rect.tl... calls need to return
	tl_ { | width, height = 200, key = \default |
		{ this.bounds_(Rect.tl(GuiDefaults.width, height), key) }.defer;
	}

	tr_ { | width, height = 200, key = \default |
		{ this.bounds_(Rect.tr(GuiDefaults.width, height), key) }.defer;
	}

	bl_ { | width, height = 200, key = \default |
		{ this.bounds_(Rect.bl(GuiDefaults.width, height), key) }.defer;
	}

	br_ { | width, height = 200, key = \default |
		{ this.bounds_(Rect.br(GuiDefaults.width, height), key) }.defer;
	}

	bounds { | key = \default |
		^Registry(\windowRects, this, key, {
			GuiDefaults.bounds
		} )
	}

	// shortcut for shifting position of window
	wshift { | x = 0, y = 0 |
		{
			this.window.bounds = this.window.bounds.moveBy(x, y);
		}.defer;
	}
	// Shortcuts for VLayout and Hlayout
	v { | ... items |
		this.prLayout(items, VLayout);
	}

	h { | ... items |
		this.prLayout(items, HLayout);
	}

	listView {
		// experimental  2 Dec 2020 07:42
		// single list view
		this.prLayout(
			[ListModel.named(this).listView],
			VLayout,
			400
		)
	}

	doubleListView { | layout |
		// experimental  2 Dec 2020 07:42
		// double list view
		this.prLayout(
			['----------', '////////////'] collect: { | i |
				ListView()
				.items_(i.asArray)
				.font_(GuiDefaults.font)
			} ,
			layout ? VLayout,
			400
		)
	}
	
	prLayout { | items, layoutClass, height |
		// helper method for v and h methods
		// items.postln;
		{
			height ?? {
				height = items.size * GuiDefaults.lineHeight + 5 max: 50
			};
			this.close;
			0.1.wait;
			this.window({ | w |
				w.layout = layoutClass.new(*items);
				// this.bounds.postln;
				w.bounds = w.bounds.height_(height);
				// EXPERIMENTAL
				w.view.keyDownAction_({ | win, key |
					this.changed(\keydown, key);
				});
			});
		}.fork(AppClock);
	}

	close { | key = \default |
		var window;
		window = Library.at(\windows, this, key);
		window !? { {window.close}.defer }
	}	
}



+ Window {
	v { | ... items |
		this.layout = VLayout(*items);
	}
}