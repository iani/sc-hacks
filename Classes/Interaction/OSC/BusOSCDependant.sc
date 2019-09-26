/*

*/

BusOsc {
	// set bus value to mapped value of data from osc message
	var <name, <msg, <index, <bus, <min, <max, <oscFunc, <spec; 

	*watch { | name = \busosc ... specs |
		// create gui for watching several busses
		name.v(
			*specs.collect({ | specArray |
				// 0 bus, 1 msg, 2 index, 3 min, 4 max
				this.new(*specArray).widget;
			});
		)
	}
	*new { | name, msg, index, min, max |
		^Registry(this, name, msg, index, {
			// only create oscfunc if new osc connection is needed
			this.newCopyArgs(name, msg, index, name.bus, min, max).makeOscFunc;
		}).initSpec(min, max); // also modify specs later if needed
	}

	makeOscFunc {
		oscFunc = OSCFunc({ | msg |
			// Post for initial tests:
			/*
			postf("received %: % will set % to %\n",
				msg[0], bus, index, spec.unmap(msg[index])
			);
			*/
			var values, unmapped;
			#msg ... values = msg;
			unmapped = spec.unmap(values[index]);
			bus.set(unmapped);
			// name.postln.changed(msg.postln, unmapped.postln);
			name.changed(msg, unmapped);
		}, msg).fix;
		
	}

	initSpec { | argMin, argMax |
		// skip if no specs provided
		if (argMin.isNil or: { argMax.isNil }) { ^this };
		#min, max = [argMin, argMax].sort;
		spec = ControlSpec(min, max);
	}

	widget {
		var slider, numbox;
		^HLayout(
			StaticText().string_(name).font_(PlatformGuiDefaults.font),
			StaticText().string_(msg).font_(PlatformGuiDefaults.font),
			StaticText().string_(index.asString).font_(PlatformGuiDefaults.font),
			slider = Slider().orientation_(\horizontal)
			.minWidth_(400),
			numbox = NumberBox().font_(PlatformGuiDefaults.font)
			.decimals_(3)
			.addNotifier(name, msg.addSlashIfNeeded, { | val |
				{
					slider.value = val;
					numbox.value = val;
				}.defer;
			}),
			NumberBox().font_(PlatformGuiDefaults.font)
			.decimals_(3)
			.value_(min)
			.action_({ | me |
				this.setMin(me.value);
			}),
			NumberBox().font_(PlatformGuiDefaults.font)
			.decimals_(3)
			.value_(max)
			.action_({ | me |
				this.setMax(me.value);
			})
		)
	}

	setMin { | argMin |
		this.initSpec(argMin, max);
	}

	setMax { | argMax |
		this.initSpec(min, argMax);
	}
}

+ Symbol {
	busOsc { | msg, index, min, max |
		^BusOsc(this, msg, index, min, max);
	}
	addSlashIfNeeded {
		if (this.asString[0] === $/) {
			^this;
		}{
			^("/" ++ this).asSymbol;
		}
	}
}