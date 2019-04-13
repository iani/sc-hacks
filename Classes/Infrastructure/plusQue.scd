/*  9 Apr 2019 10:37

Create functions for loading synthdefs and buffers to the server with ServerDone.

*/

+ SynthDef {
	que { | serverDone |
		serverDone add: { | argServerDone |
			this.send(Server.default, { argServerDone.nextAction });
		}
	}
}

+ String {
	que { | name, serverDone |
		name ?? {
			name = PathName(this).fileNameWithoutExtension;
		};
		serverDone add: { | argServerDone |
			this.send(Server.default, { argServerDone.nextAction });
		};
	}
}
