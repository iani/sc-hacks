/*  3 Dec 2020 08:52
Manage the saving and loading of information to/from file, to store them between sessions. 

 3 Dec 2020 12:44 - stalled. First need to finish Folder class


Alternative names:

Asset
Config? 
Configs?
Persistence?????

Should be able to do the following:

- Store the data (and itself?) in the Library
- Store the same stuff on file
- Reload itself from file.

Starting the implementation with the above.

Approach:




*/

Config : NamedSingleton {
	var <>data; // these are the data that I store.

	classvar <configsDir; // the path where I store my data.
	// gets initialized at startup time.

	*initClass {
		StartUp add: {
			configsDir = Platform.userAppSupportDir +/+ "Configs";
			File.mkdir(configsDir);
		};

		ShutDown add: {
			
		}
		
	}

	/* alternative method name: write */
	store { | class |
		/*
			store your data under Configs +/+ 
			in a file named after the class name.
			Also store a backup of your data under the path
			Configs path +/+ Backups, in file under your class name +
			timestamp of now.
		*/
		
	}

	/* alternative method name: read */
	load { | class |

	}

	readData { | argPath |
		// read data from archive file at argPath;
		// return the data.
		^Object.readArchive(argPath);
	}

	writeMainFile {
		
		
	}
	writeBackupFile {
		
	}

	writeData { | argPath |
		// write out the data in archive format, in file named after argPath.
		Library.at(this.class).writeArchive(argPath);
	}
	makeBackupFolder {
		/* create folder with own name under config path +/+ Backups
			Use it to add backups with a time stamps.
			Call this from main store method, to prepare the folder
			for keeping backups.
		*/
		
	}

	
}