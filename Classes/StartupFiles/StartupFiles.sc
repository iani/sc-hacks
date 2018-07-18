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
			this.startupFile.doIfExists { | path |
				path.load;
			}{ | path |
				postf("Could not find:\n%\nat startup\n", path)
			};
			this.gui;
		}
	}

	*startupFile {
		^Platform.userAppSupportDir +/+ "startup1.scd";
	}

	*gui {
		Registry(this, \gui, {
			this.makeWindow;
		}).front;
	}

	*makeWindow {
		var window;
		window = Window("Startup Scripts", Rect(0, 0, 250, 300));
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
			}),
			// Display name of currently installed script
			StaticText() 
			.maxHeight_(24)
			.addNotifier(this, \currentlyInstalled, { | installed, notification |
				notification.listener.string = format("Installed: %", installed)
			}),
			StaticText() 
			.maxHeight_(24)
			.addNotifier(this, \selectedScript, { | script, notification |
				notification.listener.string = format("Selected: %", script)
			}),
			// Button to install currently selected script
			HLayout(
				Button()
				.states_([["install selected"]])
				.action_({ this.changed(\installScript)})
				.maxHeight_(18),
				Button()
				.states_([["run selected"]])
				.maxHeight_(18)
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
		this.changed(
			\scriptList,
			pathMatch(PathName(this.filenameSymbol.asString).pathOnly +/+ "Startups/*.scd")
		);
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
				postf("will load script now: \n%\n", path);
				path.load;
				postf("loaded script file now: \n%\n", path);
				Include.all.postln;
				1.wait;
				postf("should create startup file now: \n%\n", path);
				postf("script installed: \n%\n", path);
				script.writeArchive(this.userInstalledScriptPath);
				this.changed(\currentlyInstalled, script);
			}.fork(AppClock);
		},{ | path |
			postf("Script not found: \n%\n", path)
		});
	}

	*startupFolderPath {
		^PathName(this.filenameSymbol.asString).pathOnly ++ "Startups/"
	}

	*userInstalledScriptPath {
		^Platform.userAppSupportDir +/+ "UserStartupScriptName.sctxar"
	}

	*makeStartupFile { | scriptName |
		/*
			A new config script has been chosen.
			Save the name of the new script.
			Load the config script, then:
			Compose the startup file from the Include instances created in the 
			currently selected startup script. 
		*/
		postf("will make startup file from this script: %\n", scriptName)
		// Run the startup script to create the Include instances:
		/*
		this.loadStartupConfig;
		// Run this in routine to pause 1 second after reading file contents:
		{
			// Rename the previous startup file to make place for the new one:
			this.renameOldStartupFile;
		// Initialize the sting contents of all Include instances:
			Include.getaAllStrings; // read strings from files
			1.wait; // wait for all files to be read and closed
			this.writeStartupFile;
		}.fork(Appclock);
		*/
	}

	*loadStartupConfig {
		this.getConfigPath.doIfExists({ | path |
			path.load;
		}, { | path |
			postf("could not fine config file: \n%\n", path);
		});
	}

	*renameOldStartupFile {
		var basePath, stamp, command;
		basePath = Platform.userAppSupportDir.escapeChar($ );
		stamp = Date.localtime.stamp;
		command = format("mv %/startup1.scd %/startup%.scd", basePath, basePath, stamp);
		command.unixCmd;
	}

	*writeStartupfile {
		File.use(this.startupFile, "w", {
			Include.writeAll2File;
		});
	}
}
