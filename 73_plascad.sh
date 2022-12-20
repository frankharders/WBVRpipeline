#!/bin/bash
#
##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate Plascad;


cnt=$(cat samples.txt | wc -l);

## reporting
GenRep="$REPORTING"/general-report.txt;


# (temp) variables

mkdir -p "$PWD"/73_plascad-plasmids;

DBin=/mnt/lely_DB/AMR-Lab/plasmidfinder_db/;
GENOME="$PWD"/genomes/;
READS="$PWD"/02_polished;
PLASMID="$PWD"/73_plascad-plasmids;

scriptdir=/home/wbvr006/GIT/plasmidfinder/;

count0=1;
countS=$(cat samples.txt | wc -l);

while [ "$count0" -le "$countS" ]; do 

SAMPLE=$(cat samples.txt | awk 'NR=='"$count0");
	echo $SAMPLE;

mkdir -p "$PLASMID"/"$SAMPLE";
mkdir -p "$PLASMID"/"$SAMPLE/contigs";
mkdir -p "$PLASMID"/"$SAMPLE/reads";

cp "$GENOME"/"$SAMPLE"'_contigs.fa' "$PLASMID";

GENOMEin="$PLASMID"/"$SAMPLE".fasta;


mv "$PLASMID"/"$SAMPLE"'_contigs.fa' "$GENOMEin";

Plascad -i "$GENOMEin" ;




count0=$((count0+1));
done
exit 1

##### Plascad
#
#usage: Plascad [-h] [-i I] [-n] [-cMOBB CMOBB] [-cMOBC CMOBC] [-cMOBF CMOBF] [-cMOBT CMOBT] [-cMOBPB CMOBPB] [-cMOBH CMOBH] [-cMOBP CMOBP] [-cMOBV CMOBV] [-cMOBQ CMOBQ]
#
#options:
#  -h, --help      show this help message and exit
#  -i I            input plasmids file for classification
#  -n              prodigal normal mode
#  -cMOBB CMOBB    alignment coverage for MOBB HMM profile
#  -cMOBC CMOBC    alignment coverage for MOBC HMM profile
#  -cMOBF CMOBF    alignment coverage for MOBF HMM profile
#  -cMOBT CMOBT    alignment coverage for MOBT HMM profile
#  -cMOBPB CMOBPB  alignment coverage for MOBPB HMM profile
#  -cMOBH CMOBH    alignment coverage for MOBH HMM profile
#  -cMOBP CMOBP    alignment coverage for MOBP HMM profile
#  -cMOBV CMOBV    alignment coverage for MOBV HMM profile
#  -cMOBQ CMOBQ    alignment coverage for MOBQ HMM profile
#
#####