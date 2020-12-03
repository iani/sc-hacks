// 24 Aug 2018 15:32 Shortcut for PopUpMenu with actions for each item.

ActionMenu {
	*new { | title ... headlineActionPairs |
		var pairs, items, actions;
		pairs = [[title, {}]] ++ headlineActionPairs.clump(2);
		#items, actions = pairs.flop;
		^PopUpMenu()
		.items_(items)
		.action_({ | me |
			actions[me.value].value;
			me.value = 0;
		})
	}
	
}