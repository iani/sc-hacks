// o noon noeito
+ Object {
	scriptify { | filenameBase |
		^PathName(this.class.filenameSymbol.asString).pathOnly
		+/+ filenameBase
		++ ".scd";
	}
	
}