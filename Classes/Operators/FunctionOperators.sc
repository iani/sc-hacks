/* 25 Jun 2017 00:39

+> play as synth

*> play as routine (fork)

*/

+ Function {
	+> { | name, envir | ^name.splay (this, envir) }
	*> { | name, envir | ^name.fork (this, envir) }
	**> {| name, envir | ^name.fork ({ this.loop }, envir) } 	// utility
	<* { | paramName, ownLabel = \func |
		ownLabel.addNotifier (currentEnvironment, paramName, this)
	}
}

+ Symbol {
	splay { | func, envir | ^this.synth (envir).play (func)}
	synth { | envir | ^Nevent.sget (envir, this) }

	fork { | func, envir, clock | ^this.routine (envir).play (func, clock) }
	routine { | envir, func, clock | ^Nevent.rget (envir, this, func, clock) }
}