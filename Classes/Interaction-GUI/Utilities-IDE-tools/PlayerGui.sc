// 21 Aug 2018 16:36 Experimental
/*
Todo: add script pane to the right.
Use similar scheme as SnippetList gui.  Difference is that the result of running a snippet is sent to the currently selected player from the "Player Details" list.

The snippets are generated from a folder called "Players", with one file per player.
But they are run differently - as outlined above.

*/

PlayerGui {
	*initClass {
		StartUp add: {
			this.new;
		}
	}
	*new {
		this.window({ | w |
			w.name = "Players: -";
			w.bounds = Rect(0, 0, 1000, 300);
			w.view.layout = HLayout(
				VLayout(
					// StaticText().string_("Environments"),
					/*
						ListView()
						.items_(Nevent.all collect: _.name)
						.addNotifier(Nevent, \new, { | new, n |
						{ n.listener.items_(Nevent.all collect: _.name); }.defer(0.01);
						}),
					*/
					// StaticText().string_("Player Details"),
					// ListView(),
					StaticText().string_("Players (click to toggle play status)"),
					ListView()
					.maxWidth_(250)
					.items_(Player.all collect: _.asString)
					.selectionMode_(\multi)
					.selectionAction_({ | me |
						var all;
						all = Player.all;
						(Array.fill(me.items.size, false)[me.selection] = true) do: {
							| status, index | 
							if (all[index].isPlaying !== status) { all[index].toggle }
						};
					})
					/* We use enter key for the case that there is only one player in the list
						We can add the same function as action in order to enable 
						automatic update of a players list when a player is selected with
						the cursor keys.
					*/
					.enterKeyAction_({ | me |
						// TODO: show snippets of this player in another pane.
						// 25 Aug 2018 16:33: preparing.
						// Player.all[me.value].inspect;
						// Player.all[me.value].getHistory.postln;
						Player.changed(\history, Player.all[me.value].getHistory);
					})
					.action_({ | me |
						Player.changed(\history, Player.all[me.value].getHistory);
					})
					.addNotifier(Player, \status, { | new, n |
						var me, index;
						me = n.listener;
						{
							var players;
							index = me.value ? 0;
							players = Player.all;
							me.items_(players collect: _.asString);
							if (players.size > 0) {
								me.selection = (0..players.size-1) select: { | p |
									players[p].isPlaying;
								};
							};
						}.defer(0.01);
					}),
					/* TODO:
						Add a pane to the right of this, showing the Player History of 
						the selected player when typing the enter on the player list.

					*/
				),
				// ListView().items_([\1, \2, \alpha])
				ScrollView(w, Rect(0, 0, 600, w.bounds.height)).canvas_(View().layout = VLayout(
					StaticText().string_("Run a player snippet to add it here.")
				))
				.addNotifier(Player, \history, { | history, n |
					// TESTING!
					// "destroying canvas".postln;
					n.listener.canvas.destroy;
					n.listener.canvas = View().layout = VLayout(
						*(
							history.array.collect({ | h |
								HLayout(
									StaticText().string_(h.code).background_(Color.rand),
									Button()
									.maxWidth_(50)
									.states_([["RUN"]])
									.action_({ h.snippet.run; })
								)
							})
						)
					);
				})
			);
			w.addNotifier(Player, \history, { | history, n |
				{ n.listener.name = format("Players : %", history.first.name); }.defer;
			})
		});
		Player.changed(\status, Player.all[0]);
	}
}