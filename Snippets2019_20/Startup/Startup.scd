//: 9 Sep 2019 14:15
/*
	This file can be executed with sclang-hydra-body command r (run startup script).
	Run with keyboard command [Control-shift-l, r]
*/

/* Version for Tokyo, September 9 ff.
*/

Server.default.waitForBoot({
	/* load files under Platform.userAppSupportDir ++ "/sounds/\*.wav"
			Reload buffers when rebooting the server.

	*/
	Hacks.loadAudioFiles;
	
});


/*
	// replaced by above
Server.default.waitForBoot({
	
	var server, bname;
	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
	server = Server.default;
	// (Platform.userAppSupportDir +/+ "sounds/*.wav").postln;
	(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch.postln;
	(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch do: { | p |
		bname = PathName(p).fileNameWithoutExtension.asSymbol;
		// PathName(p).allFolders.postln;
		Registry(\buffers, bname, {
			Buffer.read(server, p).postln;
		})
	};
	
});

*/
