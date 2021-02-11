#!/bin/bash
set -eo pipefail
outname=$1
outdir=$2
shift 2
bams=${@}

if [[ $outdir ]]
then
    if [[ ! -d $outdir && $outdir != '.' ]]
    then
        mkdir $outdir
    fi
else
    outdir='.'
fi

# unzip bed files
unzipped=""
tmp_files=""
for f in $bams
do

if [[ $f =~ \.gz$ ]]
then
    cp $f a_bam_$f
    gunzip -f a_bam_$f
    tmp_files=1
    bam1=a_bam_${f%".gz"}
else
    bam1=$f
fi
bed1="tmp_${bam1%.bam}.bed"
bedtools bamtobed -bedpe -i $bam1 > $bed1
unzipped=$unzipped" $bed1"
done

# clean, sort, and merge all
awk '$1==$4 && $1!="." && $6-$2 < 1000 {print $0}' $unzipped | cut -f 1,2,6 | sort -k1,1 -k2,2n -k3,3n | gzip -f > $outdir/${outname}.bedpe.gz

# remove temporary files
rm tmp_*.bed

if [[ $tmp_files ]]
then
    rm a_bam_*
fi
