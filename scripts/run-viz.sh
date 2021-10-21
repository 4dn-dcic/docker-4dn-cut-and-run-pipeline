#!/bin/bash
set -eo pipefail
bedpe=$1
chr_sizes=$2
base_direc=$3
out=$4
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

gunzip -k $bedpe
base=${bedpe%.gz}

# call gaussian smoother
python3 /usr/local/bin/call_gauss.py --in_bedpe ${base} --chr_sizes $chr_sizes --outname $outdir/$out.bedgraph --base_direc $base_direc

if ! $is_ctl
then
    /usr/local/bin/bedGraphToBigWig $outdir/$out.bedgraph $chr_sizes $outdir/$out.bw
fi

gzip -f $outdir/$out.bedgraph

rm ${bedpe%.gz}
