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

# call SEACR with given settings
SEACR/SEACR_1.3.sh ${bedgr}.bedgraph $control.bedgraph $norm $stringency $outdir/$out.$norm.peaks
