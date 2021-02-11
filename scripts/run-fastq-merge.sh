#!/bin/bash
set -eo pipefail
outname=$1
outdir=$2
shift 2
fastqs=${@}

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
unzipped=""
tmp_files=""
for f in $fastqs
do

if [[ $f =~ \.gz$ ]]
then
    cp $f a_fastq$f
    gunzip -f a_fastq$f
    tmp_files=1
    fastq1=a_fastq${f%".gz"}
else
    fastq1=$f
fi
unzipped=$unzipped" $fastq1"
done
echo $unzipped

# unzip and merge all
cat $unzipped | gzip -f > $outdir/${outname}.fastq.gz

# remove temporary files
if [[ $tmp_files ]]
then
    rm a_fastq*
fi

