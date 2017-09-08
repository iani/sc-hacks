/* 25 Jun 2017 00:42

These will take a while to test in practice.

Should primarily be used to link synths (with buses, and in right synth order).

But these operators will work by setting the default \out and \in environment 
variables in Nenvirs, to which many Synths can be added.

&> set the output bus of the receiver to the input bus of the argument (only the output bus of the receiver changes)

<& set the input bus of the argument to the output bus of the receiver (only the input bus of the argument changes)

&>! set the output bus of the receiver to the input bus of the argument, on a new private bus (both receiver and argument change)

&/> Copy the output signal of the receiver from its bus onto the input bus of the argument, using a signal copy synth.

</> Copy the output signal of the receiver onto a new private bus, and the signal from that private bus onto the input bus of the argument, using 2 signal copy synths.

*/

+ Symbol {
    // writer output -> reader input
	&> { | readerName |
		this.asEnvironment (false) addSharedBus: readerName.asEnvironment (false);
	}
	// reader input -> writer output
	<& { | writerName |
		writerName &> this;
	}
	// writer output -> writer output, both on new bus
	&>! { // 
		
	}
	// copy writer output to bus of reader input
	&/> {
		
	}
	// copy writer output to new bus and buses output to reader input
	</> {
		
	}
}

+ Integer {
    // writer output -> reader input
	&> { | readerName |
		this.asEnvironment (false) addSharedBus: readerName.asEnvironment (false);
	}
	// reader input -> writer output
	<& { | writerName |
		writerName &> this;
	}
	// writer output -> writer output, both on new bus
	&>! { // 
		
	}
	// copy writer output to bus of reader input
	&/> {
		
	}
	// copy writer output to new bus and buses output to reader input
	</> {
		
	}
}
