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
\writer2.e[\target];
\reader2.e[\target];
\writer2.e[\target] isBefore: \reader2.e[\target];
\reader2.e[\target] isBefore: \writer2.e[\target];
//: continuing above
\reader2 *> \reader2;
//: 5. Testing *> vs *<
\writer1a *> \reader1a;
\writer2a *> \reader1a;
\writer1b *< \reader1b;
\writer1b *< \reader2b;
\writer1a.e.busses;
\writer1a.e[\out];
\writer2a.e[\out];
\writer1a.e[\out];
\reader1a.e[\out];
//:
\writer1b.e[\out];
\reader1b.e[\out];
\reader2b.e[\out];