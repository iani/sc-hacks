// 21 Mar 2019 15:45
//:start unconnected
IDE_Fantasy startLocally: \stanford;
//:
IDE_Fantasy.busnames;

//:Code loading of script at end of start
(PathName(IDE_Fantasy.filenameSymbol.asString).pathOnly ++ "IDE_Fantasy_Script.scd");

//:find bus names to play with
IDE_Fantasy.busnames;
//:check value of one bus
\stanford1ax.get;
//:use bus for control - step 1
{
	SinOsc.ar(\stanford1ax.kr(400) + 100 * 5, 0, 0.1)
} +> \sinetest;
//:step 2: map bus to control param in synth player
\stanford1ax <+ \stanford1ax;
//:name control parameter more appropriately
{
	SinOsc.ar(\freq.kr(400) + 100 * 5, 0, 0.1)
} +> \sinetest;
//:map bus to new parameter name
\freq <+ \stanford1ax;
//: