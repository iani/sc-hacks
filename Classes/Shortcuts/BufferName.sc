/* 22 Aug 2020 16:14
Ad hoc simple scheme for generating a name for a buffer from its path.
Concat folder with file name.
Avoids duplicate names in most cases.
*/

+ Buffer {
	bufname { ^this.path.bufname }
}

+ String {
	bufname {
		var p;
		p = PathName(this);
		^(p.folderName ++ "_" ++ p.fileNameWithoutExtension).asSymbol;
	}
}