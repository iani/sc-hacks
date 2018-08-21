// Building a gui for the list of players
//:version 1: do not restore selection after update
\players.v(
	StaticText().string_("Environments"),
	ListView()
	.items_(Nevent.all collect: _.name)
	.addNotifier(Nevent, \new, { | new, n |
		{ n.listener.items_(Nevent.all collect: _.name); }.defer(0.01);
	}),
	StaticText().string_("Players"),
	ListView()
	.items_(Player.all collect: _.name)
	.addNotifier(Player, \status, { | new, n |
		var me;
		me = n.listener;
		{
			var players;
			players = Player.all;
			me.items_(players collect: _.name);
			me.colors = players collect: { | p | if (p.isPlaying) { Color.red } { Color.white }};
			me.enterKeyAction = { | v | players[v.value].postln.toggle };
		}.defer(0.01);
	})
	//
);
\players.window.bounds = \players.window.bounds.height_(600).width_(250);
//:version 2: restore selection after update
\players.v(
	StaticText().string_("Environments"),
	ListView()
	.items_(Nevent.all collect: _.name)
	.addNotifier(Nevent, \new, { | new, n |
		{ n.listener.items_(Nevent.all collect: _.name); }.defer(0.01);
	}),
	StaticText().string_("Players"),
	ListView()
	.items_(Player.all collect: _.name)
	.selectionMode_(\multi)
	.selectionAction_({ | me |
		var all;
		all = Player.all;
		(Array.fill(me.items.size, false)[me.selection] = true) do: { | status, index | 
		 	if (all[index].isPlaying !== status) { all[index].toggle }
		 };
	})
	.addNotifier(Player, \status, { | new, n |
		var me, index;
		"received status message".postln;
		me = n.listener;
		{
			var players;
			index = me.value ? 0;
			players = Player.all;
			["playsers are: ", players].postln;
			me.items_(players collect: _.name);
			if (players.size > 0) {
				me.selection = (0..players.size-1) select: { | p |
					players[p].isPlaying;
				};
			};
		}.defer(0.01);
	})
	// 
);
\players.window.bounds = \players.window.bounds.height_(600).width_(250);
Player.changed(\status, Player.all[0]);
//:create new player
() +> \newEvent0;
//:create new player 2
(dur: 0.1, degree: 1) +> \newEvent1;
//:
Player.all;