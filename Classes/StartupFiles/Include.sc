/*
Compose the startup file from a list of files selected from folder "Includes".
*/
Include {
	classvar <all;            // array of includes to be concatenated in Startup file
	classvar <includeFolder;  // path to folder containing all include files
	classvar <serverIncludes; // array of includes to be concatenated in server boot code.
	var <fileName, <contents; //, <server;

	*reset { all = nil; serverIncludes = nil; }
	
	*new { | name, contents |
		all = all add: this.newCopyArgs(name, contents);
	}

	*quote { | string |
		// include string in startup script without reading it from another file.
		Include(nil, string);
	}

	*server { | /* server, */ optionsCode |
		/*  Add Include to serverIncludes.
			If serverIncludes exist, then concatenate their optionsCode into a string,
			evaluate that string with options as local variable set to the server,
			and then boot the server, loading the code of startup1.scd after it is booted.
		*/
		serverIncludes = serverIncludes add: this.newCopyArgs(nil, optionsCode ? "");
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

	*makeServerCode {
		var code;
		if (serverIncludes.isNil) {
			code = "\nStartupFiles.loadStartupFile;\n";
		}{
			code = "var options;
options = Server.default.options;\n";
			serverIncludes do: { | i |
				code = code ++ i.contents;
			};
			code = code ++ "
Server.default.waitForBoot({
     StartupFiles.loadStartupFile;
});
";
		};
		^code;
		
	}

}
