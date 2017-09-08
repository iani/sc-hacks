// 15 Jul 2017 09:51

+ Dictionary {
	get { | key, func |
		var val;
		val = this [key];
		val ?? {
			val = func.value;
			this [key] = val;
		};
		^val;
	}
}