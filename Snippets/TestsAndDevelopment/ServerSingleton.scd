//:Server as Singleton
// Prototype 11 Aug 2019 18:18
//:
//Registry.put(S, \default, Server.default);
//S.class
S.serverRunning;
//:
S.default;
//:
\test.addNotifier(S.default, \newAllocators, { | n |
	postf("new allocators: %\n", n);
}
