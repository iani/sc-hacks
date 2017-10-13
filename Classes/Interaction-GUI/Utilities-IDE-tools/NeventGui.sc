//  6 Oct 2017 21:04
// Display current environment, and its Event's contents
// Under development: Also display players of selected event, and
// display parameters 

NeventGui {
	var <currentEnvironmentDisplay;
	var <environmentListView, <environmentList;
	var <selectedEnvironmentDisplay;
	var <selectedEnvironment;
	var <currentEnvirAction, <updateUserEnvirAction;

	*initClass {
		StartUp add: {
			// { this.gui } defer: 0.1;
		}
	}
	*gui {
			this.get_(\guis, \default, { this.new}).gui;	
		}

	gui {
		this window: { | w, me | me initWindow: w}		
	}

	initWindow { | w |
		w.bounds = Rect(0, 400, 400, 600);
		w.view.layout = VLayout(
			StaticText().string_("(enter: push, space: toggle)"),
			HLayout(
				VLayout(
					StaticText().string_("Environments"),
					environmentListView = ListView() 
					.keyDownAction_({ | view, char, mod, key |
						switch (key,
							// Enter key
							13, { this.pushSelectedEnvir; },
							// Space key
							32, { this.toggleSelectedEnvir; },
							0, {}, // cursor keys: IGNORE
							{ key.postln }
						)
					})),
				VLayout(
					StaticText().string_("Players"),
					ListView() 
				)
			),
			StaticText().string_("Parameters:"),
			ListView(),
			StaticText().string_("Parameter value/code:"),
			TextView(),
			StaticText().string_("user selected environment:"),
			selectedEnvironmentDisplay = StaticText()
			.background_(Color(0.9, 0.9, 1.0)),
			TextField().string_("currentEnvironment:"),
			currentEnvironmentDisplay = StaticText().string_(currentEnvironment.asString)
			.background_(Color(1.0, 0.9, 0.9))
		);
		this.initUserEnvinDisplay;
		this.initCurrentEnvirDisplay;
	}

	initUserEnvinDisplay {
		updateUserEnvirAction = {
			{ selectedEnvironmentDisplay.string = selectedEnvironment.asString }.defer;
		};
		environmentListView.action = { | me |
			selectedEnvironment removeDependant: updateUserEnvirAction;
			selectedEnvironment = environmentList[me.value];
			selectedEnvironment addDependant: updateUserEnvirAction;
			updateUserEnvirAction.value;
		};
		environmentListView.addNotifier(Nevent, \newEnvir, { | environment |
			this.updateEnvironmentListView(environment);
		});
		this.updateEnvironmentListView;
	}

	initCurrentEnvirDisplay {
		currentEnvirAction = {
			{ currentEnvironmentDisplay.string = currentEnvironment.asString; }.defer;
		};
		currentEnvironment addDependant: currentEnvirAction;
		
		currentEnvironmentDisplay.addNotifier(Nevent, \oldEnvir, { | environment |
			environment removeDependant: currentEnvirAction;
		});
		currentEnvironmentDisplay.addNotifier(Nevent, \newEnvir, { | environment |				
			{this.update}.defer; // allow updates from SystemAppClock routines
			environment addDependant: currentEnvirAction;
		})
	}

	updateEnvironmentListView {
		var envir;
		envir = selectedEnvironment ? currentEnvironment;
		{
			environmentList = Nevent.all.sort({ | a, b | a.name < b.name });
			environmentListView.items = environmentList collect: _.name;
			/* postf("items: %\nfound: %\n",
				environmentListView.items,
				environmentListView.items indexOf: envir.name;
				); */
			environmentListView.valueAction = environmentListView.items indexOf: envir.name;
		}.defer;
	}

	update {
		// display full envir when it chages. defer: allow updates from SystemAppClock routines
		{currentEnvironmentDisplay.string = currentEnvironment.asString;}.defer;
	}

	pushSelectedEnvir {
		selectedEnvironment.push;
	}

	toggleSelectedEnvir {
		selectedEnvironment.toggle;
	}
}
