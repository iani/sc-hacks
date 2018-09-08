
BufferGUI {
	*initClass{
		StartUp add: { this.new }
	}

	*new {
		this.window({ | w |
			w.setTopLeftBounds(Rect(0, 0, 200, 500));
			w.view.layout = VLayout(
				ListView()
				.items_((Registry.at(\buffers) ?? { IdentityDictionary() }).keys.asArray.sort)
				.enterKeyAction_({ | me |
					(Registry.at(\buffers) ?? { IdentityDictionary() })
					.keys.asArray.sort[me.items[me.value]].postln.play
				})
				.addNotifier(Buffer, \loaded, { | buffers, n |
					n.listener.items = buffers.keys.asArray.sort;
				})
				.addNotifier(Server.default, \didQuit, { | n |
					n.listener.items = [];
				})
			);
		});
	}
	
}