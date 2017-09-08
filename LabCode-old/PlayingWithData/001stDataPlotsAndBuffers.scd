// 18 Jul 2017 23:31
//:
Data.at (1).x;
Data.at (1).vliData.size;
Data.at (1).x.size;

Server.default.scope;

PathName.tmp;
//:
b = Buffer.loadCollection (
	Server.default,
	Data.at (1).vliData.flat.normalize,
	3,
	{ | b  | b.play }
);

//:
Data.at (2).buffer;

// ================================================================
// exploring the sudden transition from negative to positive values observed

//:
Data.at (1).x.maxItem;
Data.at (1).x.detect ({|n| n > 0 });

n = Data.at (1).x.normalize (-1.0, 1.0);

p = n.detect ({|n| n > 0 });

n indexOf: p;

n [33700..33725]

Data.at (1).x.normalize.minItem;


Data.at (1).x.maxItem - Data.at (1).x.minItem;

b = Data.at (1).nxbuffer;

b.play;

Data.at (1).x.plot;

Data.at (1).vliData.plot;