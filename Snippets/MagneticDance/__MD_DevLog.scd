// Devlog. 16 Mar 2019 14:17
//:TODOS 16 Mar 2019 14:17
//: 1. Load buffers - more reliable
//: load buffers from sounds - step 1
(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch
//: load buffers from sounds - step 1
Server.default.waitForBoot({
	
	var server, bname;
	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
	server = Server.default;
	
	(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch.postln;
	(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch do: { | p |
		bname = PathName(p).fileNameWithoutExtension.asSymbol;
		// PathName(p).allFolders.postln;
		Registry(\buffers, bname, {
			Buffer.read(server, p).postln;
		})
	};
	
});
//: load buffers from sounds - step 2: Testing sync.
Server.default.waitForBoot({
	
	var server, bname;
	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
	server = Server.default;
	
	(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch.postln;
	(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch do: { | p |
		bname = PathName(p).fileNameWithoutExtension.asSymbol;
		// PathName(p).allFolders.postln;
		Registry(\buffers, bname, {
			Buffer.read(server, p).postln;
		});
		server.sync;	// does not seem to work.
		// Must make my own sync. - or understdand sync better.
	};
	
});
//: load buffers from sounds - step 3: Testing if waitForBoot accepts yield/wait
// Result: function passed to waitForBoot may contain a yield.
// So I can make my own sync method.
Server.default.waitForBoot({
	
	var server, bname;
	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
	server = Server.default;
	
	(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch.postln;
	(Platform.userAppSupportDir +/+ "sounds/*.wav").pathMatch do: { | p |
		bname = PathName(p).fileNameWithoutExtension.asSymbol;
		// PathName(p).allFolders.postln;
		// 2.wait; // THIS WAS OK
		Registry(\buffers, bname, {
			Buffer.read(server, p).postln;
		});
		server.sync;	// does not seem to work.
		// Must make my own sync. - or understdand sync better.
	};
	
});
//:Test loaded buffer
\lamentodellaninfa.b.bufnum;
//play;
//:test loaded buffer 2
'lamentodellaninfa-stereo'.b.play;
//:test granulation
{
	GrainBuf.ar(1, Impulse.kr(\per.kr(1)), \dur.kr(0.5), \lamentodellaninfa.b.bufnum.postln, 1)
} +> \gran;
//:test granulation - add more parameters
{
	var bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	GrainBuf.ar(1,
		Impulse.kr(\per.kr(1)),
		\dur.kr(0.5),
		bnum,
		\rate.kr(1),
		\pos.kr(0) * BufSampleRate.kr(bnum)
	)
} +> \gran;
//:test how pos param works
\pos <+ 1;
//: test pos again. It is now sesconds
\pos <+ 2;
//: test pos again. It is now sesconds
\pos <+ 3;
//: test pos again. It is now sesconds
\pos <+ 5;
//:test rate;
\rate <+ 2.5
//:dur test
\dur <+ 5;
//:test rate;
\rate <+ 1;

//:test rate again;
\rate <+ 0.25
//:test with bus.



//: 2. Send osc sensor received data to BUSES and use buses to map to parameters but also to trigger
//: 3. Devise easily and visibly adjustable way to calibrate mapping of received sensor values to target synthesis values.
//: 4. Adjust and improve granulation synth process for more reliable performance characteristics
//: 5. Try triggering by testing gradients and peak values of busses
().play;