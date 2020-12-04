// 10 Oct 2017 10:29
// Utility methods for File:use

+ File {
	*writeFunc { | path, func |
		this.use(
			path,
			"w",
			{ | f | f.write(func.value)}
		)
	}
	*readFunc { | path, func |
		this.use(
			path,
			"r",
			{ | f | func.(f.readAllString)}
		)
	}
}