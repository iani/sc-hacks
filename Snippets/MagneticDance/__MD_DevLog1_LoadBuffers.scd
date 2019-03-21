// Devlog. 16 Mar 2019 14:17
//:Pre rehearsal dev 17 Mar 2019 13:13
//:test hamachi situation
"hamachi list".unixCmdGetStdOutLines[1..] do: { | l |
	"--------------".postln;
	l.postln;
	
};
//:
Nymphs
//:construct bus names
var busnames, buses, locations, base;
/*
	each bus must have a unique name. There are 54 buses, one per sensor:
	2                 * 3       * 9
	// pi's per perf, num perf, params per pi
	// total num params: 54.  54 names. 
	// naming convention: 
	location_num_sensor
	where:
	location is one of: stanford, corfu athens
	num is one of: 1 (=master/left) 2 (=slave, right)
	sensor is one of: 
	ax, ay, az, 
	mx, my, mz
	gx, gy, gz, 
	where a = accellerometer, m = magnetormeter, g = gyroscope

	Example: 
	\athens1ax // accelleration x of left sensor in athens
*/
// var <buses; // dict containing one bus array per pie name.
buses = ();
locations = (
	athens: [\pi1, \pi2],
	corfu: [\pi3, \pi4],
	stanford: [\pi5, \pi6]
);
locations.keys.asArray do: { | location |
	locations[location] do: { | p, num |
		base = format("%%", location, num + 1);
		buses[p] = [
			\ax, \ay, \az,
			\mx, \my, \mz,
			\gx, \gy, \gz
		].collect({ | n | format("%%", base, n).asSymbol.bus })
	}
};
buses[\pi1];
buses[\pi2];
locations.keys do: { | l |
	l.postln;
	locations[l] do: { | p | p.postln; buses[p].postln }
};
//:testing bus created by above
\corfu2gz.bus;
//:finding out which buses were created
\test.bus;
Registry.at(\busses);
\test.bus.set(123);
//:test bus value
\test.bus.get;
//:debug graphics app
NetAddr("127.0.0.1", 14000).sendMsg('/test', 1, 2, 3);
//:Testing class for 3 site setup
IDE_Fantasy start: \corfu;
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
//:Do we have busses? Yes we do
\ratebus.bus;
//:repeat: check bus numbers
\ratebus2.bus;
//:now prepare control through bus
\freqbus.bus.set(1000);
{ SinOsc.ar(\freq.kr(400) / 2, 0, 0.1 )} +> \bustest;
\freq <+ \freqbus;
//:ok control through bus works this way.
\freqbus.bus.set(400 + 1000.rand);
//: 2. Send osc sensor received data to BUSES and use buses to map to parameters but also to trigger
//: 3. Devise easily and visibly adjustable way to calibrate mapping of received sensor values to target synthesis values.
//: 4. Adjust and improve granulation synth process for more reliable performance characteristics
//: 5. Try triggering by testing gradients and peak values of busses
().play;