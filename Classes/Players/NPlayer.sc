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
	var <activePlayer; // the player to be linked with next playFunc

	prInit {
		// get your source player
		postf("% Will get and store my source player from my name\n", this);
		sourcePlayer = name.asPlayer;
		postf("My source player is now: %\n", sourcePlayer);
	}

	playerAt { | index |
		/*  Access player at index. If none exists, create a new one:
			Create a new non-registered Nevent for the player, (using prNew).
			Store this player into activePlayer, so that it will be 
			(linked to your sourcePlayer and) played with the source 
			provided through setSource.
		*/
		postf("NPlayer will create a player storing it at %\n", index);
	}

	setSource { | function |
		/* Set function as source to the selected activePlayer
		*/
		postf("Method %, srcPlayer argument is: %, its class is: %\n",
			thisMethod.name, function, function.class
		);
		postf(
			"NPlayer will link the latest created player, then play % in it\n",
			function
		);
	}
	play { | srcPlayer |
		/* 
		*/
		postf("Method %, srcPlayer argument is: %, its class is: %\n",
			thisMethod.name, srcPlayer, srcPlayer.class
		);
		"I think this method play in NPlayer must be changed".postln;
		postf(
			"NPlayer will link the latest created player, then play % in it\n",
			srcPlayer
		);
		// "this is what needs to be debugged".errorerrorerror;
	}

}