+ Function {
	
	asPlayerSynthDef { arg rates, prependArgs, outClass=\Out, fadeTime, name;
		// only provide out argument if not already present
		if (def.argNames ? [] includes: \out) {
			^SynthDef(name, this, rates, prependArgs);
		}{
			^GraphBuilder.wrapPlayerOut(name ?? { this.identityHash.abs.asSymbol },
				this, rates, prependArgs, outClass, fadeTime
			);
		}
	}
}

+ GraphBuilder {
	/*
		TODO: add an argument for customizing makeFadeEnv.
		Make it possible to either provide the function itself,
		or the name of a method to call,
		Define different methods for different types of fade envelopes.
		Symbol \none might build as envelope just the number 1, 
		thus canceling the envelope making and allowing the user 
		to write their envelope + gate in the function. 
	*/
	*wrapPlayerOut { arg name, func, rates, prependArgs, outClass = \Out, fadeTime;
		^SynthDef.new(name, { arg out = 0; // i_out is non-modifiable. Use out instead.
			var result, rate, env;
			result = SynthDef.wrap(func, rates, prependArgs).asUGenInput;
			rate = result.rate;
			if(rate.isNil or: { rate === \scalar }) {
				// Out, SendTrig, [ ] etc. probably a 0.0
				result
			}{
				if(fadeTime.notNil) {
					result = this.makeFadeEnv(fadeTime) * result;
				};
				outClass = outClass.asClass;
				outClass.replaceZeroesWithSilence(result.asArray);
				outClass.multiNewList([rate, out] ++ result)
			}
		})
	}
}