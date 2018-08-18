/* 19 Jul 2018 17:30
Create a horizontal slider with label and number box, which controls a parameter
of a player in an environment by setting the environment variable.
Return a HLayout that can be used when building a GUI through an array of Layout elements.

Additional utilities and shortcuts: v, h, watch, close.
*/

+ Symbol {
	// symbol names the parameter.
	// controlspec and envir are optional, defaulting to this.asSpec and
	// current environment.
	// Envir must be either nil or a symbol.
	close { | key = \default |
		var window;
		window = Library.at(\windows, this, key);
		window !? { {window.close}.defer }
	}

	watch { | key, action |
		// perform action when key is set in envir named by symbol
		this.e.addNotifier(this.e, key, action);
	}
	
	slider { | controlspec, envir |
		// var mappedValue;
		controlspec = (controlspec ? this).asSpec;
		if (envir.isNil) {
			envir = currentEnvironment;
		}{
			envir = envir.e;
		};
		/* The parameter set action is taken from SimpleNumber:setParameter:
			envir.put(this, controlspec.map(me.value))
		*/
		// hack to push currently stored value of parameter to widgets:
		{
			envir.changed(this, envir[this]);
		}.defer(0.1);
		// Used as component in VLayout: 
		^HLayout(
			StaticText().string_(this.asString),
			Slider()
			.orientation_(\horizontal)
			.action_({ | me |
				envir.put(this, controlspec.map(me.value ? 0));
			})
			.addNotifier(envir, this, { | value, notification |
				{ notification.listener.value = controlspec.unmap(value ? 0) }.defer;
			}),
			NumberBox()
			.maxWidth_(80)
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
	

	// Shortcuts for VLayout and Hlayout
	v { | ... items |
		this.prLayout(items, VLayout);
	}

	h { | ... items |
		this.prLayout(items, HLayout);
	}

	prLayout { | items, layoutClass |
		// helper method for v and h methods
		{
			this.close;
			0.1.wait;
			this.window({ | w |
				w.layout = layoutClass.new(
					*items
				);
				w.bounds = w.bounds.height_(items.size * 20);
			});
		}.fork(AppClock);	
	}
}

/* // Prototype:


{ SinOsc.ar(\freq.kr(400), 0, 0.1) } +> \test;
//:
\test.window({ | w |
	w.layout = VLayout(
		HLayout(
			StaticText().string_("freq"),
			Slider()
			.orientation_(\horizontal)
			.action_({ | me |
				\test.e.put(\freq, \freq.asSpec.map(me.value))
			})
			.addNotifier(\test.e, \freq, { | freq, notification |
				notification.listener.value = \freq.asSpec.unmap (freq);
			}),
			NumberBox()
			.action_({ | me |
				\test.e.put(\freq, me.value)
			})
			.addNotifier(\test.e, \freq, { | freq, notification |
				notification.listener.value = freq;
			})
		)
	)}
)
//:
*/

/*

+ SimpleNumber {
	// if Symbol <+ SimpleNumber, then set symbol as parameter in envir to number.
	setParameter { | paramName, envir |	
		^(if(envir.isNil) { currentEnvironment } { envir.e }).put(paramName, this);
	}
}

*/

		/*
	<+ { | argument, envir |
		// argument interprets this differently according to class
		// See file ArgSetParameter.sc
		argument.setParameter(this, envir);
	}
		*/
		// 
		// argument.setParameter(this, envir);
