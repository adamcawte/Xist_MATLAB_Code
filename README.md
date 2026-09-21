# Xist_MATLAB_Code

This repository is to support the following paper : Cawte et al - A contact-mediated transfer mechanism directs in cis localization and spread of Xist RNA.

To use this analysis pipeline you must have: TrackMate installed in Fiji to analyse the data as desired and @msdanalyzer installed in Matlab (supporting documentation found here - https://tinevez.github.io/msdanalyzer/)

Once installed, you can run Trackmate as desired and output the data to separate folders. Then in Matlab, the "Import" scripts can be used as needed, depending on your source/analysis (i.e. MSD/tracking, XYZ volume quantification, Xist spreading etc.)
These imports will import separate files and treat them independently as individually cropped cells.

- Area import for Xist Area calculation from 2h Xist spreading data. (requires Trackmate Spots .csv output)
- ImportFociXYZ for Xist, number, volume and NND calculation (requires Trackmate Spots .csv output) 
- ImportInt for Xist intensity quantification (requires Trackmate Spots .csv output)
- ImportTracks for MSD and NND over time analysis (requires Trackmate simple .xml output)
- TS_Import for quantifying nascent Xist from Xist spreading data (requires Trackmate Spots .csv output)

Once the cell arrays are imported into Matlab, you can then run the "Quant" scripts to produce the desired quantification.

- Area_Multi for quantifiaction of Areas from multiple cells.
- DCoeff_Multi calculates fitted MSDs individually for each cell
- Foci_Quant quantifies the number of foci, NND between foci and their volume.
- NNT_quant calculates the NND between foci over time in fast tracking experiments
- TS_quant quantifies the minimum and maximum intensity foci over time, with the maximum intensities corresponding to the nascent Xist molecules

end
