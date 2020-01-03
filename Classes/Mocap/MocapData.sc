/*
Port of Mocap Data reading and pre-processing code from Stefano (Dec 2019).

Requirement: sc-hacks library (Uses Singleton class).
*/

MocapData : Singleton {
	var <path, <header, <data, <columns, <normalized, <dataForPCA, <pca;
	var <stats; // statistics on each column of data;
	open {
		Dialog.openPanel({ | argPath |
			path = argPath;
			postf("loading file:\n%\n", path);
			this.preprocessData(
				CSVFileReader.read(path, true, delimiter: Char.comma)
			);
		});
	}

	preprocessData { | file |
		header = file[0];
		data = file[1..]; // .select{|x| x.size > 1};
		postf("header size: %, data first row size: %, data % OK\n",
			header.size, data[0].size,
			['seems not', 'seems'][(header.size == data[0].size).binaryValue]
		);
		// raw = 
		this.initColumns;
		this.normalizeData;
		this.makeStats;
	}

	initColumns {
		columns = data.flop[1..].collect(_.numerify);
		dataForPCA = columns.flop;
	}

	normalizeData {
		"Normalizing data".postln;
		columns = columns collect: _.normalize;
	}

	makeStats {
		Benchmark({
			"calculating statistics".postln;
			stats = columns collect: Stats(_);
		}, "calculate statistics")
	}

	subtractPC { | data, pc1 |
		^data collect: { | row |
			row - ((pc1 * row).sum * pc1);
		};
	}

	calcPCA { | ncomponents = 1 |
		var components, df, pc1;
		df = dataForPCA;		
		^pca = (1 .. ncomponents) collect: { | i |
			pc1 = df.pc1;
			postf("% : ", i);
			pc1[..4].round(0.0001).postln;
			df = this.subtractPC(df, pc1);
			pc1;
		}
	}
	
}

Stats {
	// Perform some basic statistic operations on an array of numbers.
	var <data, <mean, <variance, <deviation;

	*new { | data |
		^this.newCopyArgs(data).init;
	}

	init {
		// Benchmark({
			this.calcMean;
		// }, "calculate mean");
		// Benchmark({
			this.calcVariance;
		// }, "calculate variance");
		// Benchmark({
			this.calcDeviation;
		// }, "calculate deviation");
	}

	calcMean { mean = data.sum / data.size }
	calcVariance {
		variance = data.collect({ | item | (item-mean).squared}).sum / data.size;
	}
	calcDeviation { deviation = variance.sqrt; }
	stats {
		^[mean, variance, deviation];
	}
}

Benchmark {
	// simple way to measure the execution duration of a function
	*new { | func, comment |
		var startTime;
		startTime = Process.elapsedTime;
		func.value;
		postf("% took % seconds to run\n",
			comment ? func,
			Process.elapsedTime - startTime
		)
	}
}

+ ArrayedCollection {
	numerify { ^this collect: _.interpret; }
}

/*
~columns = ~df.flop.collect({ | column | 
	column collect { | item |
	item.interpret}
})

*/