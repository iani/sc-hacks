~e = ();
~ss = \freq.asSpec;
\window.vlayout (
	~s = Slider.horizontal,
	~n = NumberBox (),
).front;
//:
~s.action = { | me |
	var value;
	value = ~ss map: me.value;
	~e [\freq] = value;
	~e.changed (\freq, value, me);
};
//:
~n.action = { | me |
	var value;
	value = me.value;
	~e [\freq] = value;
	~e.changed (\freq, value, me);
};
//:
~e;
//:
~n.addNotifier (~e, \freq, { | val, sender, notification |
	val.postln;
	sender.postln;
	notification.postln;
	if (sender != notification.listener) {
		notification.listener.value = val
	}{
		"will not set value of self when what just changed was self!".postln;
	};
});
//:
~s.addNotifier (~e, \freq, { | val, sender, notification |
	val.postln;
	sender.postln;
	notification.postln;
	if (sender != notification.listener) {
		notification.listener.value = ~ss unmap: val
	}{
		"will not set value of self when what just changed was self!".postln;
	};
});
//: ================ SECOND TRY ================
~connectNum = { | num, param, envir |
	num.action = { | me |
		var value;
		value = me.value;
		~e [param] = value;
		~e.changed (param, value, me);
	};
	num.addNotifier (envir, param, { | val, sender, notification |
		val.postln;
		sender.postln;
		notification.postln;
		if (sender != notification.listener) {
			notification.listener.value = val
		}{
			"will not set value of self when what just changed was self!".postln;
		};
	});	
};

~e = ();

\window.vlayout (
	~s = Slider.horizontal,
	~n = NumberBox (),
).front;

~connectNum.(~n, \freq, ~e);

~connectSlider = { | slider, param, envir, spec |
	slider.action = { | me |
		var value;
		value = spec map: me.value;
		~e [param] = value;
		~e.changed (param, value, me);
	};
	slider.addNotifier (envir, param, { | val, sender, notification |
		val.postln;
		sender.postln;
		notification.postln;
		if (sender != notification.listener) {
			notification.listener.value = spec unmap: val
		}{
			"will not set value of self when what just changed was self!".postln;
		};
	});	
};

~connectSlider.(~s, \freq, ~e, \freq.asSpec);

//:
~e;
//: ================ third try ================
~e = ();

\window.vlayout (
	~s = Slider.horizontal,
	~n = NumberBox ()
).front;

~s.connectEnvir (\freq, ~e, \freq.asSpec);
~n.connectEnvir (\freq, ~e);
//: ================ third try ================
~e = ();

\window.vlayout (
	Slider.horizontal.connectEnvir (\freq, ~e, \freq.asSpec),
	NumberBox ().connectEnvir (\freq, ~e)
).front;

//: ================ fourth try: adding a synth ================

\window.vlayout (
	Slider.horizontal.connectEnvir (\freq, \envir, \freq.asSpec),
	NumberBox ().connectEnvir (\freq, \envir)
).front;

\synth.synth.connectEnvir (\freq, \envir.push.postln);
//: ================ fifth try: testing defaults ================
\window.vlayout (
	Slider.horizontal.connectEnvir (\freq),
	NumberBox ().connectEnvir (\freq).front;
).front;
	
\synth.synth.connectEnvir (\freq);
//: ================ sixth try: several params for one synth ================
\window.vlayout (
	HLayout (
		StaticText ().string_ ("freq"),
		Slider.horizontal.connectEnvir (\freq),
		NumberBox ().connectEnvir (\freq).front
	),
	HLayout (
		StaticText ().string_ ("amp"),
		Slider.horizontal.connectEnvir (\amp),
		NumberBox ().connectEnvir (\amp).front
	)
).front;
//:
\synth.synth ({ | freq = 440, amp = 0.1 |
	SinOsc.ar (freq * 1.5, 0, amp)
}).connectParams (\envir.asEnvironment, \freq, \amp);
//: 

\synth.synth ({ | freq = 440, amp = 0.1 |
	SinOsc.ar (freq * 2, 0, amp)
}).connectParams (\envir.asEnvironment, \freq, \amp);

//: Developing a way to evaluate function.play within an environment
// For Symbol:synth
~test = 100;
{ | test | test.squared.postln; test / 10;
}.valueEnvir;

//:
(
test: 2) use: {
{ | test | test.squared.postln; test / 10;
}.valueEnvir;
}
//:
(freq: 400) use: {
{ | freq | freq.squared.postln; freq / 10;
}.valueEnvir;
}
//:
(freq: 400) use: {
{ | freq | freq.squared.postln; freq / 10;
	{ | freq = 2000 | freq.postln; SinOsc.ar (freq, 0, 0.1 )
	}.play;
}.valueEnvir;
}
/* Need to write own method to provide arguments to Function:play
from the environment in which we play a function,
And then connect these to the environment, 
so that any changes in relevant values will result in setting 
relevant parameters in the synth. (or even changing its position in the node graph)

The function would be called eplay (i.e. environment- or event-play), and would also connect any arguments in the code of the function to be eplayed to the environment, so that they automatically change the synth's controls whenever the corresponding key is set in the environment.
*/ 