// 28 Sep 2017 17:15
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// INCOMPLETE !!!!!!!!!!!!!!!!

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/* List all players.
Space toggle-plays the selected player.
Enter pushes the player's envir.
Planned: backspace stops the player and removes it from the system. (?)
Possible extension: Text pane for ineracting with the player with code.
*/

PlayerGui {
		*gui {
		this.window({ | w |
			w.view.layout = VLayout(
				StaticText().string_("Enter: push envir, Space: toggle player")
				.align_(\center),
				ListView().items_(Player.all collect: _.asString)
				.keyDownAction_({ | view, char, mod, key |
					switch (key,
						// 127, { this.remove(this.all[view.value]) },
						13, { this.push(view.items [view.value]) },
						32, { this.toggle(view.items [view.value]) },
						0, {},
						{ key.postln }
					)
				})
				.addNotifier(Player, \all, { | notification |
					notification.listener.items = Player.all ? []
				})
				.focus(true); // focus here, away from load button.
			)
		})
	}

	*push { | item |
		postf("pushing: %", item.asCompileString);
		item.asPlayer.push;
	}

	*toggle { | item |
		item.asPlayer.toggle;
	}
}

+ String {
	asPlayer {
		// retrieve player instance from string representation of player
		var event, player;
		#event, player = this.split($|).collect(_.asSymbol);
		^player.p(event);
	}
}