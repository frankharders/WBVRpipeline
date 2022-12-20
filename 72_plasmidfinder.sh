#!/bin/bash
#
##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate amr-plasmidfinder;


cnt=$(cat samples.txt | wc -l);




## reporting
GenRep="$REPORTING"/general-report.txt;


# (temp) variables

mkdir -p "$PWD"/72_plasmidfinder;

DBin=/mnt/lely_DB/AMR-Lab/plasmidfinder_db/;
GENOME="$PWD"/genomes/;
READS="$PWD"/02_polished;
PLASMID="$PWD"/72_plasmidfinder;

scriptdir=/home/wbvr006/GIT/plasmidfinder/;

count0=1;
countS=$(cat samples.txt | wc -l);

while [ "$count0" -le "$countS" ]; do 

SAMPLE=$(cat samples.txt | awk 'NR=='"$count0");
	echo $SAMPLE;

mkdir -p "$PLASMID"/"$SAMPLE";
mkdir -p "$PLASMID"/"$SAMPLE/contigs";
mkdir -p "$PLASMID"/"$SAMPLE/reads";

GENOMEin="$GENOME"/"$SAMPLE"'_contigs.fa';
READSin1="$READS"/"$SAMPLE"/"$SAMPLE"'_R1.QTR.adapter.correct.fq.gz';
READSin2="$READS"/"$SAMPLE"/"$SAMPLE"'_R2.QTR.adapter.correct.fq.gz';


OUTc="$PLASMID"/"$SAMPLE"/contigs;
OUTr="$PLASMID"/"$SAMPLE"/reads;

#python3 "$scriptdir"/plasmidfinder.py -i "$GENOMEin" -o "$OUTc" -p "$DBin" -x ;

python3 "$scriptdir"/plasmidfinder.py -i "$READSin1" "$READSin2" -o "$OUTr" -p "$DBin" -x ;
count0=$((count0+1));
done
exit 1

##### plasmidfinder
#
#
#usage: plasmidfinder.py [-h] -i INFILE [INFILE ...] [-o OUTDIR] [-tmp TMP_DIR] [-mp METHOD_PATH] [-p DB_PATH] [-d DATABASES] [-l MIN_COV] [-t THRESHOLD] [-x] [--speciesinfo_json SPECIESINFO_JSON] [-q]
#
#options:
#  -h, --help            show this help message and exit
#  -i INFILE [INFILE ...], --infile INFILE [INFILE ...]
#                        FASTA or FASTQ input files.
#  -o OUTDIR, --outputPath OUTDIR
#                        Path to blast output
#  -tmp TMP_DIR, --tmp_dir TMP_DIR
#                        Temporary directory for storage of the results from the external software.
#  -mp METHOD_PATH, --methodPath METHOD_PATH
#                        Path to method to use (kma or blastn)
#  -p DB_PATH, --databasePath DB_PATH
#                        Path to the databases
#  -d DATABASES, --databases DATABASES
#                        Databases chosen to search in - if non is specified all is used
#  -l MIN_COV, --mincov MIN_COV
#                        Minimum coverage
#  -t THRESHOLD, --threshold THRESHOLD
#                        Minimum hreshold for identity
#  -x, --extented_output
#                        Give extented output with allignment files, template and query hits in fasta and a tab seperated file with gene profile results
#  --speciesinfo_json SPECIESINFO_JSON
#                        Argument used by the cge pipeline. It takes a list in json format consisting of taxonomy, from domain -> species. A database is chosen based on the taxonomy.
#  -q, --quiet
#
#####