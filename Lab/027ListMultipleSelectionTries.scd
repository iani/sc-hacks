// 13 Oct 2017 09:21
\test.window({ | w |
	var s;
	w.view.layout = VLayout(
		ListView()
		.items_ ({ "asdf".scramble } ! 10)
		.selectionMode_(\multi)
		.selectedStringColor_(Color.red)
		.hiliteColor_(Color.white)
		.selectionAction_({ | me |
			s = me.selection.postln;
			me.colors = me.items collect: { | item, index |
					if (s includes: index) { Color.red } { Color.green }
				//Color.perform([\red, \green].choose)
			}
		})
	);	
 });
//:
