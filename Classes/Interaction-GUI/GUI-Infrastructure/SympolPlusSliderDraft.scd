

{ SinOsc.ar(\freq.kr(400), 0, 0.1) } +> \test;
//:
\test.window({ | w |
	w.layout = VLayout(
		HLayout(
			StaticText().string_("freq"),
			Slider()
			.orientation_(\horizontal)
			.action_({ | me |
				\test.e.put(\freq, \freq.asSpec.map(me.value))
			})
			.addNotifier(\test.e, \freq, { | freq, notification |
				notification.listener.value = \freq.asSpec.unmap (freq);
			}),
			NumberBox()
			.action_({ | me |
				\test.e.put(\freq, me.value)
			})
			.addNotifier(\test.e, \freq, { | freq, notification |
				notification.listener.value = freq;
			})
		)
	)}
)
//:
\test.e;
//: testing first version:
{ SinOsc.ar(\freq.kr(400), 0, 0.1) } +> \test;
\test.v(\freq.slider);