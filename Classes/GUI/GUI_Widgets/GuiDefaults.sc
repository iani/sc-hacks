/* 11 Sep 2019 22:33
An efficient way to store some defaults for gui.
Initialized at StartUp depending on thisProcess.platform.
*/

GuiDefaults {
	classvar <>font, <>lineHeight, <>bounds;
	classvar <>width;
	// add more variables when needed
	// classvar <>maxWidth;

	*initClass {
		StartUp add: {
			if (thisProcess.platform.name === \linux) {
				font = Font("Helvetica", 20);
				lineHeight = 40; // 30;
				width = 800;
				bounds = Rect(0, 0, width, 400)
				// add more lines for other defaults when needed
			}{
				// defaults for all other platforms
				// can be overwritten when required.
				font = Font("Helvetica", 12);
				lineHeight = 30;
				width = 400;
				bounds = Rect(0, 0, width, 400)
				// add more lines for other defaults when needed
			}
		}
	}
}