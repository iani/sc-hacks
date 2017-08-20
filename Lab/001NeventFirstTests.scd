
\test.envir;

\test0 before: \test;

\testxx before: \testx;

\testx.envir;

\testxx.envir;

\test before: \testxx;
//:
OrderedGroup.all;
//:
Server.default.queryAllNodes;
//:
Registry.at(Nevent.libRoot).keysValuesDo({ | key, value |
	[key, value[\target]].postln;
})
//:
/*

[ test, Group(1002) ]
[ test0, Group(1001) ]
[ testxx, Group(1001) ]
[ testx, Group(1000) ]

*/
*/