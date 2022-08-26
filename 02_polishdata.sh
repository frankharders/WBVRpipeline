#!/bin/bash

##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate amr-bbmap;


cnt=$(cat samples.txt | wc -l);

while getopts "w:a:c:l:n:r:v:x:q:" opt; do
  case $opt in
    w)
      echo "-w was triggered! $OPTARG"
      WORKDIR="`echo $(readlink -m $OPTARG)`"
      echo $WORKDIR
      ;;
     a)
      echo "-a was triggered! $OPTARG"
      RAW_FASTQ="`echo $(readlink -m $OPTARG)`"
      echo $RAW_FASTQ
      ;;
     b)
      echo "-b was triggered! $OPTARG"
      RAWSTATS="`echo $(readlink -m $OPTARG)`"
      echo $RAWSTATS
      ;;
	 c)
      echo "-c was triggered! $OPTARG"
      POLISHED="`echo $(readlink -m $OPTARG)`"
      echo $POLISHED
      ;;
	 d)
      echo "-d was triggered! $OPTARG"
      TRIMMEDSTATS="`echo $(readlink -m $OPTARG)`"
      echo $TRIMMEDSTATS
      ;;
	 e)
      echo "-e was triggered! $OPTARG"
      SHOVILL="`echo $(readlink -m $OPTARG)`"
      echo $SHOVILL
      ;;
	 f)
      echo "-f was triggered! $OPTARG"
      QUAST="`echo $(readlink -m $OPTARG)`"
      echo $QUAST
      ;;
	 g)
      echo "-g was triggered! $OPTARG"
      QUASTparse="`echo $(readlink -m $OPTARG)`"
      echo $QUASTparse
      ;;
     h)
      echo "-h was triggered! $OPTARG"
      MLST="`echo $(readlink -m $OPTARG)`"
      echo $MLST
      ;;
     i)
      echo "-i was triggered! $OPTARG"
      MLSTparse="`echo $(readlink -m $OPTARG)`"
      echo $MLSTparse
      ;;	  
	 j)
      echo "-j was triggered! $OPTARG"
      ABRICATE="`echo $(readlink -m $OPTARG)`"
      echo $ABRICATE
      ;;
     k)
      echo "-k was triggered! $OPTARG"
      ABRICATEparse="`echo $(readlink -m $OPTARG)`"
      echo $ABRICATEparse
      ;;	  
	 l)
      echo "-l was triggered! $OPTARG"
      TMP="`echo $(readlink -m $OPTARG)`"
      echo $TMP
      ;;	  
	 n)
      echo "-n was triggered! $OPTARG"
      LOG="`echo $(readlink -m $OPTARG)`"
      echo $LOG
      ;;
     r)
      echo "-r was triggered! $OPTARG"
      REPORTING="`echo $(readlink -m $OPTARG)`"
      echo $REPORTING
      ;;
	 v)
      echo "-v was triggered! $OPTARG"
      ADAPTERPATH="`echo $(readlink -m $OPTARG)`"
      echo $ADAPTERPATH
      ;;
     x)
      echo "-x was triggered! $OPTARG"
      ADAPTER=$OPTARG
      echo $ADAPTER
      ;;
	 q)
      echo "-x was triggered! $OPTARG"
      ARCHIVE=$OPTARG
      echo $ARCHIVE
      ;;  
    \?)
      echo "-i for the folder containing fastq files, -o for output folder of polished data: -$OPTARG" >&2
      ;;
  esac
done

if [ "x" == "x$WORKDIR" ] || [ "x" == "x$RAW_FASTQ" ] || [ "x" == "x$POLISHED" ] || [ "x" == "x$TMP" ] || [ "x" == "x$LOG" ] || [ "x" == "x$REPORTING" ] || [ "x" == "x$ADAPTERPATH" ] || [ "x" == "x$ADAPTER" ]; then
    echo "-w $WORKDIR -a $RAW_FASTQ -c $POLISHED -l $TMP -n $LOG -r $REPORTING -v $ADAPTERPATH -x $ADAPTER"
    echo "-w, -a, -c, -l, -n, -r, -v, -x [options] are required"
    exit 1
fi

## reporting
GenRep="$REPORTING"/general-report.txt;


# (temp) variables

KTRIM='r';
TRIMQ=20;
QTRIM='rl';
TARGET=60;

