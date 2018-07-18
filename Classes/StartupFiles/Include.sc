/*
Compose the startup file from a list of files selected from folder "Includes".
*/
Include {
	classvar <all, <includeFolder;
	var <fileName, <contents;

	*reset { all = nil; }
	
	*new { | name, contents |
		^this.newCopyArgs(name, contents).init;
	}

	*quote { | string |
		Include(nil, string);
	}

	getContents {
		if (fileName.isNil) {
			contents = contents ? "// -";
		}{
			this.getPath.doIfExists({ | path |
				contents = format("\n//: ================ % ================\n", fileName)
				++ File.readAllString(path)
				++ "\n////////////////////////////////////////////////////////////////\n";
			},{ | path |
				contents = "// file not found: " ++ path;
			});
		}
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

	writeToFile { | file |
		/*
		file.putString("\n// % \n", fileName);
		file.putString(contents);
		file.putString("\n////////////////////////////////////////////////////////////////\n");
		*/
	}

}
