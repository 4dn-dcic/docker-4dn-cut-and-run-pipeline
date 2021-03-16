#!/bin/bash
set -eo pipefail
outname=$1
outdir=$2
shift 2
bams=${@}
echo $bams
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
    gunzip -cf $f > ${f%".gz"}_tmp.bam
    tmp_files=1
    bam1=${f%"bam.gz"}_tmp.bam
else
    bam1=$f
fi
bed1="${bam1%.bam}_tmp.bed"
bedtools bamtobed -i $bam1 -bedpe > $bed1
unzipped=$unzipped" $bed1"
done

# clean, sort, and merge all
awk '$1==$4 && $1!="." && $6-$2 < 1000 {print $0}' $unzipped | cut -f 1-6 | sort -k1,1 -k2,2n -k3,3n | gzip -f > $outdir/${outname}.bedpe.gz

# remove temporary files
rm -f *_tmp.bed

if [[ $tmp_files ]]
then
    rm -f *_tmp.bam
fi
