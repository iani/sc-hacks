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
			/* Registry(\windowRects, this, key, {
				Rect(0, 0, 400, 400)}
			);
			*/
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

	list {
		// experimental  2 Dec 2020 07:42
		// single list view
		this.prLayout(
			[ListView()
				.items_(["---------------", "blahblah"])
				.font_(GuiDefaults.font)
				.action_({ | me |
					postf("% value selected %, item: %\n", me, me.value, me.item);
				})
				.keyDownAction_({ | me, key |
					// postf("%, pressed: %\n", me, key);
					if (key === Char.ret ) { "Return was pressed".postln }
				})
			],
			VLayout,
			400
		)
		
	}

	doubleList { | layout |
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

+ Symbol {
	sliders { | ... specs |
		// 26 Nov 2020 14:47
		/*
		Create a v window with sliders from your specs,
			and bound to the environment of yourself.

		Ensure that your widgets will address your environment.
			specs have the form:
			[paramname, spec, envir, displayname]
			paramname names the parameter to be controlled
			spec is something responding to asSpec - for mapping the input
			envir and displayname are optional:
			envir: name of envir which the widget addresses,
			defaults to this.
			displayname: name displayed for the slided widget.
			defaults to paramname.
		// Under development
		*/
		// experimental: provide keydown bindings
		this.addDependant({ | who, what, key |
			if (who === this and: {
				what === \keydown and: {
					key === Char.space
				}
			}) {
				this.toggle;
			}
		});
		//provide eventual missing default to specs
		specs = specs.collect({ | spec |
			spec = (spec.asArray ++ [nil, nil, nil])[..3];
			spec[1] ?? { spec[1] = spec[0] }; // paramname -> spec
			spec[2] ?? { spec[2] = this }; // this -> envir
			spec[3] ?? { spec[3] = spec[0] }; // paramname -> displayname
		});
		/*
		([this.playButton] ++ specs.collect({ | spec |
			spec[0].slider(spec[1], spec[2], spec[3]);
		}))
		*/
		{ this.v(
			*([this.playButton] ++ specs.collect({ | spec |
				spec[0].slider(spec[1], spec[2], spec[3]);
			}));
		)
		}.defer;
	}

	playButton {
		// also sync player status:
		var player;
		player = this.p;
		^HLayout(
			StaticText()
			.font_(GuiDefaults.font)
			.string_(this.asString),
			Button()
			.font_(GuiDefaults.font)
			.states_([["Start", nil, Color.green], ["Stop", nil, Color.red]])
			.action_({ | me |
				this.perform([\stop, \play][me.value]);
			})
			.value_(this.isPlaying.binaryValue)
			.addNotifier(player, \started, { | n |
				{ n.listener.value = 1; }.defer;
			})
			.addNotifier(player, \stopped, { | n |
				{ n.listener.value = 0; }.defer;
			});
		);
	}

	slider { | controlspec, envir, name |
		// shortcut for slider displaying/setting a parameter in an environment
		// this = paramname. name = name to display (default: this).
		controlspec = (controlspec ? this).asSpec;
		if (envir.isNil) {
			envir = currentEnvironment;
		}{
			envir = envir.e;
		};
		// The parameter set action is taken from SimpleNumber:setParameter:
		//	envir.put(this, controlspec.map(me.value))
		// hack to push currently stored value of parameter to widgets:
		{
			envir.changed(this, envir[this]);
		}.defer(0.1);
		// Used as component in VLayout:
		^HLayout(
			StaticText()
			.font_(GuiDefaults.font.postln)
			.string_(name ?? { this.asString }),
			Slider()
			.orientation_(\horizontal)
			.action_({ | me |
				envir.put(this, controlspec.map(me.value ? 0));
			})
			.addNotifier(envir, this, { | value, notification |
				{ notification.listener.value = controlspec.unmap(value ? 0) }.defer;
			}),
			NumberBox()
			.font_(GuiDefaults.font)
			.decimals_(5)
			.maxWidth_(180)
			.clipLo_(controlspec.minval)
			.clipHi_(controlspec.maxval)
			// .decimals_(10)
			.action_({ | me |
				envir.put(this, controlspec constrain: (me.value));
			})
			.addNotifier(envir, this, { | value, notification |
				{ notification.listener.value = value ? 0; }.defer;
			})
		)
	}
	timer { | name |
		// shortcut for time display widget
		^HLayout(
			StaticText()
			.font_(GuiDefaults.font)
			.string_(name ?? { this.asString }),
			NumberBox()
			.font_(GuiDefaults.font)
			.decimals_(0)
			.addNotifier(this, \time, { | mins, secs, n |
				n.listener.value = mins;
			}),
			NumberBox()
			.font_(GuiDefaults.font)
			.decimals_(2)
			.addNotifier(this, \time, { | mins, secs, n |
				n.listener.value = secs;
			})
		)
	}
}

+ Window {
	v { | ... items |
		this.layout = VLayout(*items);
	}
}