/*  4 Dec 2020 09:44
Shortcuts for returning Slider and Button using font from GuiDefaults.
*/
HButton {
	*new {
		^Button().font = GuiDefaults.font;
	}
}

HSlider {
	*new {
		^Slider().font = GuiDefaults.font;
	}
}

