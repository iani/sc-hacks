/* 25 Oct 2018 03:03
*/

+ Rect {
	*tl { | width = 200, height = 200 |
		^this.new(
			0, Window.availableBounds.height - height,
			width, height
		)
	}
	*tr { | width = 200, height = 200 |
		var availableBounds = Window.availableBounds;
		^this.new(
			availableBounds.width - width,
			availableBounds.height - height,
			width, height
		)
	}

	*bl { | width = 200, height = 200 |
		^this.new(0, 0, width, height)
	}

	*br { | width = 200, height = 200 |
		^this.new(Window.availableBounds.width - width,
			0, width, height
		)
	}
}