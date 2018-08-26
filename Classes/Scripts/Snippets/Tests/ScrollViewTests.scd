//: examples from http://doc.sccode.org/Classes/ScrollView.html
//:first example
var scroll = ScrollView(bounds:Rect(0,0,300,300).center_(Window.availableBounds.center));
var canvas = View();
var layout;
var i = 0;

var makeEntry = {
    var view = View().background_(Color.rand).layout_(
        HLayout(
            TextField().string_( ("This is entry number " + i.asString) ),
            Button().states_([["Delete"]]).action_({view.remove; i = i - 1;})
        )
    );
    i = i + 1;
    view;
};

layout = VLayout();
layout.add ( View().background_(Color.black).layout_(
    HLayout(
        Button().states_([["Add"]]).action_({ layout.insert(makeEntry.(), i) }),
        nil // stretch remaining empty space
    )
));

canvas.layout = layout;
50.do { canvas.layout.add( makeEntry.() ) };
canvas.layout.add(nil); // stretch remaining empty space

scroll.canvas = canvas;
scroll.front;
//:first example - substituting StaticText
var scroll = ScrollView(bounds:Rect(0,0,800,300).center_(Window.availableBounds.center));
var canvas = View();
var layout;
var i = 0;

var makeEntry = {
    var view = View().background_(Color.rand).layout_(
        HLayout(
            StaticText().string_( "testing: ".scatList({ | j |
				("This is entry number " + i.asString ++ "/" ++ j.asString ++ ". " ) } ! 1.rrand(20)) ),
            Button().states_([["RUN"]]).action_({view.remove; i = i - 1;})
			.maxWidth_(50)
        )
    );
    i = i + 1;
    view;
};

layout = VLayout();
layout.add ( View().background_(Color.black).layout_(
    HLayout(
        Button().states_([["Add"]]).action_({ layout.insert(makeEntry.(), i) }),
        nil // stretch remaining empty space
    )
));

canvas.layout = layout;
50.do { canvas.layout.add( makeEntry.() ) };
canvas.layout.add(nil); // stretch remaining empty space

scroll.canvas = canvas;
scroll.front;
//:cleaning up the extremely messy example above. Stage 1.
var w, scroll, canvas, layout, i = 0;

w = Window(name: "scroll", bounds: Rect(0,0,800,300).center_(Window.availableBounds.center));
scroll = ScrollView(w, Rect(0, 0, w.bounds.width, w.bounds.height));
canvas = View();
canvas.layout = VLayout(
	*({ StaticText().string_("asdfabla".scramble) } ! 30)
);
scroll.canvas = canvas;
w.front;
//:Stage 2: something more useful
var w, scroll, canvas, layout, i = 0;

w = Window(name: "scroll", bounds: Rect(0,0,800,300).center_(Window.availableBounds.center));
scroll = ScrollView(w, Rect(0, 0, w.bounds.width, w.bounds.height));
canvas = View();
layout = VLayout();
canvas.layout = layout;
{ StaticText().string_("asdfabla".scramble) } ! 30 do: layout.add(_);
scroll.canvas = canvas;
w.front;
//:Stage 3: compact variant of above
var w, layout;

layout = VLayout();
w = Window(name: "scroll", bounds: Rect(0,0,800,300).center_(Window.availableBounds.center));
ScrollView(w, Rect(0, 0, w.bounds.width, w.bounds.height))
.canvas_(
	View()
	.layout_(layout);
);
{ StaticText().string_("asdf ab la".scramble[0..9.rand]) } ! 30 do: layout.add(_);

w.front;
//:Stage 4: experimental. update contents of layout
var w, layout, canvas;

layout = VLayout();
canvas = View();
w = Window(name: "scroll", bounds: Rect(0,0,800,300).center_(Window.availableBounds.center));
ScrollView(w, Rect(0, 0, w.bounds.width, w.bounds.height))
.canvas_(canvas);
canvas.layout = layout;
{ StaticText().string_("asdf ab la".scramble[0..9.rand]) } ! 30 do: layout.add(_);
{
	3.wait;
	
}.fork(AppClock);
w.front;
//:Stage 5: experimental - try with grid
var w, scroll;
w = Window(name: "scroll", bounds: Rect(0,0,300,300).center_(Window.availableBounds.center));
scroll = ScrollView(w, Rect(0, 0, w.bounds.width, w.bounds.height));
{
	var color, canvas, widget;
	15 do: {
		widget = [
			{ Button().states_([["asdfasfd".scramble,
					Color.black,
				Color.rand]])},
			{ Slider().orientation_(\horizontal)}
		].choose;
		color = Color.rand;
		canvas = View()
		.layout_(
			GridLayout.rows(
				*({ StaticText()
					.background_(color)
					.string_("asdf asdf asdf asdffffffff zzxcvvbvbvb v ".scramble[0..9.rand]) } ! 30)
				.collect({ | i | [i, widget.value]})
			)
		);
		scroll.canvas_(canvas);
		1.5.wait;
		canvas.destroy;
		//0.05.wait;
	};
	0.1.wait;
	w.close.postln;
}.fork(AppClock);

w.front;
//:Stage 5: experimental - retry with VLayout
var w, scroll;
w = Window(name: "scroll", bounds: Rect(0,0,600,300).center_(Window.availableBounds.center));
scroll = ScrollView(w, Rect(0, 0, w.bounds.width, w.bounds.height));
{
	var color, canvas, widget, string;
	15 do: {
		widget = [
			{ Button().states_([["asdfasfd".scramble,
				Color.black,
				Color.rand]])},
			{ Slider().orientation_(\horizontal)}
		].choose;
		string = { "testing".scramble
			.scatList({ ["a", "bcde qwerty", "asdf"].choose } ! 3.rrand(10)); };
		color = Color.rand;
		canvas = View()
		.layout_(
			VLayout(
				*({ StaticText()
					.background_(color)
					.string_(string.value) } ! 30)
				.collect({ | i | HLayout(i, widget.value)})
			)
		);
		scroll.canvas_(canvas);
		1.5.wait;
		canvas.destroy;
		//0.05.wait;
	};
	0.1.wait;
	w.close.postln;
}.fork(AppClock);

w.front;
//:try with grid
w=Window().layout_( GridLayout.rows(
    [Slider2D(), Slider2D(), [Slider(), rows:2]],
    [Slider2D(), Slider2D()],
    [[Slider().orientation_(\horizontal), columns:2]]
)).front;
//:stacklayout test
// from: http://doc.sccode.org/Classes/StackLayout.html
var stack;
w = Window().layout_( VLayout(
    Button().states_([["One"],["Two"],["Three"]]).action_({ |b| stack.index = b.value }),
    stack = StackLayout(
        TextView().string_("This is a chunk of text..."),
        TextView().string_("...and this is another..."),
        TextView().string_("...and another.")
    );
)).front;