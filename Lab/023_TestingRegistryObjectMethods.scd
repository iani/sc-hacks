// 5 Oct 2017 23:05
// Test at_, put_, get_, free_

10.get_(\primes, \ten, { 10.nthPrime });
//:
Library.at(\primes);
//:
Library.at(\primes, 10);

//:
Library.at(\primes, 10, \ten);
//:
10.at_(\primes, \ten);
//:
10.free_(\primes, \ten);
//:
Library.at(\primes);
//:
1000.put_(\primes, \bigtest, "ERROR");
//:
Library.at(\primes);
//:
Library.at(\primes, 1000);
//:
Library.at(\primes, 1000, \bigtest);
//:
1000.at_(\primes, \bigtest);
//:
1000.at_(\primes);
//:
1000.put_(\primes, \bigtest, "ERROR-CHANGED");
//:
1000.at_(\primes, \bigtest);
