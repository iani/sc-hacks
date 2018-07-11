Include {
	classvar <toInclude, <included;
	var <pathClass, <fileClass;

	*initClass {
		StartUp add: {
			// { \testing.postln; } ! 50;
			this.includeAll;
		}
	}

	*includeAll {
		included = Set();
		toInclude do: { | include |
			if (included.includes(include).not) {
				include.include;
			}
		}
	}

	include {
		
	}

	*new { | pathClass, fileClass |
		
	}
}