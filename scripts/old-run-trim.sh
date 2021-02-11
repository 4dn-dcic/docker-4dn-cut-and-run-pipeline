#!/bin/bash

fastq1=$1
fastq2=$2
index=$3
threads=$4
outdirA=$5
outdirB=$6
outname=$7
len=$8


if [[ ! -d $outdirA ]]
then
    mkdir $outdirA
fi

if [[ ! -d $outdirB ]]
then
    mkdir $outdirB
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

# run trimmers
java jar Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads $threads $fastq1 $fastq2 -baseout $outdirA/$outname.fastq.gz ILLUMINACLIP:/Trimmomatic-0.36/adapters/Truseq3.PE.fa:2:15:4:1:true MINLEN:20
kseq_test $outdirA/${outname}_1P.fastq.gz $len $outdirB/${outname}_1P.fastq.gz
kseq_test $outdirA/${outname}_2P.fastq.gz $len $outdirB/${outname}_2P.fastq.gz
