//  6 Oct 2017 12:32
// This method is called by Nevent:initClass;

+ ControlSpec {
	*makeMoreDefaults {
		(
			ringTime: [0.01, 5, \exp, 0, 0.5].asSpec
			// more defaults may be added here.
			// , example: [...].asSpec
			// , ...
		) keysValuesDo: { | key, value |
			this.put_(\specs, key, value);
		}
	}
}