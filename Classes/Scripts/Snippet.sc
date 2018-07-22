/* 21 Jul 2018 08:26
Create gui from snippet text
select snippet from list of snippets, type return to evaluate snippet.
*/

Snippet {
	var <name, <>code;

	*readAll { | path |
		var snippet, snippets;
		snippet = this.new(PathName(path).fileNameWithoutExtension);
		File.readAllString (path).split($
		) do: { | l |
			if ("^//:" matchRegexp: l) {
				snippets = snippets add: snippet;
				snippet = this.new(l[3..], "");
			}{
				snippet addCode: l;
			}
		};
		snippets = snippets add: snippet;
		^snippets;
	}

	*new { | name, code |
		^this.newCopyArgs(name, code ? "");
	}

	addCode { | string = "" |
		code = code ++ string;
	}
}

SnippetList {
	classvar <folders, <folderIndex, <fileIndex, <snippetIndex, <snippets;
	classvar <edited;
	var <path, // path of file containing snippets
	<all,      // array of snippets created from code in file
	<>source,   // full source code from which snippets were made
	<name;     // name of file from which snippets were read

	*snippetFolders {
		^(this.folderPath ++ "*").pathMatch select: { | p |
			p.last == $/
		};
	}
	
	*folderPath {
		^PathName(this.filenameSymbol.asString).pathOnly ++ "Snippets/"
	}


	*new { | path |
		^this.newCopyArgs(path, []).init;
	}

	init {
		path.doIfExists({
			name = PathName(path).fileNameWithoutExtension;
			source = File.readAllString (path);
			this.getSnippetsFromSource;
		},{
			^postln ("Could not open file: " ++ path);
		})
	}

	getSnippetsFromSource {
		var snippet;
		snippet = Snippet(name, "");
		source.split($
		) do: { | l |
			if ("^//:" matchRegexp: l) {
				all = all add: snippet;
				snippet = Snippet(l[3..], "");
			}{
				snippet addCode: l;
			};
		};
		all = all add: snippet;
	}

	*gui {
		// this.window(\gui, Rect(200, 200, 800, 600));
		
		this.window({ | window |
			this.makeWindow(window)}, \gui, Rect(200, 250, 1000, 600)
		);
	}

	*makeWindow { | window |
		window.layout = HLayout(
			VLayout(
				PopUpMenu() // Popup: Select folder
				.addNotifier(this, \folders, { | notification |
					this.readFolders;
					notification.listener.items = folders collect: { | f |
						PathName(f[0]).folderName;
					};
					notification.listener.doAction;
				})
				.action_({ | me |
					folderIndex = me.value;
					this.changed(\folder)
				}),
				ListView() // List 1: Select file
				.addNotifier(this, \folder, { | n |
					n.listener.items = folders[folderIndex][1] collect: { | p |
						PathName(p).fileNameWithoutExtension;
					};
					n.listener.doAction;
				})
				.action_({ | me |
					fileIndex = me.value;
					this.changed(\file)
				}),
				ListView() // List 2: Select snippet
				.addNotifier(this, \file, { | n |
					snippets = this.new(folders[folderIndex][1][fileIndex]);
					n.listener.items = snippets.all collect: _.name;
					n.listener.doAction;
				})
				.addNotifier(this, \userEdited, { | n |
					n.listener.valueAction_(0);
				})
				.action_({ | me |
					snippetIndex = me.value;
					this.changed(\snippet)
				})
				// On keyboard return: run selected snippet
				.enterKeyAction_({ | me |
					"the enter key was pressed".postln;
				})
			),
			[
				VLayout(
					[
						TextView() // full code of file: all snippets
						.addNotifier(this, \snippet, { | n |
							n.listener.string = snippets.source;
							edited = false;
						}) // on edit per keyboard mark as changed
						.keyDownAction_({ | me, char, modifiers, unicode, keycode, key |
							[me, char].postln;
							edited = true;
							me.defaultKeyDownAction(
								char, modifiers, unicode, keycode, key
							);
						})

						// on mouse leave, save changes
						.mouseLeaveAction_({ | me |
							if (edited) {
								snippets.source = me.string;
								snippets.getSnippetsFromSource;
								postf("was edited. saving to path:\n%\n", snippets.path);
								this.changed(\userEdited);
								/*
								snippetIndex = 0;
								this.changed(\snippet;)
								*/
							}{
								// "was NOT edited, WILL NOT save".postln;
							}
						})
						, s: 5
					],
					StaticText()
					.addNotifier(this, \snippet, { | n |
						n.listener.string = snippets.all[snippetIndex].code;
					})
				) , s: 2]
		);
		this.changed(\folders);
		^window;
	}

	*readFolders {
		folders = this.snippetFolders collect: { | p |
			[p, (p +/+ "*.scd").pathMatch]
		};	
	}
}