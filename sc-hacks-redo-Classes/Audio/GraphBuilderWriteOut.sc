+ Function {
	asPlayerSynthDef { arg rates, prependArgs, outClass=\Out, fadeTime, name;
		^GraphBuilder.wrapPlayerOut(name ?? { this.identityHash.abs.asSymbol },
			this, rates, prependArgs, outClass, fadeTime
		);
	}
}

+ GraphBuilder {
	*wrapPlayerOut { arg name, func, rates, prependArgs, outClass = \Out, fadeTime;
		^SynthDef.new(name, { arg out = 0; // i_out is non-modifiable. replaced by out
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