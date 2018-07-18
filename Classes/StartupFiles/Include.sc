/*
Compose the startup file from a list of files selected from folder "Includes".
*/
Include {
	classvar <all, <includeFolder;
	var <fileName, <contents;

	*new { | name, contents |
		^this.newCopyArgs(name, contents).init;
	}

	getPath {
		^PathName(this.class.filenameSymbol.asString).pathOnly
		++ "Includes" +/+ fileName ++ ".scd"
	}
	
	init {
		all = all add: this;
	}

	writeAll2File {
		
		
	}
	
	*quote { | string |
		Include(nil, string);
	}

	writeToFile { | file |
		/*
		file.putString("\n// % \n", fileName);
		file.putString(contents);
		file.putString("\n////////////////////////////////////////////////////////////////\n");
		*/
	}

}
