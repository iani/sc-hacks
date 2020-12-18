// 23 Sep 2017 23:15
//: 1: Making PeristentBusProxies.
~reader1 = \reader1 @ \in;
~writer1 = \writer1 @ \out;
//: 2: Linking PersistentBusProxies.
~writer1 *> ~reader1;
//: 3. testing the resulting groups and busses after the linking.
~writer1.envir[\target];
~reader1.envir[\target];
~writer1.envir[\target] isBefore: ~reader1.envir[\target];
~reader1.envir[\target] isBefore: ~writer1.envir[\target];
//: 4. Testing unpermitted adding of reader to self
~reader1 *> ~reader1;
//: Start testing as above, with symbols instead of PersistentBusProxies.
\writer2 *> \reader2;
//: continuing above
\writer2.ev[\target];
\reader2.ev[\target];
\writer2.ev[\target] isBefore: \reader2.ev[\target];
\reader2.ev[\target] isBefore: \writer2.ev[\target];
//: continuing above
\reader2 *> \reader2;
//: 5. Testing *> vs *<
\writer1a *> \reader1a;
\writer2a *> \reader1a;
\writer1b *< \reader1b;
\writer1b *< \reader2b;
\writer1a.ev.busses;
\writer1a.ev[\out];
\writer1a.ev;
\writer2a.ev[\out];
\writer1a.ev[\out];
\reader1a.ev[\out];
//:
\writer1b.ev[\out];
\reader1b.ev[\out];
\reader2b.ev[\out];
//: 6. Testing with sound a: many to 1 (*>)
\writer1a *> \reader1a;
\writer2a *> \reader1a;
//:
{ WhiteNoise.ar(Decay2.kr(Impulse.kr(0.5), 0.2, 0.5, 0.1)) } +> \writer1a;
{ Ringz.ar(In.ar(\in.kr), LFNoise1.kr(10.1).range(300, 1000), 0.02, 0.5) } +> \reader1a;
{ WhiteNoise.ar(Decay2.kr(Impulse.kr(5), 0.02, 0.15, 0.1)) } +> \writer2a;
//: 7. Testing with sound b: 1 to many (*<)
\writer1b *< \reader1b;
\writer1b *< \reader2b;
//:
{ WhiteNoise.ar(0.01) } +> \writer1b;
{ Ringz.ar(In.ar(\in.kr), LFNoise1.kr(0.5).range(300, 1000), 0.02, 0.5) } +> \reader1b;
{ Ringz.ar(In.ar(\in.kr), LFNoise0.kr(10.5).range(1300, 2000), 0.02, 0.5) } +> \reader2b;
//:
(dur: 0.5, legato: 0.5).playFunc({ WhiteNoise.ar(0.02) }) +> \writer1b;
(dur: 6, freq: Pbrown(40, 60, 10).midicps).playFunc({ Ringz.ar(In.ar(\in.kr), \freq.kr, 0.2, 0.05) }) +> \reader1b;
(legato: 1.95) +> \reader1b;
(dur: 0.2, legato: 5, freq: Pbrown(90, 100, 10).midicps).playFunc({ Ringz.ar(In.ar(\in.kr), \freq.kr, 2, 0.05) }) +> \reader1b;

\reader2b.stop;
//:
(addMethod: \addAfter) +> \writer1b;
//:
\writer1b.ev[\target];
//:
\writer1b.ppp.stream.event;
//:
~g = Group();
//:
e = EventPattern((amp: 0.01)).play;
e.put(\freq, 1000);
e.put(\group, ~g);
//:
Event