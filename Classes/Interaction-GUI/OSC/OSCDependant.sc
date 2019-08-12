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
		envir = argEnvir;
		paramName = argParamName;
		envir.addNotifier(OSCFunc, message,
			OSCDependantDict(envir, message, paramName, this);
		);
	}
	
	setParam { | msg |
		// vary behavior according to paramName class.
		paramName.setParam(outspec.map(inspec.unmap(msg[index])), envir);
		// (OLD:) This is used if paramName is a symbol:
		// envir.put(paramName, outspec.map(inspec.unmap(msg[index])));
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
	}
	
	valueArray { | msg |
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

	setParam { | value, envir |
		envir.put(this, value);
	}
}

+ Bus {
	setParam { | value |
		this.set(value);
	}
}

+ Function {
	// asSpec, map: permit arbitrary function as inspec in OSCDependant
	asSpec { ^this }
	map { | number |
		^this.value(number)
	}
}

