#!/bin/bash
set -eo pipefail
outname=$1
outdir=$2
shift 2
bedpes=${@}
if [[ $outdir ]]
then
    if [[ ! -d $outdir && $outdir != '.' ]]
    then
        mkdir $outdir
    fi
else
    outdir='.'
fi

# unzip bedpe files
unzipped=""
tmp_files=""
for f in $bedpes
do

if [[ $f =~ \.gz$ ]]
then
    gunzip -cf $f > ${f%".gz"}_tmp.bedpe
    tmp_files=1
    bedpe1=${f%".gz"}_tmp.bedpe
else
    bedpe1=$f
fi

unzipped="$unzipped $bedpe1"

done
echo $unzipped
# clean, sort, and merge all
sort -m $unzipped | gzip -fc > $outdir/${outname}.bedpe.gz

if [[ $tmp_files ]]
then
    rm -f *_tmp.bedpe
fi
