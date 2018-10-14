//13 Oct 2018 18:23
//:Snippets are separated by comment // followed by semicolon:
// This is a snippet example
// TO run it in emacs, put the cursor anywhere inside the snippet
// and type control=meta-x
// To run it in SuperCollider, open the snippet list gui:
SnippetList.gui;
// And then select it by navigating from folder to file, finally
// to snippet. Then select the snippet and type enter.
// To refresh snippet files and folders use the button
// Read Folders
// If you edit a file for example in EMACS it refreshes
// automatically when you select the SnippetList gui widow.
// Conversely, if you edit in the SnippetList gui the contents
// of the file are saved automatically as soon as your mouse cursor
// leaves the text edit window area.
//:1 Environments ================
//:pushing an environment by name
//To get an environment, send the message
//'e' to the symbol naming the environment. For example:
\myenvironment.e;
//:environments created with e are stored in the library by name:
Library.at(\environments)
//:To push an environment, send it the push message:
\myenvironment.e.push;
//:Test the above:
currentEnvironment;
//:Shortcut: to create, get and push an environment, use "push"
\newenvironment.push;
//:Test the above:
currentEnvironment;
//:2. Players ================
//:a Player can play a synthdef, a function or an event (as Pattern)
// It runs in an environment
\default +> \newplayer;
//:Environment variables in an environment can be synth controls
\freq <+ 600;
//:show environment with its variables:
currentEnvironment;
//:You can create sliders to control parameters
\newplayer.v(
	\freq.slider,
	\amp.slider
);
//:sliders respond to changes in the parameters
{
	50 do: {
		\freq <+.newplayer (400 + 1000.rand);
		0.05.wait;
	};
}.fork;
//:
{ SinOsc.ar(\freq.kr(400) * 1.25, 0, 0.1) } +>.newplayer \playerDouble;
//:function as right argument for parameter
\freq <+ { LFNoise0.kr(15).range(100, 1000) };
//:Testing parameter access in an environment
\freq.value;
\amp.value(\test);
currentEnvironment;
//:3. Buffers ================
//:create an empty buffer
\buffer1.b(10); // argument is duration in seconds
//:access a buffer
\buffer.b; // if buffer does not exist, create empty buffer of 1 second
//:create buffer with n frames
\buffer2.bframes(1024);

