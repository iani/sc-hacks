// 21 Aug 2018 16:36 Experimental
/*
Todo: add script pane to the right.
Use similar scheme as SnippetList gui.  Difference is that the result of running a snippet is sent to the currently selected player from the "Player Details" list.

The snippets are generated from a folder called "Players", with one file per player.
But they are run differently - as outlined above.

*/


PlayerGui {

	*new {
		this.window({ | w |
			w.bounds = Rect(0, 0, 300, 500);
			w.view.layout = VLayout(
				StaticText().string_("Environments"),
				ListView()
				.items_(Nevent.all collect: _.name)
				.addNotifier(Nevent, \new, { | new, n |
					{ n.listener.items_(Nevent.all collect: _.name); }.defer(0.01);
				}),
				StaticText().string_("Player Details"),
				ListView(),
				StaticText().string_("Player Status"),
				ListView()
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
			)
		});
		Player.changed(\status, Player.all[0]);
	}
}