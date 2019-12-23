/* set bus value to mapped value of data from osc message */

BusOsc {
	var <name, <msg, <index, <bus, <min, <max, <template, <oscFunc, <spec; 

	*watch1 { | name, oscmessage ... specs |
		/* watch several different values received from the same oscmessage.
			insert oscmessage in each element in specs.
			!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			spec format is: 
			[busname, valueindex, minval, maxval, template]
			!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			template is an integer in the case of sensestage hardware,
			can be nil or anything else for other cases.
		*/
		this.watch(name, *specs.collect({ | spec |
			spec.insert(1, oscmessage);
		}))
	}

	*watch { | name = \busosc ... specs |
		/* Set buses with mapped values received from osc msssages.
			name: Symbol identifier for storing this instance.
			specs: array of: 
			!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			spec format is: 
			[busname, oscmessage, valueindex, minval, maxval, template]
			!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			Each specs array creates one osc binding.
			busname: the name of the bus whose value will be set by osc input.
			   busname can be any symbol. A bus is created and used as needed.
			oscmessage: The osc message which will be used to set values of the bus
			valueindex: The index of the element from the data sent with the 
			   osc message.  0 = first data item, 1 = second data item etc.
			minval, maxvaL: Used to create the min/max values of the spec
			   to map incoming values to a range from 0 to 1.
			template: If not nil, then used to set argTemplate in the oscfunc.
			This is useful for mapping different values from the same message.
			e.g. [\leftx, \sensestage, 0, -0.5, 0.5, 1]
			will set bus \leftx when message [\sensestage, 1, ... ] is received,
			but: [\rightx, \sensestage, 0, -0.5, 0.5, 2]
			will set bus \rightx when message [\sensestage, 2, ... ] is received,

		*/
		// create gui for watching several busses
		name.br_(800).v(
			*specs.collect({ | specArray |
				// 0 bus, 1 msg, 2 index, 3 min, 4 max
				this.new(*specArray).widget;
			});
		)
	}
	*new { | busname, msg, index, min, max, template |
		^Registry(this, busname, msg, index, {
			// only create oscfunc if new osc connection is needed
			this.newCopyArgs(busname, msg, index, busname.bus, min, max, template)
		}).makeOscFunc.initSpec(min, max); // also modify specs later if needed
	}

	makeOscFunc {
		oscFunc !? {
			oscFunc.free;
		};
		oscFunc = OSCFunc({ | msg |
			// Post for initial tests:
			/*
			postf("received %: % will set % to %\n",
				msg[0], bus, index, spec.unmap(msg[index])
			);
			*/
			var values, unmapped;
			#msg ... values = msg;
			// postf("RECEIved this: %, mapped: %, unmapped %\n", msg, values[index], spec.unmap(values[index]));
			unmapped = spec.unmap(values[index]);
			
			bus.set(unmapped);
			// name.postln.changed(msg.postln, unmapped.postln);
			name.changed(msg, unmapped);
		}, msg, argTemplate: template.asArray).fix;
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
			.minWidth_(200),
			numbox = NumberBox()
			.maxWidth_(80)
			.font_(PlatformGuiDefaults.font)
			.decimals_(3)
			.addNotifier(name, msg.addSlashIfNeeded, { | val |
				{
					slider.value = val;
					numbox.value = val;
				}.defer;
			}),
			NumberBox()
			.maxWidth_(80)
			.font_(PlatformGuiDefaults.font)
			.decimals_(3)
			.value_(min)
			.action_({ | me |
				this.setMin(me.value);
			}),
			NumberBox()
			.maxWidth_(80)
			.font_(PlatformGuiDefaults.font)
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