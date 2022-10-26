#!/bin/bash

## info



# Dependencies:
#   fastqc, SHOVILL
#export

## Data organisation
## create data structure in directories
## MiSeq data is different in raw seq data as genomescan data
## This wrapper is ONLY for MiSeq data.
## MiSeq data name structure "[SAMPLENAME]_S[NUMBER]_R[1,2]_[001 or empty].fastq.gz"
## This structure can be simplified to "[SAMPLENAME]_R[1,2].fastq.gz" for easy use

### manual input of some info regarding working directories

ADAPTERPATH="/mnt/lely_DB/Old_Shared_DATABASES/NGSADAPTERS/";              # v
ADAPTER="nextera";							                               # x         # options: nextera Rubicon TAKARA truseq scriptseqv2
ASSEMBLER="spades";                                                        # y         #options: velvet megahit skesa spades
CONTIGLENGTH=300;                                                          # z

### standard output directories
WORKDIR="$PWD";									                           # w
RAW_FASTQ="$WORKDIR/RAWREADS/";                                            # a
RAWSTATS="$WORKDIR/01_rawstats/";                                          # b
POLISHED="$WORKDIR/02_polished/";                                          # c
TRIMMEDSTATS="$WORKDIR/03_trimmedstats/";                                  # d
SHOVILL="$WORKDIR/04_shovill/";                                            # e
QUAST="$WORKDIR/05_quast_analysis/";                                       # f
QUASTparse="$WORKDIR/REPORTING/";                                          # g
MLST="$WORKDIR/06_mlst/";                                                  # h
MLSTparse="$WORKDIR/REPORTING/";                                           # i
ABRICATE="$WORKDIR/07_abricate/";										   # j
PROKKA="$WORKDIR/07a_prokka/";											   # j
AMRFINDER="$WORKDIR/08_amrfinder/";									 	   # k
TMP="$WORKDIR/TEMP/";                                                      # l
GENOMES="$WORKDIR/genomes/";											   # m
LOG="$WORKDIR/LOGS/";                                                      # n
STARAMR="$WORKDIR/09_staramr/";											   # s
RGI="$WORKDIR/10_card-update-analysis/";								   # t
RESFINDER="$WORKDIR/11_resfinder-analysis/";							   # u
REPORTING="$WORKDIR/REPORTING/";                                           # r
SRAX="$WORKDIR/12_sraX-analysis/";										   # o
MUMI="$WORKDIR/14_mumi-analysis/";							    		   # p


ARCHIVE="/mnt/lely_scratch/wbvr006/BACT/2021/";				        			   # q





GenRep="$REPORTING"/general-report.txt;




echo "This wrapper is only suitable for MiSeq Raw data!!!";
echo "If raw data is from GenomeScan use the other wrapper";
echo "If data from a unknown source just ask around which wrapper to use";


## file containing the sample names
SAMPLEFILE=samples.txt;

#rm "$SAMPLEFILE";


#mkdir RAWREADS; # storage of all raw seq files

#cp *.fastq.gz ./RAWREADS;


#cd RAWREADS;
#LIST=rawfiles.lst;

## find and list all files using the criteria ".fastq.gz";
#find *.fastq.gz > "$LIST";

#while read i;do 


#link=$(echo $i | sed 's/_S[0-9]*_/_/g' | sed 's/_001.fastq.gz/.fastq.gz/g');

## creat the actual symlink
#ln -s "$i" "$link";

#done < "$LIST"


## find and list only symlinks and create the actual "samples.txt" file for downstream analysis
#find ! -name . -prune -type l | sed 's/.\///g' | cut -f1 -d'_' | sort -u  > ./../"$SAMPLEFILE";

#cd ..
echo -e "list of all sampleNames\n\n\n";

cat "$SAMPLEFILE"; 

echo "if the sampleNames are NOT correct, ie punctuation, correct de renaming script lines! and start all over!!!!";

samplecnt=$(cat "$SAMPLEFILE" | wc -l);

echo -e "Current analysis project consists of $samplecnt samples\n" > "$GenRep";


