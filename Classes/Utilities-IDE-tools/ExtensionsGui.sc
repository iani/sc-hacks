+ Class {
	*extensionsGui {
		/*
			Emacs.evalLispExpression("(sclang-add-libs-to-extensions-gui)");
			{ this.makeLibSelectionWindow; }.defer(1);
		*/
		(Platform.userExtensionDir ++ "/*").pathMatch do: this.addLib(_);
		this.addLib(Platform.classLibraryDir ++ "/");
		this.makeLibSelectionWindow;
	}

	*makeLibSelectionWindow {
		var selectionWindow, listView, paths;
		selectionWindow = Window("Select a library");
		paths = Registry(
			\extensionsGuiBase, {
				Set()
				.add(Platform.classLibraryDir ++ "/")
				add:
				PathName(this.class.findMethod(\extensionsGui)
					.filenameSymbol.asString).pathOnly.asSymbol;
			}).asArray.sort;
		
		selectionWindow.view.layout = VLayout(
			ListView().items_(
				paths collect: { | p |
					PathName(p.asString).folderName
				}
			)
			.keyDownAction_({ | view, char, mod, unicode |
				if (unicode == 13) {
					this.makeClassMethodSelectionWindow(
						paths[view.value].asString)
				}
			})
		);
		selectionWindow.front;
	}
	*addLib { | path |
		// add path of lib to list of paths for selecting an extensionsGui
		Registry(
			\extensionsGuiBase, {
				Set()
				/*
					add:
					PathName(this.class.findMethod(\extensionsGui)
					.filenameSymbol.asString).pathOnly.asSymbol;
				*/
			}
		).add((
			path ?? {
				PathName (thisProcess.nowExecutingPath).pathOnly
			}).asSymbol);
	}
	
	*makeClassMethodSelectionWindow { | base |
		var found, classList, methodList, methods, methodLabel, libname;
		base = base.asString;
		found = this.allClasses
		.select({ | c |
			// ['Meta_', 'Emacs', 'Docum']
			([Document, ScelDocument] includes: c).not
			and: 
			{ c.name.asString[..4] != "Meta_" }
			and: {
				c.name.asString[..4] != "Emacs"
			}
			and: {
				base.matchRegexp(c.filenameSymbol.asString)
				or: {
					(((c.methods) ++ (c.class.methods)) ? []).detect({ | m |
						base.matchRegexp(m.filenameSymbol.asString);
					}).notNil;
				}
			}
		});
		classList = ListView();
		libname = PathName(base).folderName.asSymbol;
		Registry(\extensionGui, libname, {
			var w;
			w = Window(format("Defs for library %", libname), Rect(0, 0, 500, 800));
			w.view.layout = HLayout(
				VLayout(  // Class list pane
					StaticText().string_("Classes:"),
					classList
					.hiliteColor_(Color(1, 0.2, 0.2, 0.5))
					.selectedStringColor_(Color(0.1, 0.2, 1, 0.5))
					.items_(found.collect(_.name))
					.action_({ | me |
						methods = found[me.value].methods ++ found[me.value].class.methods;
						methods = (methods ? []) select: {
							| m | base.matchRegexp(m.filenameSymbol.asString)
						};
						methodList.items = (methods ? []).collect(_.name);
						methodLabel.string = format("% methods:", found[me.value]);
					})
					.keyDownAction_({ | view, char, mod, unicode |
						if (unicode == 13) { // return key

							/*
								Emacs.evalLispExpression(
							 	format (
								"(switch-to-buffer (find-file-noselect \"%\"))",
								found[view.value].filenameSymbol
							 	))
							*/
							// found[view.value].postln.class.postln;
							found[view.value].openCodeFile;
						}
					})),
				VLayout( // Method list pane
					methodLabel = StaticText().string_("Methods:"),
					methodList = ListView()
					// .hiliteColor_(Color(1, 0.2, 0.2, 0.5))
					.selectedStringColor_(Color(0.1, 0.2, 1, 0.5))
					
					.selectionAction_({
						// methodList.hasFocus.postln;
						if (methodList.hasFocus) {
							methodList.hiliteColor_(Color(1, 0.2, 0.2, 0.5));
							classList.hiliteColor_(Color(0.2, 0.2, 0.2, 0.15));
							
						}{
							classList.hiliteColor_(Color(1, 0.2, 0.2, 0.5));
							methodList.hiliteColor_(Color(0.2, 0.2, 0.2, 0.15));
						}
						// methodList.selectedStringColor_(Color(1, 0.2, 0.0, 0.9));
						// classList.selectedStringColor_(Color(0.2, 0.2, 0.2, 0.3))
					})
					.keyDownAction_({ | view, char, mod, unicode |
						if (unicode == 13) { // return key
							// methods.collect(_.name).postln;
							methods[view.value].openCodeFile;
							{
								postf("Method: %, start pos: %. Going there now.\n",
									methods[view.value].name,
									methods[view.value].charPos
								);
								Emacs.evalLispExpression(
									format ("(goto-char %)", methods[view.value].charPos)
								)
							}.defer(1);
						}
					})
				)
			);
		}).front;
		// do this in each case to put the methods of the first class in the method pane:
		{ classList.valueAction_(0) }.defer(0.1);
	}
}
