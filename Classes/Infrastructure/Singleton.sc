/* 23 Feb 2019 10:41

Superclass for classes that commonly require only a single default instance.
Sending a message to this class will redirect it to its default instance.
The default instance is stored at Registry(<SingletonSubclass>, \default),
where <SingletonSubclass> is a subclass of Singleton defined by the user.

(Other instances can be created and used if needed, but there is no mechanism provided
here to store them.)


*/

Singleton {
	*doesNotUnderstand { | selector ... args |
		/*
			{ "blah".postln; } ! 10;
			selector.postln;
			args.postln;
			*/
		^Registry(this, \default, {
			this.new()	
		}).perform(selector, *args)
	}

	/* // why is no subclassing of this possible?
	new {
		^super.new.init; // use init to customize state in your subclass
	}

	init {
		// use init to customize state in your subclass
	}
	*/
	
}


SingletonSubclassTest : Singleton {
// example: 
// SingletonSubclassTest.blah(1, 2, 3);
// uses SingletonSubclassTest default instance, blah instance method!
	blah { | ... args |
		"blah!".postln;
		args.postln;
	}
}