/* 11 Aug 2017 20:40
Group container.
Recreates the groups in the original order when the server boots.
An object can register to be notified when each group is recreated, so as to obtain it.
See Nevent.
*/


OrderedGroup {
	classvar all;
	var <group, <count;
	*initClass {
		ServerTree add: {
			this.makeGroups;
		}
	}

	*new { ^super.new.init; }

	init {
		group = Group();
		this.all addFirst: this;
		count = all.size;
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
		// get a new real group from the server
		group = Group();
		// Groups are always re-created before any synths at ServerTree.
		// No update needed. Synths, Patterns use the new groups when they start.
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

	getGroupBefore { | otherGroup |
		if (this isBefore: otherGroup) { ^this } { ^OrderedGroup before: otherGroup }
	}
	
	*before { | argGroup |
		// get the group before argGroup. If argGroup is the first group, then make a new one.
		if (all.isNil) {
			^warn("OrderedGroup: You need to boot the default server to get groups.");
		};
		if (argGroup.isFirst) {
			^this.new;
		}{
			^all[all.size - argGroup.count - 1];
		}
	}

	isFirst { ^all.size == count }

	isBefore { | otherGroup | ^count > otherGroup.count }
	
	asTarget { ^group }
	asNodeID { ^group.nodeID }
	
	printOn { | stream |
		stream << "OrderedGroup(" << (if (group.isNil) {} { group.nodeID }) << ")";
	}
}