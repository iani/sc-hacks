//: amp sliders  for the performance
\amps.tr_.v(
	Slider().action_({ | me | postf("pv1 %\n", me.value) }),
	Slider().action_({ | me | postf("pv2 %\n", me.value) }),
	Slider().action_({ | me | postf("pv3 %\n", me.value) }),
	Slider().action_({ | me | postf("pv4 %\n", me.value) }),
);
//:
\amps.tr_(500).v(
	\amp.slider([0, 3].asSpec, \pv1, "pv1 amp"),
	\amp.slider([0, 3].asSpec, \pv2, "pv2 amp"),
	\amp.slider([0, 3].asSpec, \pv3, "pv3 amp"),
	\amp.slider([0, 3].asSpec, \pv4, "pv4 amp"),
);