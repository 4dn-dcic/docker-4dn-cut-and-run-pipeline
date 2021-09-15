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
/usr/local/bin/SEACR/SEACR_1.3.sh $bedgr $control $norm $stringency $outdir/$out.$norm.peaks > $outdir/$out.logs
gzip -f $outdir/$out.$norm.peaks.$stringency.bed

# remove temporary files
if $two_bgs
then
    rm -f $bedgr
fi
if $two_ctls
then
    rm -f $control
fi
