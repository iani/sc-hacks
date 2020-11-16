// Superclass for SenseServer and its dependants
NamedSingleton : Singleton {
	var <name;

	init { | argName |
		/* postf("% NamedSingleton.init argName: %\n",
			this, argName;
			); */
		name = argName;
	}
}