SnippetList {
	classvar <folders, <folderIndex, <fileIndex, <snippetIndex = 0, <snippets;
	classvar <rootDir; // root folder containing all snippet files
	classvar <snippetOnServer; /* Snippet last loaded on server boot.
		If different from that beeing run, then load its head snippets. */
	var <path, // path of file containing snippets
	<all,      // array of snippets created from code in file
	<>source,   // full source code from which snippets were made
	<name,     // name of file from which snippets were read
	<before,   // snippets to run before booting server
	<head,     // snippets to run after booting server but before everything else
	/* There is a wait of 3 seconds between server boot and the first head snippet,
		and of 1.5 seconds between head and tail snippets, to allow buffer info
		when reading buffers and before playing them.	*/
	<tail;     // snippets to run after the head snippets

	*initClass {
		StartUp add: {
			/* open gui only if qt is available.  Avoid opening gui
				on platforms with no XWindows or qt support, to prevent errors.
			*/
			if (thisProcess.platform.defaultGUIScheme === \qt) {
				this.gui;
			};
			ServerQuit add: {
				// prepare to load before and/or head snippets at next run
				snippetOnServer = nil;
			};
			rootDir = this.folderPath;
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
		// TODO: get snippets from source var. Do not reread from file.
		all = Snippet.readAll(path);
		all do: { | s |
			switch (s.type,
				\server, { before = before add: s },
				\preload, { head = head add: s },
				{ tail = tail add: s }
			);
		}
	}

	save { | newSource |
		File.use(path, "w", { | f | f.write(newSource ? source); });
	}

	*gui {
		this.window({ | window |
			this.makeWindow(window)}, \gui, Rect(250, 50, 1000, 700)
		);
	}

	*makeWindow { | window |
		// Reread current file when entering window:
		// This synchronizes file contents with possible edits
		// by user on different editor.
		window.view.mouseEnterAction_({
			this.changed(\file);
			//	this.reloadIfFileChanged

		});
		window.layout = HLayout(
			VLayout(
				ListView() // Select folder =============================
				.addNotifier(this, \folders, { | notification |
					this.readFolders;
					notification.listener.items = folders collect: { | f |
						PathName(f[0]).folderName;
					};
					notification.listener.doAction;
				})
				.maxHeight_(200)
				.action_({ | me |
					folderIndex = me.value;
					this.changed(\folder)
				}),
				ListView() // List 1: Select file ================================
				.keyDownAction_({ | me, char, modifier ... args |
					if (char === $\r) {
						switch (modifier,
							131072, { Document.open(folders[folderIndex][1][fileIndex]); },
							0, { snippets.runSnippet(snippets.tail); }
						);
						me.defaultKeyDownAction(char, modifier, *args);
					};
				})
				.maxHeight_(150)
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
						// postf("RELOADING FILE: %\n", folders[folderIndex][1][fileIndex]);
						
						// postf("% received file update.\n", n.listener);
						this.loadSnippets;
						n.listener.items = snippets.all collect: _.name;
					// keep previously selected snippet if possible:
						n.listener.valueAction_(snippetIndex min: (n.listener.items.size - 1));
					}{
						postf("folder is empty: %\n", folders[folderIndex]);
					}
				})
				.addNotifier(this, \snippets, { | n |
					/* Update selected snippet text view when new 
						snippet file is read. Issued by this.loadSnippets
					*/
					postf("% received snippets update.\n", n.listener);
						n.listener.items = snippets.all collect: _.name;
					// keep previously selected snippet if possible:
						n.listener.valueAction_(snippetIndex min: (n.listener.items.size - 1));
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
					// If on first snippet, then run all snippets
					if (snippetIndex == 0) {
						snippets.runSnippet(snippets.tail)
					}{
						snippets.runSnippet([snippets.all[snippetIndex]]);
					}
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
						})
						.focusColor_(Color.red)
						// on mouse leave, save changes
						.mouseLeaveAction_({ | me |
							if (snippets.source != me.string) {
								snippets.save(me.string);
								this.changed(\file);
							}
						})
						, s: 5
					],
					StaticText()
					// .tabWidth_(30)  // cannot set tab width of StaticText!
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

	*loadSnippets {
		// Only make snippets instance if currnt instance source has changed on file.
		var newPath, newSource;
		//	"running loadSnippets".postln;
		newPath = folders[folderIndex][1][fileIndex];
		if (snippets.isNil) {
			snippets = this.new(newPath);
		}{
			newSource = File.readAllString(newPath);
			if ( snippets.source == newSource ) {
				// do not reload file if it has not changed. 
			}{
				snippets = this.new(newPath); 
			}
		}
	}

	runSnippet { | argSnippets |
		/*  Run snippets marked with "preload" in this file just once
			before the first execution of any snippet. 
			Useful for preloading buffers.
			Weit after each preload snippet to give time for buffers to initialize.
			Restore current environment, because forking executes the routine in 
			own pushed one. 
		*/
		var newEnvir;
		if (snippetOnServer === this or: { head.size + before.size == 0 }) {
			^argSnippets do: _.run;
		};
		snippetOnServer = this;
		before do: _.run;
		this.doAfterBooting(
			{
				{
					head do: { | snippet |
						snippet.run;
						1.5.wait; // make sure info has reached all buffers
					};
					//if (argSnippet > 0) {
					argSnippets do: { | snippet |
						snippet.run;
						newEnvir = currentEnvironment;					
					};
					{ newEnvir.push }.defer(0.001);
				}.fork(AppClock)
				
			}
		);	
	}

	runSnippetAsStartup {
		before = nil; head = nil; tail = nil;
		all do: { | s |
			switch (
				s.type,
				\preload, { head = head add: s },
				\server, { before = before add: s },
				{ tail = tail add: s }		
			);
		};
		
	}

	*readFolders {
		folders = this.snippetFolders collect: { | p |
			[p, (p +/+ "*.scd").pathMatch]
		};	
	}

	*loadStartup {
		"loading startup:".postln;
		folders[folderIndex][1][fileIndex].postln;
		CmdPeriod.run; // stop synths + routines + patterns
		Server.default.quit;   // this also removes buffers from Library.
		Nevent.reset; // close and remove all Nevents.
	}
}