//: 21 Dec 2020 11:25
/* a named singleton whose instances delegate the execution
of messages to the object contained in var object.
Accessed via operators and messages acting on its name.
*/

DelegatingNamedSingleton : NamedSingleton {
	var <>object;

	prInit { | argObject |
		object = argObject;
	}

	doesNotUnderstand { | selector ... args |
		^object.perform(selector, *args);
	}
}

/* Methods for accessing DelegatingNamedSingleton instances:

*/
+ Symbol {
	<! { | object |
		^DelegatingNamedSingleton.named(this).object = object;
	}

	ds {
		^DelegatingNamedSingleton.named(this);
	}
}