/*  4 Dec 2020 22:15
New type of player. Works as Fx linked to another player.
Created via \symbol +> { Function }
It is a NamedSingleton, and thus stored in Library under NamedSingleton.
This means it does not interfere with the namespace of Player

\default +> { "some function" };
\anotherPlayer +> { "some function" };

Note on var players: 
This is a List containing Players named by concatenating the name of 
the present NPlayer with the index at which they are created.
If the NPlayer is named \test and the index is 1, then tne Player is 
named \test_1.  While the players are created in the usual way by
accessing them through Registry, using method Symbol:p, the List
stores all players belonging to this NPlayer in order to be able to
free them and garbage collect them when needed.
*/

NPlayer : NamedSingleton {
	var players; // player array - accessed by numerical index
	var <sourcePlayer;

	prInit {
		// get your source player
		postf("% Will get and store my source player from my name\n", this);
		sourcePlayer = name.asPlayer;
		postf("My source player is now: %\n", sourcePlayer);
		players = List(); // initialize players list
	}

	play { | func, index |
		var activePlayer; // the player to be linked
		activePlayer = this.getPlayerAt(index);
		//================================================================
		postf("Method %, srcPlayer argument is: %\n",
			thisMethod.name, func
		);
		"I think this method play in NPlayer must be changed".postln;
		postf(
			"NPlayer will link the latest created player, then play % in it\n",
			func
		);
		//================================================================
		// Here we need to adapt - or incorporate - this code 
		/*
	*< { | reader, param = \out | // many readers to one writer.
		// Writers bus stays same
		// The new reader gets the writer's bus.
		// Thus a new reader is added to the writer.
	     ^reader.asPersistentBusProxy(\in) linkWritersBus2Reader: (
	           PersistentBusProxy(this, param)
         )
	}

		*/
	}

	getPlayerAt { | index |
		/*  Access a Player at index. If none exists, create a new one:
			Return the Player so that it will be 
			(linked to your sourcePlayer and) played with the source 
			provided through setSource.
		*/
		postf("NPlayer will access or create a player storing it at %\n", index);
		^players[index] ?? {
			players.sput(index, format("%_%", name, index).asSymbol.p);
			players[index];
		};
	}
}