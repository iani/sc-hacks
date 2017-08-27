+ Class {
	*addLib { | path |
		// add path of lib to list of paths for selecting an extensionsGui
		Registry(
			\extensionsGuiBase, {
				Set()
				add:
				PathName(this.class.findMethod(\extensionsGui)
					.filenameSymbol.asString).pathOnly.asSymbol;
			}
		).add((
			path ?? {
				PathName (thisProcess.nowExecutingPath).pathOnly
			}).asSymbol)
	}

	*extensionsGui {
		var selectionWindow, listView, paths;
		selectionWindow = Window("Select a library");
		paths = Registry(
			\extensionsGuiBase, {
				Set()
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
						paths[view.value].postln.asString)
				}
			})
		);
		selectionWindow.front;
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
		libname = PathName(base).folderName.asSymbol;
		Registry(\extensionGui, libname, {
			var w;
			w = Window(format("Defs for library %", libname), Rect(0, 0, 500, 800));
			w.view.layout = HLayout(
				VLayout(
					StaticText().string_("Classes:"),
					classList = ListView()
					.hiliteColor_(Color(1, 0.2, 0.2, 0.5))
					.selectedStringColor_(Color(0.1, 0.2, 1, 0.5))
					.items_(found.collect(_.name))
					.action_({ | me |
						methods = found[me.value].methods ++ found[me.value].class.methods;
						methods = (methods ? []) select: {
							| m| base.matchRegexp(m.filenameSymbol.asString)
						};
						methodList.items = (methods ? []).collect(_.name);
						methodLabel.string = format("% methods:", found[me.value]);
					})
					.keyDownAction_({ | view, char, mod, unicode |
						if (unicode == 13) { // return key
							Emacs.evalLispExpression(
								format (
									"(switch-to-buffer (find-file-noselect \"%\"))",
									found[view.value].filenameSymbol
								))
						}
					})),
				VLayout(
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
							Emacs.evalLispExpression(
								format (
									"(switch-to-buffer (find-file-noselect \"%\"))",
									methods[view.value].filenameSymbol
								)
							)
						}
					})
				)
			);
		}).front;
		// do this in each case
		{ classList.valueAction_(0).postln }.defer(0.1);
	}
}
