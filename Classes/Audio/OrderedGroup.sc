/* 11 Aug 2017 20:40
Group container.
Recreates the groups in the original order when the server boots.
An object can register to be notified when each group is recreated, so as to obtain it.
See Nevent.
*/


OrderedGroup {
	classvar all;
	var <group, <count;
	// added  9 Mar 2019 17:57
	// var <subgroups; // allow Nenvirs to have their own group
	// to be able to independently set synth parameters when patterns are playing.
	*initClass {
		ServerTree add: {
			this.makeGroups;
		}
	}

	*new { ^super.new.init; }

	init {
		// subgroups = ();
		group = Group();
		this.all addFirst: this;
		count = all.size;
	}

	all {
		all ?? { all = List() };
		^all;
	}

	set { | ... args |
		group.set(*args);
	}
	
	*makeGroups {
		// on ServerTree, remake all real groups in the right order.
		(all ?? { all = List() }).reverse do: _.getGroup;
		// Player:persist adds notifications so that these players will always restart here:
		{ OrderedGroup.changed(\groups) }.defer(0.5);
	}

	getGroup {
		// get a new real group from the server
		group = Group();
		// Force making of new subgroups for individual envirs:
		// subgroups = (); // previous groups are invalid and thus must be rejected
		// { this.makeEnvirGroups }.defer(0.1);
		// Groups are always re-created before any synths at ServerTree.
	}

	
	
	*last {
		// get the last group from the list of all.
		// this is the first group that was made, and is therefore the last group in the server's order.
		/*
			if (all.isNil) {
			warn("OrderedGroup: You need to boot the default server to get groups.");
			}{
			if (all.size == 0) { this.new };
			^all.last;
			}
		*/
		if (all.size == 0) { this.new };
		^all.last;
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