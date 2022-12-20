#!/bin/bash

##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate bakta;


cnt=$(cat samples.txt | wc -l);




## reporting
GenRep="$REPORTING"/general-report.txt;


# (temp) variables

DEPTH=100;
MINlen=$CONTIGLENGTH;
MINcov=0;

mkdir -p "$PWD"/23_bakta-out;


DBin=/mnt/lely_DB/AMR-Lab/BAKTA/db/;
BAKTA="$PWD"/23_bakta-out;

GENOME="$PWD"/genomes/;



count0=1;
countS=$(cat samples.txt | wc -l);

while [ "$count0" -le "$countS" ]; do 

SAMPLE=$(cat samples.txt | awk 'NR=='"$count0");
	echo $SAMPLE;

mkdir -p "$BAKTA"/"$SAMPLE";

BAKTAin="$GENOME"/"$SAMPLE"'_contigs.fa';

bakta --db "$DBin" --prefix "$SAMPLE" --output "$BAKTA"/"$SAMPLE" --translation-table 11 --gram ? --keep-contig-headers --threads 48 "$BAKTAin";

count0=$((count0+1));
done
exit 1
