//:  4 Dec 2020 08:55
/* Redoing Hacks class here.

*/

Hacks : NamedSingleton {

	menu {
		this.buttons(
			"test my receiver", { postf("my receiver is: %\n", this) }
		)
	}	
}