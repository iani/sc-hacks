// 17 Oct 2017 17:41
// Independent class managing a list of FileItems.
// GUI classes can use this class in different ways as their model in MVC manner.

FileItemList : List {
	var <>path;
	*load { | path |
		// load new instance from data stored in .sctxar file
		^path.doIfExists({
			Object.readArchive(path).path_(path);
		},{
			postf("path not found: %\n", path);
			this.new.path_(path);
		})
	}

	*loadAS { | path|
		// load from application support. Provide AS part.
		^this.load(this.appSupportPath(path));
	}

	*appSupportPath { | path |
		^Platform.userAppSupportDir +/+ path.asString ++ ".sctxar";
	}

	save {
		this.writeArchive(path);
		postf("Saved file list to: %\n", path);
	}

	*add { | item, listName = \default |
		this.get_(\fileLists, listName,  { this.loadAS(listName) }).add(item)
	}

	add { | item |
		super add: item;
			this.save;
			this.changed(\add, item);
	}

	/*
		// Avoid adding duplicate items with the same path. 
		// This implementation can be used for cases such as adding buffers or startup files.
        // However, for data files we may want to add several copies of the same path,
		// in order to use different loading versions for each copy.
	add { | item |
		// Item is a kind of FileItem.
		// It will not be added if a FileItem with the same path exists already.
		var itemPath;
		if (this.containsItemPath(item.path)) {
			postf("Path already exists. Skipping %\n", item.path);
		}{
			postf("Adding item. Path: %\n", item.path);
			super add: item;
			this.save;
			this.changed(\add, item);
		}
	}
	*/

	containsItemPath { | itemPath |
		^array.detect({ | i | i.path == itemPath }).notNil;
	}

}