//:Tuple example
var addr;
addr = NetAddr.localAddr;

// Pwhite(0.4, 0.6, inf)
// Ptuple([1, 2, 2], inf)
Ptuple({Pwhite(0.4, 0.6, inf);} ! 3, inf)
.stream(\tupletestplayer,
	{ | val |
		addr.sendMsg('/test', *val)
	},
	1
);
