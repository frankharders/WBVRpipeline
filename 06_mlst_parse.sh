#!/bin/bash

##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate amr-typing;

cnt=$(cat samples.txt | wc -l);

while getopts "w:h:i:l:r:" opt; do
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
      echo "-i for the folder containing fastq files, -o for output folder of polished data: -$OPTARG" >&2
      ;;
  esac
done


if [ "x" == "x$WORKDIR" ] || [ "x" == "x$MLSTparse" ] || [ "x" == "x$TMP" ]; then
    echo "-w $WORKDIR -h $MLST -i $MLSTparse -l $TMP"
    echo "-w, -h, -i, -l  [options] are required"
    exit 1
fi

## reporting
GenRep="$REPORTING"/general-report.txt;

ToDay=$(date +%Y-%m-%d-%T);


MLSTfinal=$MLSTparse/'all_samples_general_MLST.tab'_"$ToDay";


while read SAMPLE;do

MLSTout=$MLST/$SAMPLE'.mlst.csv';
PARSEout=$MLSTparse/$SAMPLE/$SAMPLE'.mlstout.csv';

NAME=$(cat $MLSTout | cut -f1 -d',' );
SCHEME=$(cat $MLSTout | cut -f2 -d',');
ST=$(cat $MLSTout | cut -f3 -d',');


GENE1=$(cat $MLSTout | cut -f4 -d',' | cut -f1 -d'(' );
OUT1=$(cat $MLSTout | cut -f4 -d',' | cut -f1 -d')' | cut -f2 -d'(' );
GENE2=$(cat $MLSTout | cut -f5 -d',' | cut -f1 -d'(' );
OUT2=$(cat $MLSTout | cut -f5 -d',' | cut -f1 -d')' | cut -f2 -d'(' );
GENE3=$(cat $MLSTout | cut -f6 -d',' | cut -f1 -d'(' );
OUT3=$(cat $MLSTout | cut -f6 -d',' | cut -f1 -d')' | cut -f2 -d'(' );
GENE4=$(cat $MLSTout | cut -f7 -d',' | cut -f1 -d'(' );
OUT4=$(cat $MLSTout | cut -f7 -d',' | cut -f1 -d')' | cut -f2 -d'(' );
GENE5=$(cat $MLSTout | cut -f8 -d',' | cut -f1 -d'(' );
OUT5=$(cat $MLSTout | cut -f8 -d',' | cut -f1 -d')' | cut -f2 -d'(' );
GENE6=$(cat $MLSTout | cut -f9 -d',' | cut -f1 -d'(' );
OUT6=$(cat $MLSTout | cut -f9 -d',' | cut -f1 -d')' | cut -f2 -d'(' );
GENE7=$(cat $MLSTout | cut -f10 -d',' | cut -f1 -d'(' );
OUT7=$(cat $MLSTout | cut -f10 -d',' | cut -f1 -d')' | cut -f2 -d'(' );


echo -e "$NAME\t$SCHEME\t$ST\t$GENE1\t$GENE2\t$GENE3\t$GENE4\t$GENE5\t$GENE6\t$GENE7";
echo -e "$NAME\t$SCHEME\t$ST\t$OUT1\t$OUT2\t$OUT3\t$OUT4\t$OUT5\t$OUT6\t$OUT7";

echo -e "NAME\tSCHEME\tST\t$GENE1\t$GENE2\t$GENE3\t$GENE4\t$GENE5\t$GENE6\t$GENE7" >> $PARSEout;
echo -e "$NAME\t$SCHEME\t$ST\t$OUT1\t$OUT2\t$OUT3\t$OUT4\t$OUT5\t$OUT6\t$OUT7" >> $PARSEout;

echo -e "NAME\tSCHEME\tST\t$GENE1\t$GENE2\t$GENE3\t$GENE4\t$GENE5\t$GENE6\t$GENE7" >> $MLSTfinal;
echo -e "$NAME\t$SCHEME\t$ST\t$OUT1\t$OUT2\t$OUT3\t$OUT4\t$OUT5\t$OUT6\t$OUT7" >> $MLSTfinal;

	let cnt--;	
	echo -e "$cnt samples to go!";
	echo "NEXT";

done < samples.txt

echo "parsing the mlst output files is done for all samples";
echo -e "output files for downstream processing can be found in the directory $MLSTparse";

mlstCnt=$(ls $MLSTparse/*/*.csv | wc l);

echo -e "\nfrom $mlstCnt samples a MLST pattern generated\n" >> "$GenRep"; 		


exit 1
