/*  3 Dec 2020 16:15
Manage a list of stuff. Interface with guis created with
Symbol:listView etc.

TODO: Next: 

- Add changed notifications in response to keyDownAction,
to facilitate adding custom actions in dependants of this model,
such as updating a sound file or buffer view, playing or resetting a buffer
etc.

- Devise ways to save these lists with Config class.

\test.listView;
ListModel.named(\test).items = (1..5);
*/

ListModel : NamedSingleton {
	var <list;
	var <selectedIndex = 0, <selectedItem;
	
	prInit { list = List(); }

	listView {
		^ListView()
		.items_(list.array)
		.font_(GuiDefaults.font)
		.action_({ | me |
			this.selectAt(me.value);
		})
		.keyDownAction_({ | me, key |
			if (key === Char.ret ) { "return was pressed".postln }
		})
		.addNotifier(this, \items, { | arglist, n |
			{
				n.listener.items = list.array;
			}.defer;
		})
		.addNotifier(this, \selectedIndex, { | n |
			{
				n.listener.value = selectedIndex
			}.defer;
		})
	}

	items_ { | argArray |
		list.array = argArray;
		this.changed(\items, list);
		this.updateSelection;
	}

	updateSelection { this.selectAt(selectedIndex); }

	selectAt { | argSelectedIndex |
		selectedIndex = argSelectedIndex max: 0 min: (list.size - 1);
		selectedItem = list[selectedIndex];
		this.changed(\selectedIndex);
	}
}