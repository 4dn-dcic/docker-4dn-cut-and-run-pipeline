#!/bin/bash
set -eo pipefail
bam=$1
control=$2
genome=$3
chr_sizes=$4
norm=$5
stringency=$6
outdir=$7
out=$8


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

# convert to bed
bedtools bamtobed -bedpe -i ${bam}_R1.bam > ${out}_R1.bed
bedtools bamtobed -bedpe -i ${bam}_R2.bam > ${out}_R2.bed
# MISSING: MERGE to OUT.bed #
awk '$1==$4 && $6-$2 < 1000 {print $0}' $control.bed > $control.clean.bed
awk '$1==$4 && $6-$2 < 1000 {print $0}' $out.bed > $out.clean.bed
cut -f 1,2,6 $control.clean.bed | sort -k1,1 -k2,2n -k3,3n > $control.sorted.bed
cut -f 1,2,6 $out.clean.bed | sort -k1,1 -k2,2n -k3,3n > $out_merge.sorted.bed
bedtools genomecov -bg -i $control.sorted.bed -g $genome > $control.bedgraph
bedtools genomecov -bg -i $out.sorted.bed -g $chr_sizes > $out.bedgraph
SEACR/SEACR_1.3.sh ${out}.bedgraph $control.bedgraph $norm $stringency $out.peaks
