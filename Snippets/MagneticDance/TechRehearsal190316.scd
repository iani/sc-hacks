//: 16 Mar 2019 17:07
// connect /pi5
OSCFunc({ | msg |
	Nymphs.clients do: { | client |
		client.sendMsg('/pi5', *msg);
	};
}, '/pi5');
//: 16 Mar 2019 17:07
// connect /pi5
OSCFunc({ | msg |
	Nymphs.clients do: { | client |
		client.sendMsg('/pi6', *msg);
	};
}, '/pi6');
//:

Nymphs.getClients;

Nymphs.clients;

//:
OSCFunc.trace(true);