# go to the root of the project






./00_structure.sh -w $WORKDIR -a $RAW_FASTQ -b $RAWSTATS -c $POLISHED -d $TRIMMEDSTATS -e $SHOVILL -f $QUAST -g $QUASTparse -h $MLST -i $MLSTparse -l $TMP -n $LOG -r $REPORTING -m $GENOMES -j $ABRICATE -k $AMRFINDER -s $STARAMR -t $RGI -q $ARCHIVE                  ; 

#./01_fastqc.sh -w $WORKDIR -a $RAW_FASTQ -b $RAWSTATS -r $REPORTING -q $ARCHIVE

#./02_polishdata.sh -w $WORKDIR -a $RAW_FASTQ -c $POLISHED -l $TMP -n $LOG -r $REPORTING -v $ADAPTERPATH -x $ADAPTER -q $ARCHIVE

#./03_fastqc.sh -w $WORKDIR -c $POLISHED -d $TRIMMEDSTATS -r $REPORTING -q $ARCHIVE

#./04_shovill.sh -w $WORKDIR -c $POLISHED -e $SHOVILL -y $ASSEMBLER -z $CONTIGLENGTH -r $REPORTING -m $GENOMES -q $ARCHIVE

#./05_quast.sh -w $WORKDIR -c $POLISHED -e $SHOVILL -f $QUAST -r $REPORTING -m $GENOMES -q $ARCHIVE

#./06_mlst.sh -w $WORKDIR -c $POLISHED -e $SHOVILL -h $MLST -r $REPORTING -q $ARCHIVE

#./06_mlst_parse.sh -w $WORKDIR -h $MLST -i $MLSTparse -l $TMP -q $ARCHIVE -r $REPORTING

#./07_abricate.sh -w $WORKDIR -m $GENOMES -j $ABRICATE -l $TMP -r $REPORTING -n $LOG -q $ARCHIVE

#./07a_prokka.sh -w $WORKDIR -m $GENOMES -j $PROKKA -l $TMP -r $REPORTING -n $LOG -q $ARCHIVE

#./08_amrfinder.sh -w $WORKDIR -m $GENOMES -l $TMP -n $LOG -r $REPORTING -k $AMRFINDER -q $ARCHIVE

#./09_staramr.sh -w $WORKDIR -m $GENOMES -l $TMP -n $LOG -r $REPORTING -s $STARAMR -q $ARCHIVE 

#./10_card-update-analysis.sh -w $WORKDIR -m $GENOMES -l $TMP -n $LOG -r $REPORTING -t $RGI -q $ARCHIVE

#./11_resfinder.sh -w $WORKDIR -h $MLST -m $GENOMES -l $TMP -n $LOG -r $REPORTING -c $POLISHED -u $RESFINDER -q $ARCHIVE

#./12_parse_resfinderdata.sh -w $WORKDIR -m $GENOMES -l $TMP -n $LOG -r $REPORTING -c $POLISHED -u $RESFINDER -q $ARCHIVE 

#./13_sraX.sh -w $WORKDIR -m $GENOMES -l $TMP -n $LOG -r $REPORTING -q $ARCHIVE -o $SRAX

./14_mumi.sh -w $WORKDIR -m $GENOMES -l $TMP -n $LOG -p $MUMI

#./15_catpac.sh -w $WORKDIR -m $GENOMES -l $TMP -n $LOG 

#./16_sendsketch.sh -w $WORKDIR -m $GENOMES -l $TMP -n $LOG 

# ./17_resfindergenes-mumi.sh

#./18_spatyping.sh -w $WORKDIR -m $GENOMES 

#./19_spifinder.sh -w $WORKDIR -m $GENOMES -c $POLISHED

#./20_isfinder.sh -w $WORKDIR -m $GENOMES 

#./21_iets.sh -w $WORKDIR -m $GENOMES 

./22_replicon.sh -w $WORKDIR -m $GENOMES

#./99_reporting.sh -w $WORKDIR -n $LOG -l $TMP -r $REPORTING -q $ARCHIVE





exit 1
