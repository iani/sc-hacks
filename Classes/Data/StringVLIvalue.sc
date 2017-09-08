// 18 Jul 2017 22:59
// interpret string starting with "+" as number
/*
"+123.456".vliValue;
*/
+ String {
	vliValue {
		if (this [0] == $+) {
			^this [1..].interpret;
		}{
			^this.interpret;
		}
	}
}