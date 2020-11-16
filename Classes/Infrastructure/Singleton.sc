/* 23 Feb 2019 10:41

Superclass for classes that commonly require only a single default instance.
Sending a message to this class will redirect it to its default instance.
The default instance is stored at Registry(<SingletonSubclass>, \default),
where <SingletonSubclass> is a subclass of Singleton defined by the user.

To get the default instance of a Singleton subclass, use message 'default'.
To create and/or get an instance stored under a different name, use message
'named'.

SomeSingletonSubclass.named(\test); 

*/

Singleton {
	*doesNotUnderstand { | selector ... args |
		^this.default.perform(selector, *args);
	}

	*default {
		^this.named(\default);
	}

	*named { | name ... args |
		/* postf("!! % !!! Singleton.named: name: %\n",
			this,
			name);
		*/
		^Registry(this, name, {
			this.new().init(name, *args);
		})
	}

	*all { ^Registry.allAt(this) }
	
	init { | name ... args |
		// use init to customize state in your subclass
		// postf("initializing new % with args %", this, args);
		postf("% still testing init. name was: %, args: %\n", this, name, args);
	}	
}

SingletonSubclassTest : Singleton {
// example: 
// SingletonSubclassTest.blah(1, 2, 3);
// uses SingletonSubclassTest default instance, blah instance method!
	blah { | ... args |
		"blah!".postln;
		args.postln;
	}

	init { | name, myarg |
		postf("testing init class of new % named %\n", this, name);
		postf("myarg was: %\n", myarg);
	}
}

/*
SingletonSubclassTest.blah(1, 2, 3);

SingletonSubclassTest.named(\x1, 2, 3);

Registry.at(SingletonSubclassTest);

SingletonSubclassTest.all;

*/