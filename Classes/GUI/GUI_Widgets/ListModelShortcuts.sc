//: 24 Dec 2020 03:08
/* shortcuts for using ListModel



//:
\test.listView;
{ 
   loop {
   10 do: { | i |
	i.postln;
	1.wait;
	\test.items = (i..(i+ 5 + i)).squared.postln;
	2.wait;
   }
	}
}.fork
//:
*/

+ Object {
	listView {
		// single list view
		this.prLayout(
			[ListModel.named(this).listView],
			VLayout,
			400
		)
	}
}

+ Symbol { // + Object ???
	items_ { | array |
		ListModel.named(this).items_(array);
	}
}
