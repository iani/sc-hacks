/*
Compose the startup file from a list of files selected from folder "Includes".
*/
Include {
	classvar <beforeBoot;           // execute these before booting server
	classvar <afterBoot;            // execute these after booting server
	// classvar <includeFolder;  // path to folder containing all include files

	var <fileName,  <extraCode; //, <server;

	*load {
		if (beforeBoot.notNil) {
			beforeBoot do: _.load;
			Server.default.waitForBoot({
				afterBoot do: _.load;
			})
		}{
			afterBoot do: _.load;
		}
		//		this.reset;
	}
	
	*reset { beforeBoot = nil; afterBoot = nil; }

	*quote { | string |
		// include string in startup script without reading it from another file.
		Include(nil, string);
	}
	
	*new { | name = "", extraCode = "" |
		// all = all add: this.newCopyArgs(name, contents);
		afterBoot = afterBoot add: this.newCopyArgs(name, extraCode);
	}

	*server { | name = "", code = "" |
		this.newCopyArgs(name, code).server;
	}

	server {
		/*  Add Include to serverIncludes.
			If serverIncludes exist, then concatenate their optionsCode into a string,
			evaluate that string with options as local variable set to the server,
			and then boot the server, loading the code of startup1.scd after it is booted.
		*/
		beforeBoot = beforeBoot add: this;
	}

	load {
		this.getPath.doIfExists({ | p |
			postf("loading % ...", fileName);
			p.load;
			"... done. Now loading extra code.".postln;
		},{
			postf("could not load include named %\n", fileName);
			"Will load internal code if it exists".postln;
		});
		extraCode.interpret;
		"Done\n".postln;
	}
	/*
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
	*/
	getPath {
		^PathName(this.class.filenameSymbol.asString).pathOnly
		++ "Snippets/Includes" +/+ fileName ++ ".scd"
	}

	/*
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
	*/
}
