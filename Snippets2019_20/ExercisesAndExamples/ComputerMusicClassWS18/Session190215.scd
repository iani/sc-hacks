Platform.userExtensionDir

//:


Server.default.boot; // trekse prota atuto


(		//vale prota to path apo fakelo pou exeis tous ixous kai meta trekse edo
~library = Array.new;
~folder = PathName.new("/Users/tsaka/Desktop/sounds");

~folder.entries.do({
	arg path;
	~library = ~library.add(Buffer.read(s, path.fullPath));
});
)
(     //telos trekse edo
SynthDef.new(\EpiTime, {
	arg amp=1, out=0, buf, start, end, rate=1, glide=0, loop=0, bal=0;
	var sig, ptr;
	rate = Lag.kr(rate, glide);
	ptr = Phasor.ar(0, BufRateScale.kr(buf)*rate, start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = Balance2.ar(sig[0], sig[1], bal);
	sig = sig * amp;
	Out.ar(out, sig*2);
}).add;


Window.closeAll;
s.freeAll;
w = Window("EpiTime", Rect(500,100,600,200))
.background_(Color(0.3,0.65,0.95))
.front
.alwaysOnTop_(true);

~pan = EZKnob(w, Rect(350,85,50,30), "Balance ", \bipolar,
	{|ez| x.set( "bal", ez.value )},labelWidth:60,labelHeight:9,layout:\line2);
//1h seira
~rate_slider = Slider(w, Rect(50,20,300,30))
.background_(Color.magenta)
.value_(0.5)
.action_({
	arg obj;
	var speed;
	speed = obj.value.linexp(0,1,1/50,50).postln;
	if(
		x.isPlaying,
		{x.set(\rate, speed)}
	);

});
~reverse = Button(w, Rect(465,20,60,30))
.states_([
	["Reverse", Color.black, Color.gray(0.8)],
	["Reverse", Color.white, Color.magenta]
])
.font_(Font("Monaco", 15))
.action_({
	arg obj;
	if(
		obj.value == 0,

		{
			~rate_slider = Slider(w, Rect(50,20,300,30))
.background_(Color.magenta)
.value_(~rate_slider.value)
.action_({
	arg obj;
	var speed;
	speed = obj.value.linexp(0,1,1/50,50).postln;
	if(
		x.isPlaying,
		{x.set(\rate, speed)}
	);
			});
		},
		{~rate_slider = Slider(w, Rect(50,20,300,30))
.background_(Color.magenta)
.value_(~rate_slider.value)
.action_({
	arg obj;
	var speed;
				speed = obj.value.linexp(0,1,1/50,50)*(-1).postln;
	if(
		x.isPlaying,
		{x.set(\rate, speed)}
	);
			});}
	);
});
a = RangeSlider(w, Rect(50, 60, 300, 20))
	.background_(Color(1,1,1))
    .lo_(0)
    .hi_(1)
    .action_({ |slider|
        ~slider_start1.valueAction_(slider.lo); // this will trigger the action of slider_start & slider_end (and set it's value)
        ~slider_end1.valueAction_(slider.hi);
    });
~slider_start1 = Slider(q, Rect(50,50,300,15))
.background_(Color.blue)
.action_({
	arg obj;
	var start1;

	start1 = obj.value.linexp(0,1,2000,~library[0].numFrames-1).postln;
	if(
		x.isPlaying,
		{x.set(\start, start1)}
	);

});
~slider_end1 = Slider(q, Rect(50,65,300,15))
.background_(Color.blue)
.value_(~library[0].numFrames)
.action_({
	arg obj;
	var end1;

	end1 = obj.value.linexp(0,1,2001,~library[0].numFrames).postln;
	if(
		x.isPlaying,
		{x.set(\end, end1)}
	);

});


~knob = Knob(w, Rect(360,20,30,30))
.action_({
	arg obj;
	var vol;
	vol = obj.value.linexp(0,1,100000/1,1).reciprocal;
	if(
		x.isPlaying,
		{x.set(\amp, vol)}
	);
});
~lag_numbox = NumberBox(w, Rect(365, 60, 20, 20))
	.clipLo_(0)
	.clipHi_(50)
    .action_({
	arg obj;
	var num;
	num = obj.value;
	if(
		x.isPlaying,
		{x.set(\glide, num)}
	);
			});

~button = Button(w, Rect(530,20,50,30))
.states_([
	["Off", Color.black, Color.gray(0.8)],
	["On", Color.white, Color.magenta]
])
.font_(Font("Monaco", 15))
.action_({
	arg obj;
	if(
		obj.value == 1,

		{
			x = Synth.new(
				\EpiTime,
				[
					\buf, ~library[0].bufnum, \amp, ~knob.value.linexp(0,1,100000/1,1).reciprocal, \rate, ~rate_slider.value.linexp(0,1,1/50,50), \start, 	~slider_start1.value.linexp(0,1,2000,~library[0].numFrames-1), \end, ~slider_end1.value.linexp(0,1,2001,~library[0].numFrames), \glide, ~lag_numbox.value, \bal, ~pan.value
				]
			).register;
		},
		{x.free}
	);
});

// names
~speed_text = StaticText(w, Rect(10, 20, 30, 20))
.string_("Speed");
~loop_text = StaticText(w, Rect(10, 60, 25, 20))
.string_("Loop");
~vol_text = StaticText(w, Rect(400, 20, 40, 20))
.string_("Volume");
~vol_0_text = StaticText(w, Rect(390, 36, 20, 20))
.string_("-0");
~vol_6_text = StaticText(w, Rect(373, 42, 20, 20))
.string_("+6");
~lag_text = StaticText(w, Rect(400, 55, 37, 30))
.string_("Latency
Speed");

)

s.freeAll

