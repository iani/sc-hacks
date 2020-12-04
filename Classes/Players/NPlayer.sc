/*  4 Dec 2020 22:15
New type of player. Works as Fx linked to another player.
Created via \symbol +> { Function }
It is a NamedSingleton, and thus stored in Library under NamedSingleton.
This means it does not interfere with the namespace of Player

\default +> { "some function" };

\anotherPlayer +> { "some function" };

*/

NPlayer : NamedSingleton {
	var players; // player array - accessed by numerical index
	var <sourcePlayer;
	var <activePlayer; // the player to be linked with play

	prInit {
		// get your source player
		postf("% Will get and store my source player from my name\n", this);
		sourcePlayer = name.asPlayer;
		postf("My source player is now: %\n", sourcePlayer);
	}

	playerAt { | index |
		postf("NPlayer will create a player storing it at %\n", index);
	}

	play { | srcPlayer |
		// this method must be changed to do nothing - or something else!
		postf("Method %, srcPlayer argument is: %, its class is: %\n",
			thisMethod.name, srcPlayer, srcPlayer.class
		);
		"I think this method play in NPlayer must be changed".postln;
		postf(
			"NPlayer will link the latest created player, then play % in it\n",
			srcPlayer
		);
	}

	playFunc { | function |
		/* play the function into the activePlayer, after linking it to the
		// source player.  The source player is obtained from the name!
		*/
		postf("Method %, srcPlayer argument is: %, its class is: %\n",
			thisMethod.name, function, function.class
		);
		postf(
			"NPlayer will link the latest created player, then play % in it\n",
			function
		);

	}
}