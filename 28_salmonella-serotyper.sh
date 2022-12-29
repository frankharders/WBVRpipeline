#!/bin/bash
#
### salmonella serotyping using seqzero.2


##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate amr-serotypefinder;


count0=1;
countS=$(cat samples.txt | wc -l);

mkdir -p "$PWD"/28_salmonellaSerotyping;


seroPATH='/home/wbvr006/GIT/salmonellatypefinder';
seroDB='/home/wbvr006/GIT/salmonellatypefinder/mlst_db/';
seroOUT="$PWD"/28_salmonellaSerotyping;


count0=1;
countS=$(cat samples.txt | wc -l);


while [ $count0 -le $countS ];do

rm -r "seroOUT/$SAMPLE";

mkdir -p "$seroOUT/$SAMPLE";



	SAMPLE=$(cat samples.txt | awk 'NR=='$count0 );

seroIn="$PWD"/genomes/$SAMPLE'_contigs.fa';

echo "sample=$SAMPLE";


python3 $seroPATH/SalmonellaTypeFinder.py -s paired -o $seroOUT/$SAMPLE -d1 $seroDB ./02_polished/$SAMPLE/$SAMPLE*.QTR.adapter.correct.fq.gz ;

#cat $spaOUT/$SAMPLE/*.tsv > $spaOUT/$SAMPLE/$SAMPLE.tsv;

count0=$((count0+1));

done

exit 1

#usage: SalmonellaTypeFinder.py [-h] [-s {paired,single,assembled}]
#                               [-o OUTPUT_TXT] [-t TMP_DIR] [-d JSON_MLST_DB]
#                               [-m INT] [-f FRAC] [-st ST]
#                               [--seromethod {seqsero,seqsero2}] [-p1 CGEMLST]
#                               [-d1 CGEMLSTDB] [--python3 PYTHON3]
#                               [--python2 PYTHON2] [--python2_env TXT]
#                               [--seqsero SEQSERO] [--blastn BLASTN]
#                               [--makeblastdb MAKEBLASTDB]
#                               [--samtools SAMTOOLS] [--bwa BWA]
#                               [--seqsero2 SEQSERO2]
#                               FAST(Q|A) [FAST(Q|A) ...]
#
#Given raw data or an assembly files outputs the Serotype and MLST.
#
#positional arguments:
#  FAST(Q|A)             Raw data in FASTQ format. Takes 1 (single-end) or 2
#                        (paired-end) arguments.
#
#optional arguments:
#  -h, --help            show this help message and exit
#  -s {paired,single,assembled}, --seq_type {paired,single,assembled}
#                        Type of sequence: paired, single or assembled
#  -o OUTPUT_TXT, --output OUTPUT_TXT
#                        Path to file in which the results will be stored.
#  -t TMP_DIR, --tmp_dir TMP_DIR
#                        Temporary directory for storage of the results from
#                        the external software.
#  -d JSON_MLST_DB, --mlst_db JSON_MLST_DB
#                        JSON formatted database used to predict serotypes from
#                        MLST type. This option defaults to a database named
#                        'db.json' located in the 'data' directory.
#  -m INT, --mask_low_count_mlst INT
#                        In the mlst<-->serovar database, ignore entries with
#                        this number of isolates or fewer. This influences the
#                        detailed MLST serovar output, but also the threshold
#                        calculation, because the ignored entries will not be
#                        included in the total sum of isolates with the given
#                        MLST type and serovar. Default: 2
#  -f FRAC, --fraction FRAC
#                        Fraction of entries in mlst<-->serovar database that
#                        needs to agree in order to call a serovar based on a
#                        MLST type. Default: 0.75
#  -st ST, --mlst ST     Optional. MLST type written as an integer. If given,
#                        the programme will not find an MLST type but use the
#                        one provided.
#  --seromethod {seqsero,seqsero2}
#                        Determines which version of SeqSero to use. Options
#                        are 'seqsero' and 'seqsero2'. Note SeqSero2 is not yet
#                        published and is currently still in the development
#                        stage. Default: seqsero
#  -p1 CGEMLST, --cgemlst_path CGEMLST
#                        Path to cge mlst tool. Default: mlst.py
#  -d1 CGEMLSTDB, --cgemlstdb_path CGEMLSTDB
#                        Path to mlst database used for cge mlst tool.
#  --python3 PYTHON3     Path to python3. Default: path to calling interpreter.
#  --python2 PYTHON2     Path to python2.7. Default: python2.7
#  --python2_env TXT     Path to a list of commands that will be executed just
#                        before executing SeqSero. On most systems this won't
#                        be necessary. The commands to be executed can set the
#                        environment needed for SeqSero to run (e.g., the
#                        python 2.7 environment).
#  --seqsero SEQSERO     Path to SeqSero.py. Default: SeqSero.py
#  --blastn BLASTN       Path to blastn. Default: blastn
#  --makeblastdb MAKEBLASTDB
#                        Path to makeblastdb. Default: makeblastdb
#  --samtools SAMTOOLS   Path to samtools v. 0.18. Default: samtools
#  --bwa BWA             Path to bwa. Default: bwa
#  --seqsero2 SEQSERO2   Path to SeqSero2_package.py. Default:
#                        SeqSero2_package.py
#
