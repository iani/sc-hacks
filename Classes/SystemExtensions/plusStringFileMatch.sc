+ String {
	fileMatch { | fileType = "scd" |
		^(this +/+ "*." ++ fileType).pathMatch
	}
}