/* 21 Jul 2018 08:26
Create gui from snippet text
select snippet from list of snippets, type return to evaluate snippet.
*/

Snippet {
	var <name, <>code, <pathName, <pathOnly;
	var <includes, <type;

	*readAll { | path |
		var snippet, snippets, pathName, pathOnly;
		pathName = PathName(path);
		snippet = this.new(pathName.fileNameWithoutExtension, "", pathName);
		File.readAllString (path).split($
		) do: { | l |
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

	*new { | name, code, pathName |
		^this.newCopyArgs(name, code ? "", pathName).init;
	}

	init {
		pathOnly = pathName.pathOnly;
		includes = name.split($ );
		type = includes.first.asSymbol;
		switch (type,
			\include, { includes = includes[1..]; },
			\server, {
				if (includes[1] == "include") {
					includes = includes[2..]
				}{ includes = nil }
			},
			\preload, {
				if (includes[1] == "include") {
					includes = includes[2..]
				}{ includes = nil }
			},
			{
				includes = nil;
				type = '-';
			}
		);
	}

	addCode { | string = "" |
		code = code ++ if (code.size == 0) { "" }{ "\n" } ++ string;
	}

	run {
		var rootDir, currentDir;
		// experimental: keep history of snippets ////////////////
		SnippetHistory(name, code);
		////////////////////////////////////////////////////////////////
		rootDir = SnippetList.rootDir;
		currentDir = pathOnly;
		postf("running snippet: %. includes are: %\n", name, includes);
		includes do: { | i |
			if (i[0] === $/) {
				currentDir = rootDir ++ i[1..]
			}{
				(currentDir ++ i ++ ".scd").doIfExists({ | p |
					postf("Running include:\n%\n", p);
					p.load;
				},{ | p |
					postf("Did not find include:\n%\n", p);
				})
			}
		};
		code.postln.interpret;
	}
}
