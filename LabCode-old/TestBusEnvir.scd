// 14 Jul 2017 23:36
// First test adding common busses to Nevent environments.

{ Out.ar (\out.kr (0), WhiteNoise.ar (0.1)) } +> \source;

//:
Server.default.queryAllNodes;
/*
NODE TREE Group 0
   1 group
      1009 group
         1010 temp__0
      1008 group
      1007 group
      1006 group
      1005 group
      1004 group
      1003 group
      1002 group
      1001 group
      1000 group
*/
//:
~out = 10;
//:
{ LPF.ar (In.ar (\in.kr (0)), LFNoise1.kr (15).range (50, 5000)) } +>.fx \lpf;
//:
currentEnvironment;
//:
~in = 10;
// ================================================================
//: Retry in other order
{ Out.ar (\out.kr (0), WhiteNoise.ar (0.1)) } +>.0 \source;
//:
{ LPF.ar (In.ar (\in.kr (0)), LFNoise1.kr (15).range (50, 5000)) } +>.1 \lpf;
//: send a number to a parameter in a prescribed environment (without pushing it):
4 =>.0 \out; // addressing environments per index.  Name is also acceptable.
//:
4 =>.1 \in;
// ================================================================
//: Retry with addSharedBus
{ Out.ar (\out.kr (0), WhiteNoise.ar (0.1)) } +>.0 \source;
//:
{ Ringz.ar (In.ar (\in.kr (0)), LFNoise0.kr ([3, 4]).range (250, 5000), 0.1, 0.1) } +>.1 \ringz;
//: 0.asEnvironment addSharedBus: 1.asEnvironment;
0 &> 1;
//:
{ Out.ar (\out.kr (0), GrayNoise.ar (0.1)) } +>.0 \source;
//:

