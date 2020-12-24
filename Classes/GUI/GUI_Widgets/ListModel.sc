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
	var <selection = #[0], <selectedItems;
	
	prInit { list = List(); }

	listView {
		^ListView()
		.items_(list.array)
		.font_(GuiDefaults.font)
		.action_({ | me |
			//	postf("testing selection: %\n", me.selection);
			this.selection = me.selection;
		})
		.mouseUpAction_({ | me |
			//	postf("testing MOUSE selection: %\n", me.selection);
			this.selection = me.selection;
		})
		.selectionMode_(\multi) // allow selecting multiple items
		.keyDownAction_({ | me, key |
			switch(
				Char.ret, { "return was pressed".postln },
				Char.space, {
					//	postf("updating selection: %\n", me.selection);
					this.selection = me.selection;
				}
			)
		})
		.addNotifier(this, \items, { | arglist, n |
			{
				n.listener.items = list.array;
			}.defer;
		})
		.addNotifier(this, \selection, { | n |
			{
				n.listener.selection = selection
			}.defer;
		})
	}

	items_ { | argArray |
		/* set the contents of the list to argArray
			notify view dependants about the change so that they
			update their condents according to the new list.
		*/
		list.array = argArray; // set contents of list
		this.changed(\items, list); // notify (view) dependants to update
		this.updateSelection;  // update values of selected items
	}

	updateSelection {
		/* Note: selection_ method selects only those 
			indices which are within the range of the size of the new list.
		*/
		this.selection = selection;
	}

	selection_ { | indexArray |
		var max;
		max = list.size;
		/* make sure that items selected are within the size
			of the new list.
		*/
		selection = indexArray select: { | i |
			i >= 0 and: { i < max}
		};
		selectedItems = list[selection];
		this.changed(\selection);
	}
}