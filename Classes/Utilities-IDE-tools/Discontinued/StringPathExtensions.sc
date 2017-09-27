//  9 Sep 2017 09:31
+ String {
	parentPath {
		^this.colonIndices
	}
	colonIndices {
		var colonIndices;
		colonIndices = List.new;
		this.do({ | eachChar, i |
			if(eachChar.isPathSeparator, { colonIndices.add(i) })
		});
		^colonIndices
	}
}