// 25 Sep 2017 22:30
// TODO: Implement active selection + saving. Use ListView multi selection mode.

LoadFiles {
	var <all;
	var <active; // array of boolean. Only active items are loaded

	*new { | name = \default |
		^Registry(this, name, { super.new });
	}
	*default { ^this.new }

	*gui { ^this.default.gui }
	// TODO: Replace this method by separate implementations in subclasses?
	gui { "Only subclasses of LoadFiles can make guis".postln; }
	loadFromArchive {
		this.archivePath.doIfExists({ | path |
			postf("% getting paths from %\n", this, path);
			all = Object readArchive: path;
			postf("% read % files.\n", this, all.size);
		}, { | path |
			postf("% could not find file to load paths:\n %\n", this, path);
		});
		if (all.size > 0) { this changed: \all };
		// all.copy do: this.load(_); // subclasses provide their own implementations
	}
	
	save { all.writeArchive(this.archivePath); }

	add { | path |
		// Add path to the list of paths in all.
		// If loadNow is true, then load the file of this path now.
		if (all.containsString(path)) {
			postf("% skipped adding existing:\n %\n", this, path);			
		}{
			postf("% adding file: \n%\n", this, path);
			all = all add: path;
			this.save;
			this.changed(\all);
		};
	}

	remove { | path |
		all = all.removeUniqueString(path);
		this.save;
		this.changed(\all);
	}

	loadDialog {
		Dialog.openPanel({ | paths |
			paths do: this.add(_);
		}, {
			"cancelled".postln;
		},  // allow multiple selection:
			true
		)
	}

	load { | path |
		postf("loading audio: %\n", path);
		path.loadBuffer;
	}
	*toggle { /* only AudioFiles uses this */ }

}
