/* 11 Aug 2017 20:40
Group container.
Recreates the groups in the original order when the server boots.
An object can register to be notified when each group is recreated, so as to obtain it.
See Nevent.
*/


OrderedGroup {
	classvar all;
	var <group;
	*initClass {
		ServerTree add: {
			this.makeGroups;
		}
	}

	*new { ^super.new.init; }

	init {
		group = Group();
		this.all addFirst: this;
	}

	all {
		all ?? { all = List() };
		^all;
	}
	
	*makeGroups {
		// on ServerTree, remake all real groups in the right order.
		(all ?? { all = List() }).reverse do: _.getGroup;
	}

	getGroup {
		// get a new real group from the server, and notify dependants.
		group = Group();
		// this.changed(\group, group); // not needed any more.
	}

	*last {
		// get the last group from the list of all.
	^	// this is the first group that was made, and is therefore the last group in the server's order.
		if (all.isNil) {
			warn("OrderedGroup: You need to boot the default server to get groups.");
		}{
			if (all.size == 0) { this.new };
			^all.last;
		}
	}

	*before { | argGroup |
		// get the group before argGroup. If argGroup is the first group, then make a new one.
		var index;
		if (all.isNil) {
			^warn("OrderedGroup: You need to boot the default server to get groups.");
		};
		index = (all indexOf: argGroup) ? -1;
		if (index < 1) {^this.new; }{ ^all[index-1] }
	}

	asTarget { ^group }
	asNodeID { ^group.nodeID }
	
	printOn { | stream |
		stream << "OrderedGroup(" << (if (group.isNil) {} { group.nodeID }) << ")";
	}
}