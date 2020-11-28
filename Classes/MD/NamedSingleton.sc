// Superclass for SenseServer and its dependants
NamedSingleton : Singleton {
	var <name;

	init { | argName |
		/* postf("% NamedSingleton.init argName: %\n",
			this, argName;
			); */
		name = argName;
		this.prInit; // subclasses add more init here if needed
	}

	prInit { /* subclasses add stuff if needed */ }
}