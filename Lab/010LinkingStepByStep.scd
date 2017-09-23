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
