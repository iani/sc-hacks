// 25 Sep 2017 22:30
// Redo from scratch

LoadFiles {
	*initClass {
		StartUp add: { this.allSubclasses do: _.loadFromArchive; };
	}
	
	*loadFromArchive {
		this.archivePath.doIfExists({ | path |
			postf("% getting paths from %\n", this, path);
			this.all = Object readArchive: path;
			postf("% will load % files\n", this, this.all.size);
		}, { | path |
			postf("% could not find file to load paths:\n %\n", this, path);
		});
		// copy array because we will remove non-existing files from original.
		this.all.copy do: this.load(_);
	}

	*save {
		this.all.writeArchive(this.archivePath);
	}

	*add { | path |
		if (this.all.containsString(path)) {
			postf("% skipped loading existing:\n %\n", this, path);			
		};
		this.all = this.all add: path;
		this.save;
		this load: path;
	}

	*remove { | path |
		this.all = this.all.removeUniqueString(path);
		this.save;
	}

	*loadDialog {
		Dialog.openPanel({ | paths |
			paths do: this.add(_);
		}, {
			"CANCELLED".postln;
		},
			true
		)
	}

	*load { | path |
		path.doIfExists({
			postf("% loading %\n", this, path);
			this prLoad: path;
		}, {
			postf("% could not find %\n", this, path);
			"Removing file from paths".postln;
			this remove: path;
		})
	}
}

StartupFiles : LoadFiles {
	classvar <>all;

	*archivePath {
		^Platform.userAppSupportDir ++ "/StartupFiles.sctxar";
	}

	*prLoad { | path | path.load; }

}

AudioFiles : LoadFiles {
	classvar <>all;
	classvar buffers;
	*archivePath {
		^Platform.userAppSupportDir ++ "/AudioFiles.sctxar";
	}

	*buffers {
		buffers ?? { buffers = () };
		^buffers;
	}

	*prLoad {
		// Do nothing here. Load audio when buffer boots.
	}

	*initClass {
		StartUp add: {
			ServerBoot add: { this.all do: this.loadBuffer(_) }
		};
	}

	*loadBuffer { | path |
		var name;
		path.doIfExists(
			{
				Buffer.read(Server.default, path, action: { | b |
					name = b.path.asName;
					this.buffers[name] = b;
					postf("Loaded %\n", b);
					this.changed(\buffer, name, b);
				});
			},{
				postf("% could not find %\n", this, path);
				"Removing file from paths".postln;
				this remove: path;
			}
		)
	}
}

+ Nil {
	containsString { | string | ^false; }
	addUniqueString { | string |
		^[string]
	}

	removeUniqueString { | string |
		^[]
	}
	
}

+ Array {
	containsString { | string | ^this.detect({ | s | s == string }).notNil; }

	addUniqueString { | string |
		if (this containsString: string) {
			postf("prevented adding duplicate string:\n%\n", string);
			^false;
		}{
			^this add: string;
		}		
	}

	removeUniqueString { | string |
		var found;
		found = this.detect({ | s | s == string });
		if (found.isNil) {
			postf("could not remove string because it was not found:\n%\n", string);
		}{
			this remove: found;
		}
	}
}

+ String {
	asName { ^PathName(this).fileNameWithoutExtension.asSymbol }
	
}