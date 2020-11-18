//:saw shape
{ Out.kr(0, LFSaw.kr(0.2)) } +> \cm1;
//:copy signal into another bus (for testing)
{ Out.kr(1, In.kr(0)) } +> \cm2;
//:reverse (mirror) saw shape
//(Use original saw from previous synth as input)

//:Pass only positive part

//:Pass only negative part

//:mirror only negative part;

//:change period of source signal
{ Out.kr(0, LFSaw.kr(1)) } +> \cm1;
