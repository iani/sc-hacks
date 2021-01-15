//: 21 Dec 2020 11:25
/* a named singleton whose instances delegate the execution
of messages to the object contained in var object.
Accessed via operators and messages acting on its name.

Methods f_ and f allow using this also to store and evaluate a function
like this: 

1. Store the function
\symbol.f = { }

2. evaluate the function
\symbol.f(arg1, arg2 ...); 

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

	f_ { | func |
		^DelegatingNamedSingleton.named(this).object = func;
	}

	f { | ... args |
		^DelegatingNamedSingleton.named(this).object.(*args);
	}
}
