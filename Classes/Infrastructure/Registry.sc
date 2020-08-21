/* 
Access an object in Library under a path. 
If no object exists under that path, then create it using a function passed as argument. 
*/

Registry {

	*add { | ... pathAndObject |
		^this.new(*(pathAndObject[0..pathAndObject.size-2]
			add: { List() })) add: pathAndObject.last;
	}

	// Add strings as strings (not individual chars:)
	/*
	*arrayAdd { | ... pathAndObject |
		^this.new(*(pathAndObject[0..pathAndObject.size-2]
			add: { [] })) add: pathAndObject.last;
	}
	*/

	*new { | ... pathAndFunc |
		var path, makeFunc, instance;
		makeFunc = pathAndFunc.last;
		path = pathAndFunc[0..pathAndFunc.size-2];
		instance = Library.global.atPath(path);
		if (instance.isNil) {
			instance = makeFunc.value;
			Library.global.putAtPath(path, instance);
			instance.onObjectClosed(this, {
				this.remove(*path)
			});
		};
		^instance;
	}

	*doIfFound { | ... pathAndFunc |
		var path, action, instance;
		action = pathAndFunc.last;
		path = pathAndFunc[0..pathAndFunc.size-2];
		instance = Library.global.atPath(path);
		if (instance.isNil) {
			// postf("No instance found at path: %\n", path);
		} { action.(instance) };
		^instance;
	}

	*remove { | ... path |
		Library.global.removeEmptyAt(*path);
	}

	*allAt { | ... path |
		var found;
		found = Library.global.atPath(path); 
		^if (found isKindOf: Dictionary) { found.values } { found }
	}

	*at { | ... path |
		^Library.global.atPath(path);
	}

	*put { | ... path |
		var element;
		element = path.last;
		element.onObjectClosed(this, {
			this.remove(* (path [0.. path.size-2]))
		});
		Library.global.put(*path);
		^element;
	}
}

// Use Registry to add events as custom variables to any object:

+ Object {
	// Return object stored at varName, this, key, or nil if not found
	at_ { | varName, key | ^Registry.at(varName, this, key) }

	// Store object stored at varName, this, key, 
	put_ { | varName, key, object | Registry.put(varName, this, key, object) }

	// Return object stored at varName, this, key.
	// If not found, create new object with found and store it, and return it.
	get_ { | varName, key, func | ^Registry(varName, this, key, func) }

	// Run objectClosed on stored object.  This releases all Notification connections of the object,
	// And removes it from Registry at varName, this, key.
	// If no object found, then send objectClosed to nil, which has no effect.
	free_ { | varName, key, func | Registry.at(varName, this, key).objectClosed }
}