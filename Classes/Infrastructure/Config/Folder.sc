/*  2 Dec 2020 10:07
Managing commonly used lists of files and folders.
Possibly later also of Buffers and other stuff.
*/

Folder : NamedSingleton {
	/* Store the path of a folder.
		Permit operations on this folder: 
		- Browse the folders and files that it contains, 
		- Select one or more of these contents and
		- Perform some actions on these.
	*/
	var <path;
	var <selectedFiles; // Array of files in this folder,
	// selected by the user
	// Used for storing and for performing various operations with them,
	// such as loading audio files etc.

	prInit { | argPath |
		path = argPath;
	}

	openDialog {
		FileDialog({ | chosenPath |
			chosenPath.postln;
			path = chosenPath;
			postf("Folder % has now path: %\n", name, path);
		}, fileMode: 2);
	}

	showFileList {
		// Open a list view showing all files in this folder
		
	}
}