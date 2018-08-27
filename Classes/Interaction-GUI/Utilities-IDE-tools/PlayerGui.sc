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
						PlayerSnippet.newWithPlayer(
							me.string.replace(" ", "_").asSymbol;,
"// Edit code in this text view, then press the \"RUN\" button to play it in player.
// Uae an event, a UGen function, or a symbol naming an existing SynthDef
// Example 1: Event
(dur: 0.1, degree: [-5, 5, 32].pwhite) 
// Example 2, UGen Function:
// { WhiteNoise.ar(0.1) }
// Example 3: name of SynthDef
// \\default
"
						);
						/*
						var playerName;
						playerName = me.string.replace(" ", "_").asSymbol;
						PlayerSnippet(
							playerName,
							"// please add something to play here, and then run."
						).add2History;
						{ me.value.postln; } ! 10;
						Player.changed(\status, playerName.p);
						*/
					}),
					ListView()
					.maxWidth_(250)
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
						Player.changed(\history, Player.all[me.value].getHistory);
					})
					.action_({ | me |
						postf("this list view's action was called. value is: %\n", me.value);
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
					})
					.addNotifier(Player, \history, { | history, n |
						var me, index;
						me = n.listener;
						//	{[me, Player.all].postln; } ! 10;
						/*						{
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
						*/
					}),
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
"To create a new player, type any name in the text field 
at the top left, and then press enter.
")
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