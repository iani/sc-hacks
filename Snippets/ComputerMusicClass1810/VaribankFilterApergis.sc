/*
VaribankFileMaker:

Analyse a sound file .... and create something for CDP etc etc.

Usage: 

1. loadSoundFile : Select file to analyze throug a dialog
2. writeParameterFile : Analyse the file and write parameters for analysis in text file.
3. createFilteredSoundFile : Create sound file by filtering, for use in .... CDP

*/
VaribankFileMaker {
	var sampleFilterModelFile, filterBankParamFile, sampleInputFile, sampleOutputFile;
	var buffer;

	loadSoundFile {
		FileDialog (
			{ arg path;
				sampleFilterModelFile = PathName(path[0]);

				if (sampleFilterModelFile.extension == "wav",
					{
						this.loadSampleBuffer;
					},
					{
						sampleFilterModelFile = nil;
						postln( "Please select a soundfile next time" );
					}
				);
			},
			{
				postln("Made no selection");
				if (sampleFilterModelFile.notNil && buffer.notNil,
					{postln(", but" + sampleFilterModelFile.fileName + "is still loaded")}
				);
			}
		)
	}

	loadSampleBuffer {
		buffer !? { buffer.clear };
		buffer = Buffer.read(Server.default, sampleFilterModelFile.fullPath);
		postln("SoundFile" + sampleFilterModelFile.fileName + "was selected (to filter another with)");
	}

	writeParameterFile { arg offset=0.0, name="variTextFile";
		if (sampleFilterModelFile.notNil,
			{
				var fileName;
				var file;
				var fftSize = 2048;
				var fftSizeOver2 = (fftSize/2).asInt;
				var hop = 1/4;
				var rate = 2*fftSize/buffer.sampleRate;
				var step = offset;
				var content = "";
				var magnitudes;
				var duration = buffer.numFrames / buffer.sampleRate;
				var iterations = (duration / rate).ceil.asInt;
				var fftBuffer;
				var theFFT;
				var theWriter;

				//???? 
				if (name == "variTextFile",
					{fileName = sampleFilterModelFile.fileNameWithoutExtension},
					{fileName = name}
				);

				// this.makeFiterBankParamFile;
				filterBankParamFile = PathName.new(sampleFilterModelFile.pathOnly ++ fileName ++ ".txt");
				if (File.exists(filterBankParamFile.fullPath), {File.delete(filterBankParamFile.fullPath)});
				file = File(filterBankParamFile.fullPath, "w");

				if (offset != 0.0,
					{
						content = "0.0";

						(fftSizeOver2-1).do
						{
							arg i;
							content = content + (i+1*buffer.sampleRate/fftSize).asString;
							content = content + "-infdB";

						};
						file.write(content);
						content = "\n";
					}
				);

				// this.makeFFTSynth;
				fftBuffer = Buffer.alloc(Server.default,fftSize,1);

				theFFT = { var input, chain;
					input = PlayBuf.ar(buffer.numChannels, buffer, BufRateScale.kr(buffer));
					chain = FFT(fftBuffer, input, hop: hop, wintype: 0, winsize: fftSizeOver2);
					//chain = PV_MagSquared(chain);
				}.play;

				// this.makeWriteRoutine ... 
				theWriter = {

					"Please, bear with me...".postln;

					iterations.do // this.analyse1Frame;
					{
						arg i;
						fftBuffer.loadToFloatArray
						(
							action:
							{
								arg array;
								var z, x, m;

								content =  content ++ step;
								z = array.clump(2).flop;

								z = [Signal.newFrom(z[0]), Signal.newFrom(z[1])];
								x = Complex(z[0], z[1]);

								//~magnitudes = x.magnitude * x.magnitude;

								magnitudes = x.magnitude[1..fftSizeOver2-1]/fftSizeOver2;

								magnitudes.do
								{
									arg item, index;
									var ampInDB = item.ampdb;
									var threshold = -60;

									if ( ampInDB < threshold,
										{ampInDB = -inf},
										{ampInDB = ampInDB + 20}
									);

									content = content + (index+1*buffer.sampleRate/fftSize).asString;
									content = content + ampInDB ++ "dB";
								};
								content = content + "\n";
								file.write(content);
								content ="\n";

								//{ ~magnitudes.plot('Initial', Rect(200, 600-(200*i), 700, 200)) }.defer
							}
						);
						step = step + rate;
					};

					//wait a little more
					0.1.wait;
					file.close;
					theFFT.free;
					fftBuffer.free;
					"See? I'm done!".postln;
				}.fork;
			},
			{ postln("Please, select a soundfile to be analyzed")}
		);
	}

	createFilteredSoundFile { arg quality=5, volume=1, name="variFiltered";
		if (filterBankParamFile.notNil,
			{
				FileDialog (
					{ arg path;
						sampleInputFile = PathName(path[0]);

						if (sampleInputFile.extension == "wav",
							{
								var fileName;
								var command = "cd" + sampleInputFile.pathOnly.escapeChar($ ) ++ "; filter varibank 1" + sampleInputFile.fileName;

								postln(sampleInputFile.fileName + "was selected (to be filtered)");

								if (name == "variFiltered",
									{fileName = sampleInputFile.fileNameWithoutExtension ++ "_filtered"},
									{fileName = name}
								);

								sampleOutputFile = PathName.new(sampleInputFile.pathOnly ++ fileName ++ ".wav");
								if (File.exists(sampleOutputFile.fullPath), {File.delete(sampleOutputFile.fullPath)});

								command = command + sampleOutputFile.fileName + filterBankParamFile.fullPath.escapeChar($ ) + quality + volume;
								command.runInTerminal;
							},
							{sampleInputFile = nil; postln( "Please select a (.wav) soundfile next time" )}
						);
					},
					{
						postln("Made no selection");
						if (sampleInputFile.notNil,
							{postln("," + sampleInputFile.fileName + "is your previously filtered sound")}
						);
					}
				)
			},
			{ postln("Please, first analyze a sound")}
		);
	}
}