//:  2 Dec 2020 01:12
/* prototype plotting sense data
*/
// ================================================================
// Preliminaries: File path shortcuts
//get all folders under userAppSupportDir and their paths
//:Step 1: userAppSupportDir
Platform.userAppSupportDir;
//:Step 2: everything under userAppSupportDir
"*".userPath.pathMatch;
//:Step 3: All folders under userAppSupportDir
"*".userPath.pathMatch.select({ | p | PathName(p).isFolder; })
//:Part 2: Window with 2 lists for viewing files in folders of userAppSupportDir
\test.bl_(800, 400).h(
	List(),
	List()
);
