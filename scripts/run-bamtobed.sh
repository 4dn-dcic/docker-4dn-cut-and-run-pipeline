#!/bin/bash
set -eo pipefail
outname=$1
outdir=$2
bam=$3
if [[ $outdir ]]
then
    if [[ ! -d $outdir && $outdir != '.' ]]
    then
        mkdir $outdir
    fi
else
    outdir='.'
fi

# unzip bam file
unzipped=""
tmp_files=""

if [[ $bam =~ \.gz$ ]]
then
    gunzip -cf $bam > ${bam%".gz"}_tmp.bam
    tmp_files=1
    bam1=${bam%"bam.gz"}_tmp.bam
else
    bam1=$bam
fi

# sort bams
java -Xmx2G -jar /usr/local/bin/picard.jar SortSam INPUT=$bam1 OUTPUT=$outdir/$outname.sorted.tmp.bam VALIDATION_STRINGENCY=LENIENT SORT_ORDER=coordinate

# mark duplicates
java -Xmx2G -jar /usr/local/bin/picard.jar MarkDuplicates INPUT=$outdir/$outname.sorted.tmp.bam OUTPUT=$outdir/$outname.markdup.tmp.bam METRICS_FILE=$outdir/$outname.dup.qc VALIDATION_STRINGENCY=LENIENT

# remove duplicates and clean up
/usr/local/bin/samtools/samtools view -F 1024 -f 2 -b $outdir/$outname.markdup.tmp.bam > $outdir/$outname.dedup.tmp.bam

# re-sort by name for bamtobed
/usr/local/bin/samtools/samtools sort -n $outdir/$outname.dedup.tmp.bam > $outdir/$outname.dedup.sorted.tmp.bam

# convert to bedfile
bed1="${bam1%.bam}_tmp.bed"
bedtools bamtobed -i $outdir/$outname.dedup.sorted.tmp.bam -bedpe > $bed1
unzipped=$unzipped" $bed1"

# clean and sort for merging in next step
awk '$1==$4 && $1!="." && $6-$2 < 1000 {print $0}' $unzipped | cut -f 1-6 | sort -k1,1 -k2,2n -k3,3n | gzip -f > $outdir/${outname}.bedpe.gz

# remove temporary files
rm -f *_tmp.bed

if [[ $tmp_files ]]
then
    rm -f *_tmp.bam
fi
