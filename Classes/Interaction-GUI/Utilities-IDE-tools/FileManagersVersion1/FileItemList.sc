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
		^Platform.userAppSupportDir +/+ path ++ ".sctxar";
	}

	save {
		this.writeArchive(path);
		postf("Saved file list to: %\n", path);
	}

	add { | item |
		super add: item;
		this.save;
		this.changed(\add, item);
	}

}