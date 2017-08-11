Nevent : EnvironmentRedirect {
	classvar <libRoot = \environments;
	*all {
		^Registry.at(\libRoot).values;
		
	}
	*new { | name |
		^Registry(libRoot, name, {
			this.newCopyArgs(
				(),
				Dispatch.newCopyArgs(
					this, (
					Integer: { | key, object |
						[key, object]
					},
					Float: { | key, object |
						[key, object]
					}
				))
			).setGroup(OrderedGroup.last);
		})
	}

	setGroup { | orderedGroup |
		this.put(\target, orderedGroup.group);
		this.addNotifier(orderedGroup, \group, { | group |
			this.put(\target, group);
		});
	}

}