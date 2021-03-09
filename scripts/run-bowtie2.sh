#!/bin/bash
set -eo pipefail
fastq1=$1
fastq2=$2
index=$3
threads=$4
outname=$5
outdir=$6

if [[ $outdir ]]
then
    if [[ ! -d $outdir && $outdir != '.' ]]
    then
        mkdir $outdir
    fi
else
    outdir='.'
fi

tar -xzf $index
index=`ls -1 *.bt2 | head -1 | sed 's/.1.bt2//'`

tmp1=""
tmp2=""
# unzip fastq files
if [[ $fastq1 =~ \.gz$ ]]
then
    cp $fastq1 fastq1.gz
    gunzip fastq1.gz
    tmp1=1
else
    cp $fastq1 fastq1
fi
    fastq1=fastq1

if [[ $fastq2 =~ \.gz$ ]]
then
    cp $fastq2 fastq2.gz
    gunzip fastq2.gz
    tmp2=1
else
    cp $fastq2 fastq2
fi
    fastq2=fastq2

# run bowtie2
bowtie2 --dovetail --threads $threads -x $index -1 $fastq1 -2 $fastq2 > $outdir/${outname}.bam

# remove temporary files
rm -f $fastq1
rm -f $fastq2
