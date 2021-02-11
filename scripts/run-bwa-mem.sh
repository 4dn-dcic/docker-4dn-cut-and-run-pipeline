#!/bin/bash

fastq1=$1
fastq2=$2
index=$3
threads=$4
outdir=$5
outname=$6


if [[ ! -d $outdir ]]
then
    mkdir $outdir
fi

# unzip fastq files
if [[ $fastq1 =~ \.gz$ ]]
then
    cp $fastq1 fastq1.gz
    gunzip fastq1.gz
else
    cp $fastq1 fastq1
fi
    fastq1=fastq1

if [[ $fastq2 =~ \.gz$ ]]
then
    cp $fastq2 fastq2.gz
    gunzip fastq2.gz
else
    cp $fastq2 fastq2
fi
    fastq2=fastq2

# run bwa
bwa mem -t $threads $index $fastq1 $fastq2 | samtools view -Shb - > $outdir/$outname.bam
