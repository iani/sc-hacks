//:manually
\default.watch(\test, { |...args| args.postln;});
{
	loop {
		\default.envir.put(\test, 1000.rand);
		0.25.wait;
	};	
}.fork;
//:with gui;
\default.watch(\freq, { | freq, n |
	n.listener.put(\test, freq * 100);
});
\default.v(
	\freq.slider;
);
//:
currentEnvironment;