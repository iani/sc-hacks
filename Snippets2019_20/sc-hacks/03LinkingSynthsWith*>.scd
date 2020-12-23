//:watch group and synth order
Server.default.plotTree;
//:connect i/o between two players
\source *> \effect;
//:play something in the source player
{ WhiteNoise.ar(0.1) } +> \source;
//:play something in the effect player
{ Resonz.ar(In.ar(\in.kr), \freq.kr(440), \bwr.kr(0.1)).stereo * 5 } +> \effect;
//:change a parameter of the effect player
\freq <+ (660 * 3);
//:change again
\freq <+ (660 * 2;)
//:try connecting+playing in a single code block
\source2 *> \effect2;
//play something in the source player
{ WhiteNoise.ar(0.2) } +> \source2;
//play something in the effect player
{ Resonz.ar(In.ar(\in.kr), LFNoise0.kr(5).range(200, 2000), \bwr.kr(0.001)).stereo * 40 } +> \effect2;
//:order with glitch (!!!)
// This order has a glitch of < 0.1 secs in the beginning
// It would require complicated code to fix. Left unfixed for now.

//play something in the source player
{ WhiteNoise.ar(0.2) } +> \source3;
//play something in the effect player
{ Resonz.ar(In.ar(\in.kr), LFNoise0.kr(5).range(200, 2000), \bwr.kr(0.05)).stereo * 4} +> \effect3;
// connect source and effect
\source3 *> \effect3;
//:Order without glitch
// connect the synths before starting them
\source4 *> \effect4;
//play something in the effect player
{ Resonz.ar(In.ar(\in.kr), LFNoise1.kr(5).range(200, 2000), 0.001).stereo * 40 } +> \effect4;
//play something in the source player
{ WhiteNoise.ar(0.2) } +> \source4;
//:Test all possible linking orders
// observe glitches at the beginning of permutations 1, 2, 4.
{
	var order, link, source, effect, lines, makecode;
	order = (0..2);
	link = "'source%' *> 'effect%';\n";
	source = "{ WhiteNoise.ar(0.2) } +> 'source%';\n";
	effect = "{ Resonz.ar(In.ar('in'.kr), LFNoise0.kr(7).range(400, 2000), 0.001).stereo * 40 } +> 'effect%';\n";
	lines = [link, source, effect];
	makecode = { | index, permutedLines |
		var theCode;
		theCode = "";
		permutedLines do: { | line |
			theCode = theCode ++ format(line, index, index);
		};
		theCode.postln;
	}; 
	24.do({|i|
		var permuted;
		permuted = lines.permute(i);
		postf("\ntesting permutation: %\n\n", i);
		makecode.(i % 6, permuted).interpret;
		3.wait;
		CmdPeriod.run;
		1.wait;
	});
}.fork;