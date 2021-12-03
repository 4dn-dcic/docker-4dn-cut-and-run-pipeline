#!/bin/bash
set -eo pipefail
bedgr=$1
control=$2
norm=$3
stringency=$4
out=$5
outdir=$6

two_bgs=false
two_ctls=false

if [[ $outdir ]]
then
    if [[ ! -d $outdir && $outdir != '.' ]]
    then
        mkdir $outdir
    fi
else
    outdir='.'
fi

# unzip bg files
if [[ $bedgr =~ \.gz$ ]]
then
    two_bgs=true
    if ! gunzip -k $bedgr
    then
        echo "Bedgraph data file with extension .gz is not gzipped."
        cp $bedgr ${bedgr%.gz}
    fi
    bedgr=${bedgr%.gz}
fi

if [[ $control =~ \.gz$ ]]
then
    two_ctls=true
    if ! gunzip -k $control
    then
        echo "Bedgraph control file with extension .gz is not gzipped"
        cp $control ${control%.gz}
    fi
    control=${control%.gz}
fi

# call SEACR with given settings
if ! /usr/local/bin/SEACR/SEACR_1.3.sh $bedgr $control $norm $stringency $outdir/$out.$norm.peaks.tmp > $outdir/$out.logs; then
	echo "SEACR encountered an error. Please reference the logs:"
	cat $outdir/$out.logs
fi

# split into two files
awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4}' $outdir/$out.$norm.peaks.tmp.$stringency.bed > $outdir/$out.$norm.peaks.$stringency.bedgraph
awk -F '[\t:-]' 'BEGIN{OFS="\t"}{print $6, $7, $8}' $outdir/$out.$norm.peaks.tmp.$stringency.bed > $outdir/$out.$norm.peaks.narrow.bed

gzip -f $outdir/$out.$norm.peaks.$stringency.bedgraph $outdir/$out.$norm.peaks.narrow.bed

# remove temporary files
rm -f $outdir/$out.$norm.peaks.tmp.$stringency.bed
if $two_bgs
then
    rm -f $bedgr
fi
if $two_ctls
then
    rm -f $control
fi
