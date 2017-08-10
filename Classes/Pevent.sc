Nevent : EnvironmentRedirect {
	classvar <libRoot = \penvir;
	*new { | name |
		^Registry(libRoot, name, { super.new; })
	}

	put {
		
		
	}
}