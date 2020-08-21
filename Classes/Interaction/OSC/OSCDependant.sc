/* 17 Aug 2018 15:12
Encapsulate function to act as dependant in notification
*/

OSCDependant {
	var <message, <index, <inspec, <outspec;
	var <envir, <paramName;

	*initClass {
		StartUp add: {
			thisProcess addOSCRecvFunc: { | msg, time, addr, recvPort |
				OSCFunc.changed(msg[0], msg[1..], time, addr, recvPort);
			};
		}		
	}

	*new { | message, index, inspec, outspec |
		^this.newCopyArgs(message, index, inspec.asSpec, outspec.asSpec);
	}

	setParameter { | argParamName, argEnvir |
		// [this, \setParameter, paramName, envir].postln;
		envir = argEnvir;
		paramName = argParamName;
		envir.addNotifier(OSCFunc, message,
			OSCDependantDict(envir, message, paramName, this);
		);
	}
	
	setParam { | msg |
		// envir.postln;
		envir.put(paramName, outspec.map(inspec.unmap(msg[index])));
		// envir.postln;
	}	
}

OSCDependantDict {
	var <dict, <cache;

	*new { | envir, message, paramName, oscDependant |
		^Registry(envir, \oscdependants, message, {
			this.newCopyArgs(IdentityDictionary())
		}).addOscDependant(paramName, oscDependant);
	}

	addOscDependant { | paramName, oscDependant |
		dict[paramName] = oscDependant;
		cache = dict.values.asArray;
		// cache.postln;
	}
	
	valueArray { | msg |
		// [this, \valuearray, msg].postln;
		cache do: _.setParam(msg[0]);
	}
}

NullSpec {
	*initClass {
		StartUp add: {
			ControlSpec.specs[\nil] = NullSpec;
		}
	}

	*map { | number | ^number }
	*unmap { | number | ^number }
}

+ Symbol {
	osc { | index = 0, inspec = \nil, outspec = \nil |
		^OSCDependant(this, index, inspec, outspec)
	}

	/*
		
	oscd { paramName |
		// access osc dependant, for bus
		//	^
	}
	*/
	
}

+ Function {
	// asSpec, map: permit arbitrary function as inspec in OSCDependant
	asSpec { ^this }

	map { | number |
		/*  // TODO:
			// note - this has been defined differently in file Operators.sc
			// need to find out which code is the one to keep
	*/
		^this.value(number)
	}
}
