#!/bin/bash

##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate amr-isescan;

## reporting
#GenRep="$REPORTING"/general-report.txt;



count0=1;
countS=$(cat samples.txt | wc -l);



mkdir -p ./20_isfinder;

ISFINDER=./20_isfinder;


while [ $count0 -le $countS ];do

	SAMPLE=$(cat samples.txt | awk 'NR=='$count0 );





ISFINDERin=./genomes/$SAMPLE'_contigs.fa';
LOG1=./LOGS/$SAMPLE.isfrinder.log;


isescan.py --seqfile $ISFINDERin --output $ISFINDER --nthread 48;




count0=$((count0+1));

done



#usage: isescan [-h] [--version] [--removeShortIS] [--no-FragGeneScan] --seqfile SEQFILE --output OUTPUT [--nthread NTHREAD]
#
#ISEScan is a python pipeline to identify Insertion Sequence elements (both complete and incomplete IS elements) in genom. A typical invocation would be:
#python3 isescan.py seqfile proteome hmm
#
#- If you want isescan to report only complete IS elements, you need to set command line option --removeShortIS.
#
#options:
#  -h, --help         show this help message and exit
#  --version          show program's version number and exit
#  --removeShortIS    Remove incomplete (partial) IS elements which include IS element with length < 400 or single copy IS element without perfect TIR.
#  --no-FragGeneScan  Use the annotated protein sequences in NCBI GenBank file (.gbk which must be in the same folder with genome sequence file), instead of the protein sequences
#                     predicted/translated by FragGeneScan. (Experimental feature!)
#  --seqfile SEQFILE  Sequence file in fasta format, '' by default
#  --output OUTPUT    Output directory, 'results' by default
#  --nthread NTHREAD  Number of CPU cores used for FragGeneScan and hmmer, 1 by default.








exit 1






