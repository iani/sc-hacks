// 17 Oct 2017 17:41
// Independent class managing a list of FileItems.
// GUI classes can use this class in different ways as their model in MVC manner.

FileItemList : List {
	*load { | path |
		// load new instance from data stored in .sctxar file
	}
	
}