/* 15 Jul 2018 16:43
	Compose the startup file from multiple includes.
	Select startup file configuration from a list of files via GUI.
*/

StartupFiles {
	/*
		//	classvar <startupFile;       // path of file to run on startup.
		classvar <startupFolder;     // path of folder containing startup scripts
		classvar <startupScripts;    // names of all files in Startups folder
		classvar <userSelectionPath; // path of file holding name of script selected by user
		classvar <selectedScript;    // name of script selected by user
	*/
	*initClass {
		/* At startup, get the startup scripts from the Startup folder,
			and the last saved startup script selection.
			Then load the last saved startup file. */
		StartUp add: {
			// boot server if needed, and then call loadStartupFile after booting:
			this.loadServerSetup;
			this.gui;
		}
	}

	*loadServerSetup {
		/* load StartupServer.scd
			If Include.server statements been included, in config script,
			then StartupServer encloses loadStartupFile in a server.waitForBoot function.
			Else it merely calls "StartupFiles.loadStartupFile;".
		*/
		this.loadServerFile;
	}

	*loadServerFile {
		this.loadIfExists(this.serverFile);
	}
	
	*serverFile {
		^Platform.userAppSupportDir +/+ "serverStart.scd";		
	}

	*loadStartupFile {
		this.loadIfExists(this.startupFile);
	}

	*loadIfExists { | argPath |
		argPath.doIfExists { | path |
			"================================================================".postln;
			postf("Loading \n%\n", path);
			path.load;
			"================= DONE ===============================================".postln;
		}{ | path |
			postf("Could not find:\n%\nat startup\n", path)
		};
	}

	*startupFile {
		^Platform.userAppSupportDir +/+ "startup1.scd";
	}

	*gui {
		this.window({ | window |
			this.makeWindow(window)}, \gui, Rect(0, 0, 350, 200)
		);
	}

	*makeWindow { | window |
		// window = Window("Startup Scripts", Rect(0, 0, 350, 200));
		window.layout = VLayout(
			// list of files in Startups folder
			ListView() 
			.action_({ | me |
				this.changed(\selectedScript, me.items[me.value]);
			})
			.addNotifier(this, \scriptList, { | list, notification |
				notification.listener.items = list.collect({ | path |
					PathName(path).fileNameWithoutExtension;
				});
				notification.listener.doAction;
			})
			.addNotifier(this, \installScript, { | notification |
				this.installScript(
					notification.listener.items[notification.listener.value]
				)
			})
			.keyDownAction_({ | me, char ... args |
				if (char === $\r) {
					Document.open(this.scripts[me.value])
				};
				me.defaultKeyDownAction(char, *args);
			}),
			HLayout(
				// Button to install currently installed script
				StaticText() 
				.maxHeight_(18)
				.addNotifier(this, \currentlyInstalled, { | installed, notification |
					notification.listener.string = format("Installed: %", installed)
				}),
				// Button to install currently selected script
				Button()
				.states_([["run"]])
				.action_({ this.loadServerFile })
				.maxHeight_(18).maxWidth_(50)
			),
			HLayout(
				// Display name of currently selected script
				StaticText() 
				.maxHeight_(18)
				.addNotifier(this, \selectedScript, { | script, notification |
					notification.listener.string = format("Selected: %", script)
				}),
				Button()
				.states_([["install"]])
				.action_({ this.changed(\installScript)})
				.maxHeight_(18).maxWidth_(50)
			),	
			// Button to refresh script list from folder
			Button()
			.states_([["update script list"]])
			.action_({ this.updateScriptList; })
			.maxHeight_(18),
		);
		window.front;

		// ================================================================
		// Update window contents
		// ================================================================
		this.updateScriptList;
		this.readInstalledScriptName;
		^window;
	}

	*updateScriptList {
		this.changed(\scriptList, this.scripts);
	}

	*scripts {
		^pathMatch(PathName(this.filenameSymbol.asString).pathOnly +/+ "Startups/*.scd")	
	}

	*readInstalledScriptName {
		this.userInstalledScriptPath.doIfExists({ | path |
			this.changed(\currentlyInstalled,
				PathName(Object.readArchive(path)).fileNameWithoutExtension);
		},{
			this.changed(\currentlyInstalled, "-")	
		})
	}

	*installScript { | script |
		(this.startupFolderPath ++ script ++ ".scd").doIfExists({ | path |
			{
				// "RESETTING INCLUDES".postln;
				Include.reset;
				postf("Loading Script: \n%\n", path);
				path.load;
				// postf("loaded script file now: \n%\n", path);
				// Include.all.postln;
				Include.all do: { | i |
					postf("\nGetting Contents of include: %\n", i.fileName);
					i.getContents;
				};
				// Include.all do: { | i | i.fileName.postln; i.contents.postln; };
				1.wait;
				// postf("should create startup file now: \n%\n", StartupFiles.startupFile);
				File.use(this.serverFile, "w", { | file |
					file.putString("\n\n//============================================");
					file.putString(
						format("\n// Server setup created from script '%' on: %",
							script,
							Date.localtime.stamp
						)
					);
					file.putString("\n//===============================================\n");
					file.putString(Include.makeServerCode);
				});
				//1.wait;
				File.use(this.startupFile, "w", { | file |
					Include.all do: { | i |
						//		postf("contents of include are:\n%\n", i.contents).postln;
						file.putString(i.contents);
					};
					file.putString("\n\n//============================================");
					file.putString(format("\n// Startup created from script '%' on: %",
						script,
						Date.localtime.stamp));
					file.putString("\n//===============================================");
				});
				postf("script installed: \n%\n", path);
				script.writeArchive(this.userInstalledScriptPath);
				this.changed(\currentlyInstalled, script);
			}.fork(AppClock);
		},{ | path |
			postf("Script not found: \n%\n", path)
		})
	}

	*startupFolderPath {
		^PathName(this.filenameSymbol.asString).pathOnly ++ "Startups/"
		//	^Registry(\paths, \startupFolder, )
	}

	*userInstalledScriptPath {
		^Platform.userAppSupportDir +/+ "UserStartupScriptName.sctxar"
	}

}
