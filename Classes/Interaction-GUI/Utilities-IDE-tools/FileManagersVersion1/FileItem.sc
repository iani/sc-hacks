// 15 Oct 2017 16:34
// Store file path along with other useful item information, such as:
// selected: should this item be loaded when loading all
// name: the display name - generated from the path.
//
// Subclasses can add more items such as:
// DataFileItem:
// readActionCode: Code of the function to perform in order to read the data stored in the file.
// readAction: the compiled code of readActionCode, as function.

FileItem {
	var <path, <>active = true;
	var <name; // Symbol
	var <customFields; // Event for storing custom fields (variables) in various applications.

	*new { | path |
		^this.newCopyArgs(path).init
	}

	init {
		name = path.asName;
		// if path does not exist, mark item as inactive:
		path.doIfExists({}, active = false);
		customFields = ();
	}
	
	asName { ^name }

	getContents { | action |
		// If the file is found, then get the contents and pass them as argument to the action.
	}

	load { | action |
		// If the file is found, then load it.
		// The action argument provides the function to use for loading.
		// For example: Compile code, pass contents to load function, etc.
		// (action argument instead of method overwrite in subclass seems better.)
		// The plan is to let the GUI part provide the action.
		
	}
}