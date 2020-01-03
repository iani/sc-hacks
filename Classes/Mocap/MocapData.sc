/*
Port of Mocap Data reading and pre-processing code from Stefano (Dec 2019).

Requirement: sc-hacks library (Uses Singleton class).
*/

MocapData : Singleton {
	var <path, <header, <data, <columns, <normalized, <raw;
	var <stats; // statistics on each column of data;
	open {
		Dialog.openPanel({ | argPath |
			path = argPath;
			postf("loading file:\n%\n", path);
			this.preprocessData(
				CSVFileReader.read(path, delimiter: Char.comma)
			);
		});
	}

	preprocessData { | file |
		header = file[0];
		data = file[1..].select{|x| x.size > 1};
		postf("header size: %, data first row size: %, data % OK\n",
			header.size, data[0].size,
			['seems not', 'seems'][(header.size == data[0].size).binaryValue]
		);
		// raw = 
		this.initColumns;
		// this.normalizeData;
		this.makeStats;
	}

	initColumns {
		columns = data.flop[1..].collect(_.numerify); }

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