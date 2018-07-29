/* 29 Jul 2018 14:02
Return path of the home directory of sc-hacks library.
In future possibly also perform other global management tasks.
*/

Sch {
	*homedir {
		^PathName(this.filenameSymbol.asString).pathOnly;
	}
	
}