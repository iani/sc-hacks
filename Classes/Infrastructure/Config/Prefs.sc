//: 10 Jan 2021 13:23
/*
Store preferences such as paths to folders.
For example, the paths to folders containing audio- ore code-files to be loaded.
And other stuff as well. 

See Readme_ConfigOrPfefs.org for discussion.

*/

Prefs : NamedSingleton {
	var userSoundDirs;

	userSoundDirs {
		userSoundDirs ?? {
			userSoundDirs =  [Platform.userHomeDir +/+ "sounds"];
		};
		^userSoundDirs;
	}

	userSounds {
		//this.userSoundDirs do: _.audioFiles;
		^(this.userSoundDirs collect: _.audioFiles).flat;
		
	}

	loadUserSounds {
		// note: rewrite using safer, faster method for reading
		// See String:loadBuffers
	^this.userSounds collect: { | p |  Buffer.read(Server.default, p) };
	}
}
