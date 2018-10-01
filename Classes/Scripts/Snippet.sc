/* 21 Jul 2018 08:26
Create gui from snippet text
select snippet from list of snippets, type return to evaluate snippet.
*/

Snippet {
	var <name, <>code, <pathName, <pathOnly;
	var <includes, <type;
	var <color; // textfield background indicates snippet identity

	*readAll { | path |
		var snippet, snippets, pathName, pathOnly;
		pathName = PathName(path);
		snippet = this.new(pathName.fileNameWithoutExtension, "", pathName);
		File.readAllString (path).split(Char.nl) do: { | l |
			if ("^//:" matchRegexp: l) {
				snippets = snippets add: snippet;
				snippet = this.new(l[3..], "", pathName);
			}{
				snippet addCode: l;
			}
		};
		snippets = snippets add: snippet;
		^snippets;
	}

	*newWithPlayer { | playerName, code |
		var new;
		new = this.new(playerName.asString, code ? "");
		new.add2History;
		Player.changed(\status, playerName.asSymbol.p);
		^new;
	}

	*new { | name, code, pathName |
		^this.newCopyArgs(name, code ? "", pathName).init;
	}

	init {
		var hasIncludes = false;
		var titleParts;
		pathName ?? {
			pathName = PathName(
				PlayerSnippetList.rootDir +/+ "Auto" +/+ name ++ ".scd"
			);
		};
		pathOnly = pathName.pathOnly;
		titleParts = name.asString.split($ );
		// name.postln;
		type = titleParts.first.asSymbol;
		titleParts do: { | p |
			if (hasIncludes) { includes = includes add: p };
			if (p == "include") { hasIncludes = true };
		};
		color = Color.rand;
	}

	addCode { | string = "" |
		code = code ++ if (code.size == 0) { "" }{ "\n" } ++ string;
	}

	run {
		var rootDir, currentDir;
		// experimental: keep history of snippets ////////////////
		this.add2History;
		////////////////////////////////////////////////////////////////
		rootDir = SnippetList.rootDir;
		currentDir = pathOnly;
		postf("running snippet: %. includes are: %\n", name, includes);
		includes do: { | i |
			if (i[0] === $/) {
				currentDir = rootDir ++ i[1..]
			}{
				(currentDir +/+ i ++ ".scd").doIfExists({ | p |
					postf("Running include:\n%\n", p);
					p.load;
				},{ | p |
					postf("Did not find include:\n%\n", p);
				})
			}
		};
		code.postln.interpret;
	}

	add2History {
		SnippetHistory(name, this).add(\CodeSnippets);		
	}
}
