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
			envir = envir.ev;
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
	//  3 Dec 2020 14:19 NOT SURE THIS IS NEEDED ANY MORE?
	watch { | key, action |
		// perform action when key is set in envir named by symbol
		this.ev.addNotifier(this.ev, key, action);
	}
}