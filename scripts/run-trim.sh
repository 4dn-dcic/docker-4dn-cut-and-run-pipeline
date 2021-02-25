#!/bin/bash
set -eo pipefail
fastq1=$1
fastq2=$2
threads=$3
outname=$4
outdir=$5

if [[ $outdir ]]
then
    if [[ ! -d $outdir && $outdir != '.' ]]
    then
        mkdir $outdir
    fi
else
    outdir='.'
fi

# run trimmers
java -jar Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads $threads $fastq1 $fastq2 -baseout $outdir/$outname.fastq.gz ILLUMINACLIP:/Trimmomatic-0.36/adapters/Truseq3.PE.fa:2:15:4:1:true MINLEN:20

