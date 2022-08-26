#!/bin/bash

##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate amr-typing;

cnt=$(cat samples.txt | wc -l);

while getopts "w:c:e:h:r:" opt; do
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
	\?)
      echo "-i for the folder containing assembled genome files, -o for output folder: -$OPTARG" >&2
      ;;

  esac
done

if [ "x" == "x$WORKDIR" ] || [ "x" == "x$POLISHED" ] || [ "x" == "x$SHOVILL" ] || [ "x" == "x$MLST" ] || [ "x" == "x$REPORTING" ]; then
    echo "-w $WORKDIR -c $POLISHED -e $SHOVILL -h $MLST -r $REPORTING"
    echo "-w, -c, -e, -h, -r  [options] are required"
    exit 1
fi

## reporting
GenRep="$REPORTING"/general-report.txt;

# (temp) variables

##### MLST typing via https://github.com/tseemann/mlst - Torsten Seemann #####


while read SAMPLE; do 

	echo $SAMPLE;
	
INPUTdir=$SHOVILL/$SAMPLE/;


MLSTin=$INPUTdir/$SAMPLE'_contigs.fa';
MLSTout=$MLST/$SAMPLE'.mlst.csv';

mlst $MLSTin --quiet --csv --nopath > $MLSTout;

	let cnt--;	
	echo -e "$cnt samples to go!";
	echo "NEXT";
				
done < samples.txt

echo "mlst analysis is done for all samples";
echo -e "output files for downstream processing can be found in the directory $MLST";

mlstCnt=$(ls $MLST/*.csv | wc l);

echo -e "\nMLST\nfrom $mlstCnt samples a MLST pattern generated\n" >> "$GenRep"; 		


exit 1

##### manual MLST calling from assembled genomes
#
#SYNOPSIS
#  Automatic MLST calling from assembled contigs
#USAGE
#  % mlst --list                                            # list known schemes
#  % mlst [options] <contigs.{fasta,gbk,embl}[.gz]          # auto-detect scheme
#  % mlst --scheme <scheme> <contigs.{fasta,gbk,embl}[.gz]> # force a scheme
#GENERAL
#  --help            This help
#  --version         Print version and exit(default ON)
#  --check           Just check dependencies and exit (default OFF)
#  --quiet           Quiet - no stderr output (default OFF)
#  --threads [N]     Number of BLAST threads (suggest GNU Parallel instead) (default '1')
#  --debug           Verbose debug output to stderr (default OFF)
#SCHEME
#  --scheme [X]      Don't autodetect, force this scheme on all inputs (default '')
#  --list            List available MLST scheme names (default OFF)
#  --longlist        List allelles for all MLST schemes (default OFF)
#  --exclude [X]     Ignore these schemes (comma sep. list) (default 'ecoli_2,abaumannii')
#OUTPUT
#  --csv             Output CSV instead of TSV (default OFF)
#  --json [X]        Also write results to this file in JSON format (default '')
#  --label [X]       Replace FILE with this name instead (default '')
#  --nopath          Strip filename paths from FILE column (default OFF)
#  --novel [X]       Save novel alleles to this FASTA file (default '')
#  --legacy          Use old legacy output with allele header row (requires --scheme) (default OFF)
#SCORING
#  --minid [n.n]     DNA %identity of full allelle to consider 'similar' [~] (default '95')
#  --mincov [n.n]    DNA %cov to report partial allele at all [?] (default '10')
#  --minscore [n.n]  Minumum score out of 100 to match a scheme (when auto --scheme) (default '50')
#PATHS
#  --blastdb [X]     BLAST database (default '/home/harde004/.conda/envs/POPPUNK/bin/../db/blast/mlst.fa')
#  --datadir [X]     PubMLST data (default '/home/harde004/.conda/envs/POPPUNK/bin/../db/pubmlst')
#HOMEPAGE
#  https://github.com/tseemann/mlst - Torsten Seemann




