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
			{ this.new; }.defer(0.5); // open after other guis, to appear the top
		}
	}

	*new {
		this.window({ | w |
			w.name = "Players: -";
			w.bounds = Rect(0, 0, 1000, 300);
			w.view.layout = HLayout(
				VLayout(
					/* HLayout(
						StaticText().string_("Players (click to toggle play status)"),
						Button().states_([["*"]])
						.maxWidth_(20)
						.action_({ this.changed(\listFocus)})
					),
					*/
					TextField()
					.maxWidth_(250)
					.action_({ | me |
						var name, path;
						name = me.string.replace(" ", "_").asSymbol;
						path = (PathName(this.filenameSymbol.asString).pathOnly
							+/+ "DefaultPlayerSnippet.scd").postln;
						Registry.at(\PlayerSnippets, name) ?? {
							PlayerSnippet.newWithPlayer(
								name,
								File.readAllString(path)
							);
						};
                        Player.changed(\selectPlayer, name);
					}),
					ListView()
                    .maxWidth_(250)
					.addNotifier(Player, \selectPlayer, { | name, n |
						var player;
						player = Player.all.detect({ | p | p.name === name; });
						n.listener.value = Player.all indexOf: player;
						Player.changed(\history, player.getHistory);
					})
					.addNotifier(Player, \status, { | new, n |
						var me, index;
						me = n.listener;
						{
							var players;
							index = me.value ? 0;
							players = Player.all;
							me.items_(players collect: _.asString);
							me.value = index;
						}.defer(/*0.01 */);
					})
					.enterKeyAction_({ | me |
						//	Player.changed(\history, Player.all[me.value].getHistory);
						me.value !? {
							this.doAfterBooting({
								Player.all[me.value].getHistory.last.changed(\runButton);
							})
						}
					})
					.action_({ | me |
						Player.changed(\history, Player.all[me.value].getHistory);
					}),
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
					// enterkey and action functionality delegated to listview abov
					/*
					.enterKeyAction_({ | me |
						// TODO: show snippets of this player in another pane.
						// 25 Aug 2018 16:33: preparing.
						// Player.all[me.value].inspect;
						// Player.all[me.value].getHistory.postln;
						Player.changed(\history, Player.all[me.value].getHistory);
					})
					.action_({ | me |
						// Player.changed(\history, Player.all[me.value].getHistory);
					})
					*/
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
							// me.value = index;
						}.defer(/*0.01 */);
					}),
						/*						{
					.addNotifier(Player, \history, { | history, n |
						var me, index;
						me = n.listener;
 						//	{[me, Player.all].postln; } ! 10;
					
							var players;
							index = me.value ? 0;
							players = Player.all;
							me.items_(players collect: _.asString);
							// { [me, me.items, players].postln; } ! 10;
							if (players.size > 0) {
								me.selection = (0..players.size-1) select: { | p |
									players[p].isPlaying;
								};
							};
							//	me.value = index;
							//
						}.defer(0.01);
						
					}),*/
					HLayout(
						Button().states_([["Boot Server", nil, Color.red],
							["Quit Server", nil, Color.green]])
						.action_({| me |
							[{ Server.default.boot }, { Server.default.quit} ][
								1 - me.value
							].value
						})
						.focusColor_(Color.red)
						.addNotifier(Server.default, \counts, { | n |
							n.listener.value = 1;
						})
						.addNotifier(Server.default, \didQuit, { | n |
							n.listener.value = 0;
						}),
						Button().states_([["Stop all"]])
						.action_({ CmdPeriod.run })
						.focusColor_(Color.red),
					)
				),
				// ListView().items_([\1, \2, \alpha])
				ScrollView(w, Rect(0, 0, 600, w.bounds.height)).canvas_(View().layout = VLayout(
					StaticText().string_(
						this.readFromClassPath("InitialMessage.scd")
					)
				))
				.addNotifier(Player, \history, { | history, n |
					n.listener.canvas.destroy;
					n.listener.canvas = View().layout = VLayout(
						*(history.reverse.collect({ | h |
							// h.postln; h.class.postln; h.snippet.postln;
							//	h.snippet.inspect;
							// h.code.postln;
							h.guiWidget;
						}))
					);
				})
			);
			w.addNotifier(Player, \history, { | history, n |
				// [this, history].postln;
				// history.first.name.postln;
				{ n.listener.name = format("Players : %", history.first.name); }.defer;
			})
		});
		Player.changed(\status, Player.all[0]);
	}
}