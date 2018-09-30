// Tests

\default.v(
	\freq.slider()
);

\freq <+.default \test.osc;
//:
NetAddr.localAddr.sendMsg(\freq, 500);
//:
