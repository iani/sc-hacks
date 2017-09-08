/*
1. Provide arguments for playing a function from values found in an environment.
2. connect all congtrol names in the function's arguments to 
3. Free all notifications from the synth when it stops playing. 

*/
+ Function {
	eplay { | name = \synth, envir |
		var synth;
		envir = envir.asEnvironment;
		Registry.doIfFound (envir, \synths, name, { | oldSynth |
			oldSynth.objectClosed; // prevent removal of successor on end
			oldSynth.release(envir [\releaseTime] ? 0.02);
		});
		envir use: {
			var argNames, args;
			argNames = this.def.argNames;
			/* assume that the func uses a gate argument
				Later devise a way to get all the actual ontrols from the syn~thdef after it has loaded
			*/
			args = (argNames ++ ['gate']).collect ({ | name |
				[name, envir[name]]
			}).select ({ | pair |
				pair [1].notNil;
			});
			// arg target, outbus = 0, fadeTime = 0.02, addAction=\addToHead, args;
			// Ensure removal from Registry on end:
			synth = Registry (envir, \synths, name, {
				this.play (
					~target.asTarget, ~outbus ? 0, ~fadeTime ? 0.02,
					~addAction ? \addToHead, (args ? []).flat
				)
			});
			envir [\instrument] = synth.defName; // can be used by patterns
		~synth.onStart (this, {| myself |
				// "Synth started, so I add notifiers for updates".postln;
				argNames do: { | param |
					synth.addNotifier (envir, param, { | val |
						synth.set (param, val);
					});
					// Experimental: 
					synth.addNotifier (envir, name, { | command |
						//	command.postln;
						switch (command,
							\stop, {
								synth.objectClosed;
								synth.release (envir [\releaseTime] ? 0.02);
							},
							{ postf ("the command was: %\n", command)}
						)
					})
				};
			});
			if  (argNames.size == 0) {
				synth.onEnd (this, { synth.objectClosed;}); // in case no func args
			}
		};

		^synth;
	}
}