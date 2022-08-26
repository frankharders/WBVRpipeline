#!/bin/bash

## spatyping will be on the first draft of the assembled genomes


##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate pip3;


#create several directories
while getopts "w:m:c:" opt; do
  case $opt in
    w)
      #echo "-w was triggered! $OPTARG"
      WORKDIR="`echo $(readlink -m $OPTARG)`"
      #echo $WORKDIR
      ;;
     a)
      #echo "-a was triggered! $OPTARG"
      RAW_FASTQ="`echo $(readlink -m $OPTARG)`"
      #echo $RAW_FASTQ
      ;;
     b)
      #echo "-b was triggered! $OPTARG"
      RAWSTATS="`echo $(readlink -m $OPTARG)`"
      #echo $RAWSTATS
      ;;
	 c)
      #echo "-c was triggered! $OPTARG"
      POLISHED="`echo $(readlink -m $OPTARG)`"
      #echo $POLISHED
      ;;
	 d)
      #echo "-d was triggered! $OPTARG"
      TRIMMEDSTATS="`echo $(readlink -m $OPTARG)`"
      #echo $TRIMMEDSTATS
      ;;
	 e)
      #echo "-e was triggered! $OPTARG"
      SHOVILL="`echo $(readlink -m $OPTARG)`"
      #echo $SHOVILL
      ;;
	 f)
      #echo "-f was triggered! $OPTARG"
      QUAST="`echo $(readlink -m $OPTARG)`"
      #echo $QUAST
      ;;
	 g)
      #echo "-g was triggered! $OPTARG"
      QUASTparse="`echo $(readlink -m $OPTARG)`"
      #echo $QUASTparse
      ;;
     h)
      #echo "-h was triggered! $OPTARG"
      MLST="`echo $(readlink -m $OPTARG)`"
      #echo $MLST
      ;;
     i)
      #echo "-i was triggered! $OPTARG"
      MLSTparse="`echo $(readlink -m $OPTARG)`"
      #echo $MLSTparse
      ;;	  
     j)
      #echo "-i was triggered! $OPTARG"
      ABRICATE="`echo $(readlink -m $OPTARG)`"
      #echo $ABRICATE
      ;;
	 l)
      #echo "-l was triggered! $OPTARG"
      TMP="`echo $(readlink -m $OPTARG)`"
      #echo $TMP
      ;;
	 m)
      #echo "-n was triggered! $OPTARG"
      GENOMES="`echo $(readlink -m $OPTARG)`"
      #echo $GENOMES
      ;;
	 n)
      #echo "-n was triggered! $OPTARG"
      LOG="`echo $(readlink -m $OPTARG)`"
      #echo $LOG
      ;;
	 o)
      #echo "-n was triggered! $OPTARG"
      SRAX="`echo $(readlink -m $OPTARG)`"
      #echo $SRAX
      ;;	  
	 p)
      #echo "-n was triggered! $OPTARG"
      MUMI="`echo $(readlink -m $OPTARG)`"
      #echo $MUMI
      ;;	
     r)
      #echo "-r was triggered! $OPTARG"
      REPORTING="`echo $(readlink -m $OPTARG)`"
      #echo $REPORTING
      ;;	  
     s)
      #echo "-r was triggered! $OPTARG"
      STARAMR="`echo $(readlink -m $OPTARG)`"
      #echo $STARAMR
      ;;
     t)
      #echo "-r was triggered! $OPTARG"
      RGI="`echo $(readlink -m $OPTARG)`"
      #echo $RGI
      ;;
     q)
      #echo "-r was triggered! $OPTARG"
      ARCHIVE="`echo $(readlink -m $OPTARG)`"
      #echo $ARCHIVE
      ;;	  
    \?)
      echo " Let's start some analysis" >&2
      ;;

  esac
done

if [ "x" == "x$WORKDIR" ] ; then
    echo "-w $WORKDIR "
    echo "-w, "
    exit 1
fi

## reporting
GenRep="$REPORTING"/general-report.txt;


count0=1;
countS=$(cat samples.txt | wc -l);


spiPATH='/home/wbvr006/GIT/spifinder/';
spiDB='/home/wbvr006/GIT/spifinder/spifinder_db/';





while [ $count0 -le $countS ];do

spiOUTC="$WORKDIR/19_spiOUT/$SAMPLE/contigs";
spiOUTR="$WORKDIR/19_spiOUT/$SAMPLE/reads";

mkdir -p "$spiOUTC";
mkdir -p "$spiOUTR";



	SAMPLE=$(cat samples.txt | awk 'NR=='$count0 );

spiInR1=$POLISHED/$SAMPLE/$SAMPLE'_R1.QTR.adapter.correct.fq.gz';
spiInR2=$POLISHED/$SAMPLE/$SAMPLE'_R2.QTR.adapter.correct.fq.gz';
spiInC=$GENOMES/$SAMPLE'_contigs.fa';

echo "sample=$SAMPLE";


#python3 $spiPATH/spifinder.py -i $spiInR1 $spiInR2 -p $spiDB -o $spiOUTR -mp kma -x;

python3 $spiPATH/spifinder.py -i $spiInC -p $spiDB -o $spiOUTC -mp blastn -x;



count0=$((count0+1));

done




exit 1

#spaTyper v1.0.0
#
#spaTyper - predicts the Staphylococcus aureus spa type from genome sequences
#Spa type sequences are used as queries to blast against a database from the genome sequences
#Subsequently, it matches the 5' and 3' ends of the spa type sequences that have 100% identity starting at position 1.
#
#
#Usage: spatyper.py <options>
#Ex: spatyper.py -i /path/to/isolate.fa.gz -db /path/to/spatyper_db/ -o /path/to/outdir
#
#
#For help, type: spatyper.py -h
#
#(amr-blast) wbvr006@lelycompute-01:/mnt/lely_scratch/wbvr006/BACT/Frank/MRSA39-4extra$ python3 /home/wbvr006/GIT/spatyper/spatyper.py -h
#usage: spatyper.py [-h] -i INPUTFILE [-db DATABASES] [-b BLASTPATH] [-o OUTDIR] [-no_tmp {True,False}] [-v]
#
#options:
#  -h, --help            show this help message and exit
#  -i INPUTFILE, --inputfile INPUTFILE
#                        FASTA files are accepted. Can be whole genome or contigs.
#  -db DATABASES, --databases DATABASES
#                        Path to the directory containing the database with the spa sequences.
#  -b BLASTPATH, --blastPath BLASTPATH
#                        Path to blast directory
#  -o OUTDIR, --outdir OUTDIR
#                        Output directory.
#  -no_tmp {True,False}, --remove_tmp {True,False}
#                        Remove temporary files after run. Default=True.
#  -v, --version         show program's version number and exit
















