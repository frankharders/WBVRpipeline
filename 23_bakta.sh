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

##### bakta
##
#
#usage: bakta [--db DB] [--min-contig-length MIN_CONTIG_LENGTH] [--prefix PREFIX] [--output OUTPUT] [--genus GENUS] [--species SPECIES] [--strain STRAIN] [--plasmid PLASMID]
#             [--complete] [--prodigal-tf PRODIGAL_TF] [--translation-table {11,4}] [--gram {+,-,?}] [--locus LOCUS] [--locus-tag LOCUS_TAG] [--keep-contig-headers]
#             [--replicons REPLICONS] [--compliant] [--proteins PROTEINS] [--skip-trna] [--skip-tmrna] [--skip-rrna] [--skip-ncrna] [--skip-ncrna-region] [--skip-crispr] [--skip-cds]
#             [--skip-pseudo] [--skip-sorf] [--skip-gap] [--skip-ori] [--skip-plot] [--help] [--verbose] [--debug] [--threads THREADS] [--tmp-dir TMP_DIR] [--version]
#             <genome>
#
#Rapid & standardized annotation of bacterial genomes, MAGs & plasmids
#
#positional arguments:
#  <genome>              Genome sequences in (zipped) fasta format
#
#Input / Output:
#  --db DB, -d DB        Database path (default = <bakta_path>/db). Can also be provided as BAKTA_DB environment variable.
#  --min-contig-length MIN_CONTIG_LENGTH, -m MIN_CONTIG_LENGTH
#                        Minimum contig size (default = 1; 200 in compliant mode)
#  --prefix PREFIX, -p PREFIX
#                        Prefix for output files
#  --output OUTPUT, -o OUTPUT
#                        Output directory (default = current working directory)
#
#Organism:
#  --genus GENUS         Genus name
#  --species SPECIES     Species name
#  --strain STRAIN       Strain name
#  --plasmid PLASMID     Plasmid name
#
#Annotation:
#  --complete            All sequences are complete replicons (chromosome/plasmid[s])
#  --prodigal-tf PRODIGAL_TF
#                        Path to existing Prodigal training file to use for CDS prediction
#  --translation-table {11,4}
#                        Translation table: 11/4 (default = 11)
#  --gram {+,-,?}        Gram type for signal peptide predictions: +/-/? (default = ?)
#  --locus LOCUS         Locus prefix (default = 'contig')
#  --locus-tag LOCUS_TAG
#                        Locus tag prefix (default = autogenerated)
#  --keep-contig-headers
#                        Keep original contig headers
#  --replicons REPLICONS, -r REPLICONS
#                        Replicon information table (tsv/csv)
#  --compliant           Force Genbank/ENA/DDJB compliance
#  --proteins PROTEINS   Fasta file of trusted protein sequences for CDS annotation
#
#Workflow:
#  --skip-trna           Skip tRNA detection & annotation
#  --skip-tmrna          Skip tmRNA detection & annotation
#  --skip-rrna           Skip rRNA detection & annotation
#  --skip-ncrna          Skip ncRNA detection & annotation
#  --skip-ncrna-region   Skip ncRNA region detection & annotation
#  --skip-crispr         Skip CRISPR array detection & annotation
#  --skip-cds            Skip CDS detection & annotation
#  --skip-pseudo         Skip pseudogene detection & annotation
#  --skip-sorf           Skip sORF detection & annotation
#  --skip-gap            Skip gap detection & annotation
#  --skip-ori            Skip oriC/oriT detection & annotation
#  --skip-plot           Skip generation of circular genome plots
#
#General:
#  --help, -h            Show this help message and exit
#  --verbose, -v         Print verbose information
#  --debug               Run Bakta in debug mode. Temp data will not be removed.
#  --threads THREADS, -t THREADS
#                        Number of threads to use (default = number of available CPUs)
#  --tmp-dir TMP_DIR     Location for temporary files (default = system dependent auto detection)
#  --version             show program's version number and exit
#
#Version: 1.6.1
#DOI: 10.1099/mgen.0.000685
#URL: github.com/oschwengers/bakta
#
#Citation:
#Schwengers O., Jelonek L., Dieckmann M. A., Beyvers S., Blom J., Goesmann A. (2021).
#Bakta: rapid and standardized annotation of bacterial genomes via alignment-free sequence identification.
#Microbial Genomics, 7(11). https://doi.org/10.1099/mgen.0.000685
#
#####

##### table2asn_GFF
#
# download table2asn_GFF for Linux
#$ wget https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/table2asn_GFF/linux64.table2asn_GFF.gz
#$ gunzip linux64.table2asn_GFF.gz
#
## create the SQN file:
#$ linux64.table2asn_GFF -M n -J -c w -t template.txt -V vbt -l paired-ends -i GCF_000008865.2.fna -f GCF_000008865.2.gff3 -o GCF_000008865.2.sqn -Z
#####

##### bakta_plot
#
#usage: bakta_plot [--config CONFIG] [--output OUTPUT] [--prefix PREFIX] [--sequences SEQUENCES] [--type {features,cog}] [--help] [--verbose] [--debug] [--tmp-dir TMP_DIR] [--version] <input>
#
#Rapid & standardized annotation of bacterial genomes, MAGs & plasmids
#
#positional arguments:
#  <input>               Bakta annotations in JSON format
#
#Input / Output:
#  --config CONFIG, -c CONFIG
#                        Plotting configuration in YAML format
#  --output OUTPUT, -o OUTPUT
#                        Output directory (default = current working directory)
#  --prefix PREFIX, -p PREFIX
#                        Prefix for output files
#
#Plotting:
#  --sequences SEQUENCES
#                        Sequences to plot: comma separated number or name (default = all, numbers one-based)
#  --type {features,cog}
#                        Plot type: feature/cog (default = features)
#
#General:
#  --help, -h            Show this help message and exit
#  --verbose, -v         Print verbose information
#  --debug               Run Bakta in debug mode. Temp data will not be removed.
#  --tmp-dir TMP_DIR     Location for temporary files (default = system dependent auto detection)
#  --version             show program's version number and exit
#
#bakta_plot input.json
#
#bakta_plot --output test --prefix test --config config.yaml --sequences 1,2 input.json
#
#
###### 