while read SAMPLE; do 

OUTdir=$POLISHED/$SAMPLE;

mkdir -p $OUTdir;

	echo $SAMPLE;
LOG0=$LOG/$SAMPLE'.filterbytile.log';
LOG1=$LOG/$SAMPLE'.interleave.log';
LOG2=$LOG/$SAMPLE'.correct.log';
LOG3=$LOG/$SAMPLE'.adapterclip.log';
LOG4=$LOG/$SAMPLE'.qualitytrim.log';
LOG5=$LOG/$SAMPLE'.bbmerge.log';
LOG6=$LOG/$SAMPLE'.bbnorm.log';


R1=$RAW_FASTQ/$SAMPLE'_R1.fastq.gz';
R2=$RAW_FASTQ/$SAMPLE'_R2.fastq.gz';	
FILTERED1=$TMP/$SAMPLE'_R1.filterbytile.fq.gz';
FILTERED2=$TMP/$SAMPLE'_R2.filterbytile.fq.gz';
CORRECTED1=$TMP/$SAMPLE'_R1.correct.fq.gz';
CORRECTED2=$TMP/$SAMPLE'_R2.correct.fq.gz';
ADAPTERout1=$TMP/$SAMPLE'_R1.adapter.fq.gz';
ADAPTERout2=$TMP/$SAMPLE'_R2.adapter.fq.gz';
QUALout1=$TMP/$SAMPLE'_R1.qual.fq.gz';
QUALout2=$TMP/$SAMPLE'_R2.qual.fq.gz';
	
	
OUTPUT1=$OUTdir/$SAMPLE'_R1.QTR.adapter.correct.fq.gz';
OUTPUT2=$OUTdir/$SAMPLE'_R2.QTR.adapter.correct.fq.gz';	

HISTout=$OUTdir/$SAMPLE'.ihist.txt';

echo -e "R1=$R1";
echo -e "R2=$R2";

REF=$ADAPTERPATH/$ADAPTER'.fa.gz';
echo -e "$REF";


# Filter bad focussed clusters from original data
filterbytile.sh in1=$R1 in2=$R2 out1=$FILTERED1 out2=$FILTERED2 ow=t > $LOG0 2>&1;
# INTERLEAVE READS	
#reformat.sh in=$FILTERED1 in2=$FILTERED2 out=$INTERLEAVED ow=t > $LOG1 2>&1;
# READ ERROR CORRECTION
tadpole.sh in1=$FILTERED1 in2=$FILTERED2 out1=$CORRECTED1 out2=$CORRECTED2 mode=correct ow=t > $LOG2 2>&1;
# ADAPTER TRIM
bbduk.sh -Xmx12g in1=$CORRECTED1 in2=$CORRECTED2 out1=$ADAPTERout1 out2=$ADAPTERout2 ktrim=$KTRIM ref=$REF k=13 mink=6 ignorejunk=t ow=t > $LOG3 2>&1;
# QUALITY TRIM
bbduk.sh -Xmx12g in1=$ADAPTERout1 in2=$ADAPTERout2 out1=$QUALout1 out2=$QUALout2 qtrim=$QTRIM trimq=$TRIMQ ow=t > $LOG4 2>&1;
# Normalise reads for better assemblies
bbnorm.sh -Xmx12g in1=$QUALout1 in2=$QUALout2 out1=$OUTPUT1 out2=$OUTPUT2 target=$TARGET min=5 ow=t > $LOG6 2>&1;
# Calc insertSize from reads
bbmerge.sh in1=$OUTPUT1 in2=$OUTPUT2 ihist=$HISTout ow=t > $LOG5 2>&1;

	
	let cnt--;	
	echo -e "$cnt samples to go!";
	echo "NEXT";

#rm $FILTERED1 $FILTERED2 $CORRECTED1 $CORRECTED2 $ADAPTER1 $ADAPTER2;

	
		done < samples.txt
		
polishCnt=$(ls $POLISHED/*/*.ihist.txt | wc -l);

echo -e "\nbbmap polishing\nfrom $polishCnt samples fastq files are polished\n" >> "$GenRep";		

echo "read polishing is done for all samples";
echo -e "output files for downstream processing can be found in the directory $PROCESSED";


cp -r $POLISHED $ARCHIVE;
		
exit 1

