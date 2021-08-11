#!/bin/bash
set -eo pipefail
bedgr=$1
control=$2
norm=$3
stringency=$4
out=$5
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

# unzip fastq files
if [[ $bedgr =~ \.gz$ ]]
then
    cp $bedgr bedgr_tmp.bedgraph.gz
    gunzip bedgr_tmp.bedgraph.gz
else
    cp $bedgr bedgr_tmp.bedgraph
fi
    bedgr=bedgr_tmp.bedgraph

if [[ $control =~ \.gz$ ]]
then
    cp $control control_tmp.bedgraph.gz
    gunzip control_tmp.bedgraph.gz
else
    cp $control control_tmp.bedgraph
fi
    control=control_tmp.bedgraph


# call SEACR with given settings
/usr/local/bin/SEACR/SEACR_1.3.sh $bedgr $control $norm $stringency $outdir/$out.$norm.peaks

# remove temporary files
rm -f $bedgr
rm -f $control
