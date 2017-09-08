
+ Slider {
	connectEnvir { | param, envir, spec |
		envir = envir.asEnvironment;
		spec = (spec ? param).asSpec;
		this.action = { | me |
			var value;
			value = spec map: me.value;
			envir [param] = value;
			envir.changed (param, value);
		};
		this.addNotifier (envir, param, { | val |
			// defer: allow updates from SystemClock processes
			{ this.value = spec unmap: val }.defer; 
		});
		if (envir [param].notNil) {
			this.value = spec unmap: envir [param];
		};
		/* // this has uwanted side effect of setting amp to 0
		{
			this.value = spec unmap: spec.default;
			// envir [param] = spec.default;
		};
		*/
	}
}

+ View {
	connectEnvir { | param, envir = \envir |
		envir = envir.asEnvironment;
		this.action = { | me |
			var value;
			value = me.value;
			envir [param] = value;
			envir.changed (param, value);
		};
		this.addNotifier (envir, param, { | val |
			{ this.value = val }.defer; // defer: allow updates from SystemClock processes
		}
		);
		if (envir [param].notNil) {
			this.value = envir [param];
		}
	}
}

+ Node {
	connectEnvir { | param, envir = \envir |
		this.addNotifier (envir.asEnvironment, param, { | val |
			this.set (param, val)
		});
		if (envir [param].notNil) {
			if (this.isPlaying) {
				this.set (param, envir [param])
			}
			// todo: remove this when proper envir init for synth is done:
			{
				this.onStart (param, {
					this.set (param, envir [param]);
				});
			};
		};
		this.onEnd ({ this.objectClosed });
	}

	connectParams { | envir = \envir ... params |
		envir = envir.asEnvironment;
		params do: { | param |
			this.addNotifier (envir, param, { | val |
				this.set (param, val)
			});
			if (envir [param].notNil) {
				if (this.isPlaying) {
					this.set (param, envir [param])
				}
				// todo: remove this when proper envir init for synth is done:
				{
					this.onStart (param, {
						this.set (param, envir [param]);
					});
				};
			};
			this.onEnd ({ this.objectClosed });
		}
	}
}

+ Symbol {

	spec { | spec |
		^Registry.at(\specs, this)
	}

	spec_ { | spec |
		^Registry.put(\specs, this, spec)
	}
	/* TODO: add envir parameter to initialize the synth properly with all
		required param args plus server, addAction. (like Event:play / note style).
		
	*/
	synth { | func, envir |
		envir = envir.asEnvironment;
		func = func ?? {
			{ | freq = 440 |
				SinOsc.ar (freq, 0, 0.1);
			}
		};
		Registry.doIfFound (\synths, this, { | found |
			found.objectClosed; // this should both remove from registry and remove Notifiers
			found.free;
			// alternatively:
			// found.release (0.5);
		});
		//                      func eplay: envir
		^Registry (\synths, this, { func.eplay (envir) });
	}
	/*
		Possibly:  also - or alternatives: 
		String:synth -> create synth with synthdef name from string
		Function:synth -> creat synth with func by playing it
	*/
}

