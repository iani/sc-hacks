/*  3 Dec 2020 16:15
Manage a list of stuff. Interface with guis created with
Symbol:listView etc.
*/

ListModel : NamedSingleton {
	var <list;
	var <selectedIndex = 0, <selectedItem;
	
	prInit { list = List(); }

	listView {
		^ListView()
		// .items_(list.array)
		.items_(list.array)
		.font_(GuiDefaults.font)
		.action_({ | me |
			postf("% value selected %, item: %\n", me, me.value, me.item);
			//			me.changed(\selection, me.value, me.item);
			this.selectAt(me.value);
		})
		.keyDownAction_({ | me, key |
			// postf("%, pressed: %\n", me, key);
			if (key === Char.ret ) { "Return was pressed".postln }
		})
		.addNotifier(this, \items, { | argList, n |
			// postf("the list received is: %\n", argList);
			// postf("the notification that sent it is: %\n", n);
			{ n.listener.items = list.array }.defer;
		})
	}

	items_ { | argArray |
		list.array = argArray;
		this.updateSelection;
		this.changed(\items, list);
	}

	updateSelection { this.selectAt(selectedIndex); }

	selectAt { | argSelectedIndex |
		selectedIndex = argSelectedIndex max: 0 min: (list.size - 1);
		selectedItem = list[selectedIndex];
	}
}