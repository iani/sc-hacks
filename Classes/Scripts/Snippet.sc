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
		code = code ++ if (code.size == 0) { "" }{ "\n" } ++ string;
	}
}

SnippetList {
	classvar <folders, <folderIndex, <fileIndex, <snippetIndex = 0, <snippets;
	classvar <edited;
	var <path, // path of file containing snippets
	<all,      // array of snippets created from code in file
	<>source,   // full source code from which snippets were made
	<name,     // name of file from which snippets were read
	<preloadSnippets; // preload marked snippets once only, before running first item.

	*initClass {
		StartUp add: {
			/* open gui only if qt is available.  Avoid opening gui
				on platforms with no XWindows or qt support, to prevent errors.
			*/
			if (thisProcess.platform.defaultGUIScheme === \qt) {
				this.gui;
			};
			ServerQuit add: {
				// When server quits, reload current file to remake preload snippets
				this.changed(\file);
			}
			
		}
		
	}
	
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
		all = [];
		source.split($
		) do: { | l |
			if ("^//:" matchRegexp: l) {
				all = all add: snippet;
				snippet = Snippet(l[3..], "");
				if("^preload" matchRegexp: snippet.name) {
					preloadSnippets = preloadSnippets add: snippet;
				}
			}{
				snippet addCode: l;
			};
		};
		all = all add: snippet;
	}

	save {
		File.use(path, "w", { | f |
			f.write(source);
		});
	}

	*gui {
		// this.window(\gui, Rect(200, 200, 800, 600));
		
		this.window({ | window |
			this.makeWindow(window)}, \gui, Rect(200, 250, 1000, 600)
		);
	}

	*makeWindow { | window |
		// Reread current file when entering window:
		// This synchronizes file contents with possible edits
		// by user on different editor.
		window.view.mouseEnterAction_({ this.changed(\file) });
		window.layout = HLayout(
			VLayout(
				PopUpMenu() // Popup: Select folder =============================
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
				ListView() // List 1: Select file ================================
				.keyDownAction_({ | me, char, modifier ... args |
					if (char === $\r) {
						switch (modifier,
							0, { Document.open(folders[folderIndex][1][fileIndex]); },
							131072, { this.loadStartup; }
						);
						me.defaultKeyDownAction(char, modifier, *args);
					};
				})
				.selectedStringColor_( Color.white )
				.focusColor_(Color.red)
				.addNotifier(this, \folder, { | n |
					n.listener.items = folders[folderIndex][1] collect: { | p |
						PathName(p).fileNameWithoutExtension;
					};
					n.listener.doAction;
				})
				.action_({ | me |
					me.value !? {
						fileIndex = me.value;// ? 0;
						this.changed(\file);
					}
				}),
				ListView() // List 2: List of snippets in selected file ==========
				.hiliteColor_(Color.red)
				.focusColor_(Color.red)
				.addNotifier(this, \file, { | n |
					if (folders[folderIndex][1].size > 0) {
						snippets = this.new(folders[folderIndex][1][fileIndex]);
						n.listener.items = snippets.all collect: _.name;
					// keep previously selected snippet if possible:
						n.listener.valueAction_(snippetIndex min: (n.listener.items.size - 1));
					}{
						postf("folder is empty: %\n", folders[folderIndex]);
					}
				})
				.addNotifier(this, \userEdited, { | n |
					n.listener.items = snippets.all collect: _.name;
					n.listener.valueAction_(snippetIndex min: (n.listener.items.size - 1));
				})
				.action_({ | me |
					snippetIndex = me.value;
					this.changed(\snippet)
				})
				// On keyboard return: run selected snippet
				.enterKeyAction_({
					// snippets.all[snippetIndex].code.interpret;
					// new version to test:
					snippets.runSnippet;
				}),
				HLayout(
					Button().states_([["Boot Server"], ["Quit Server"]])
					.action_({| me |
						[{ Server.default.boot }, { Server.default.quit} ][
							1 - me.value
						].value
					})
					.focusColor_(Color.red)
					.addNotifier(Server.default, \counts, { | n |
						n.listener.value = 1;
					})
					.addNotifier(Server.default, \didQuit, { | n |
						n.listener.value = 0;
					}),
					Button().states_([["Stop all"]])
					.action_({ CmdPeriod.run })
					.focusColor_(Color.red),
					Button().states_([["Read Folders"]])
					.action_({ this.changed(\folders) })
					.focusColor_(Color.red),
					Button().states_([["Recompile"]])
					.action_({ thisProcess.platform.recompile; })
					.focusColor_(Color.red)
				)
			),
			[
				VLayout(
					[
						TextView() // full code of file: all snippets
						.tabWidth_(30)
						.font_(Font("Courier", 11))
						.addNotifier(this, \snippet, { | n |
							n.listener.string = snippets.source;
							// n.listener.syntaxColorize; // syntaxColorize does not work?
							// edited = false;
						}) // on edit per keyboard mark as changed
						.focusColor_(Color.red)

						/*
						.keyDownAction_({ | me, char, modifiers, unicode, keycode, key |
							edited = true;
							me.defaultKeyDownAction(
								char, modifiers, unicode, keycode, key
							);
						})
						*/
						// on mouse leave, save changes
						.mouseLeaveAction_({ | me |
							/*	if (edited) { */
							// if (true) {
							// string obtained from view
							snippets.source = me.string;
							snippets.getSnippetsFromSource;
							// postf("was edited. saving to path:\n%\n", snippets.path);
							snippets.save;
							// snippets = 
							this.changed(\userEdited);
							// }{}
						})
						, s: 5
					],
					StaticText()
					//.tabWidth_(30)
					.font_(Font("Courier", 14/*, true */))
					.background_(Color(0.92, 0.92, 0.92))
					.stringColor_(Color.red)
					.addNotifier(this, \snippet, { | n |
						n.listener.string = snippets.all[snippetIndex].code;
					})
				) , s: 2]
		);
		this.changed(\folders);
		^window;
	}

	runSnippet {
		/*  Run snippets marked with "preload" in this file just once
			before the first execution of any snippet. 
			Useful for preloading buffers.
			Weit after each preload snippet to give time for buffers to initialize.
			Restore current environment, because forking executes the routine in 
			own pushed one. 
		*/
		var newEnvir;
		if (preloadSnippets.isNil) {
			all[snippetIndex].code.postln.interpret;
		}{
			Server.default.waitForBoot({
				3.wait; // Need to wait for Buffer::read to provide buffers with info
				preloadSnippets do: { | snippet |
					snippet.code.postln.interpret;
					1.5.wait; // make sure info has reached all buffers
				};
				all[snippetIndex].code.postln.interpret;
				newEnvir = currentEnvironment;
				preloadSnippets = nil; // cancel preloads.
				{ newEnvir.push }.defer(0.001);
			}.fork(AppClock);)
			
		}
	}

	/*
		// simpler version without wait.
		// occasionally playbuf synths will fail because number of channels is not yet known?
	runSnippet {
		/*  Run snippets marked with "preload" in this file just once
			before the first execution of any snippet. 
			Useful for preloading buffers.
		*/
			preloadSnippets do: { | snippet |
				snippet.code.postln.interpret;
			};
			all[snippetIndex].code.postln.interpret;
			preloadSnippets = nil; // cancel preloads.
	}
	*/
	*readFolders {
		folders = this.snippetFolders collect: { | p |
			[p, (p +/+ "*.scd").pathMatch]
		};	
	}

	*loadStartup {
		"loading startup:".postln;
		folders[folderIndex][1][fileIndex].postln;
		CmdPeriod.run; // stop synths + routines + patterns
		Server.quit;
		/* must remove following keys from Library.global:
			- environments
			- buffers
			
		*/
	}
}