/* 11 Aug 2017 20:40
Group container.
Recreates the groups in the original order when the server boots.
An object can register to be notified when each group is recreated, so as to obtain it.
See Nevent.
*/


OrderedGroup {
	classvar <all;
	var <group;
	*initClass {
		ServerTree add: {
			this.makeGroups;
		}
	}

	*makeGroups {
		(all ?? { all = List() add: this.new }).reverse do: _.getGroup;
	}

	getGroup {
		group = Group();
		this.changed(\group, group);
	}

	*last {
		if (all.isNil) {
			warn("OrderedGroup: You need to boot the default server to get groups.");
		}{
			^all.last;
		}
	}

	*before { | group |
		var found, index;
		if (all.isNil) {
			^warn("OrderedGroup: You need to boot the default server to get groups.");
		};
		index = all indexOf: 
		all.detect({ | g, i |			
			index = i;
			g.group === group
		});
		postf("Implementing before. index found is: %\n", index);
		/*
		if (index == 1) {
			found = this.new.getGroup;
			all addFirst: found;
			^found;
		}{
			^all[index - 2];
			
		}
		*/
		
	}

	printOn { | stream |
		stream << "OrderedGroup(" << group.nodeID << ")";
	}
}