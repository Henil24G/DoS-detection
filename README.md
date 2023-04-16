# DoS-detection
Entropy based DoS detection

Entropy Calculation

This folder contains files related to the calculation of entropy values for various attributes.

Files

1. "main_entropy_calculation"

	This file contains the MATLAB code for calculating the entropy values of the attributes SrcIP, DstIP, Prt, SrcPrt, DstPrt, Flag, and Len.

2. "TCP_Syn_15_dos.csv"
	
	 This is a CSV file that contains the input data for the entropy calculation, with each attribute in a separate column.

3. "TCP_Syn_15_dos.mat"
	
	 This is a MATLAB data file that is created from the CSV file and is used as the input for "main_entropy_calculation"

4. "OUTPUT_OF_ENTROPY_15min.mat"
	
	 This is a MATLAB data file that stores the output of the entropy calculation from "main_entropy_calculation"

5. "entropy_plots" 

	This file contains the MATLAB code for ploting entropy values in line chart, it uses "OUTPUT_OF_ENTROPY_15min.mat" as the input.