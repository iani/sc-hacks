//: 23 Dec 2020 10:04
/* Sound dir?

*/
//:resource dir
Platform.resourceDir;
//:Where is the sounds dir?
Platform.resourceDir.matchType("*");
//: testing Platform defaults  - to build sound defaults based on these:
Platform.userAppSupportDir; // -> "/home/iani/.local/share/SuperCollider"
Platform.systemAppSupportDir; // -> "/usr/share/SuperCollider"
//:This is the proposed dir - we need to provide it as default
// and add a mechanism for selecting and adding more dirs:
// "/usr/share/SuperCollider/sounds"

