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
// ================================================================
//:
\default.play;
~windowFunc = {
	var w, spec;
	spec= \freq.asSpec;
	w = Window(format ("try closing me! %", ~name), Rect(100.rand, 300.rand, 100 + 200.rand, 50 + 300.rand));
	w.view.layout = VLayout(
		Slider().orientation_(\horizontal)
		.action_({ | me |
			~freq = spec.map(me.value);
		})
		.value_(spec.unmap(~freq))
	);
	w;
};
//:
{
	loop {
		\default.ev.get_(\windows, ~name = \window1, ~windowFunc).front;
		2.wait;
		\default.ev.get_(\windows, ~name = \window2, ~windowFunc).front;
		2.wait;
	}
}.fork(AppClock)