//: 24 Dec 2020 04:10
/* 

(0..10).squared[[0, 3, 5, 2, 1]];
*/
//:listView works well, like this:
\test.listView;
\test.items = (1..10).squared;
{ 
   loop {
   10 do: { | i |
	i.postln;
	1.wait;
	\test.items = (i..(2 * i + 5)).squared.postln;
	2.wait;
   }
	}
}.fork
//:Testing double list view - vertical layout
\test.doubleListView;
//:Testing double list view - horizontal layout
\test.doubleListView(HLayout);
//:test multiple selection?
w = Window.new.front;

v = ListView(w,Rect(10,10,120,70))
.items_([ "SinOsc", "Saw", "LFSaw", "WhiteNoise", "PinkNoise", "BrownNoise", "Osc" ])
.background_(Color.clear)
.selectionMode_(\multi)
.hiliteColor_(Color.green(alpha:0.6))
.action_({ arg sbs;
	sbs.selection.postln;
	[sbs.value, v.items[sbs.value]].postln; // .value returns the integer
});