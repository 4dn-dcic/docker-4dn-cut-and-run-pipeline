## SOFTWARE: bedtools
## VERSION: 2.29.0
## TYPE: genome arithmetic
## SOURCE_URL: https://github.com/arq5x/bedtools2
git clone --branch v2.29.0 --single-branch https://github.com/arq5x/bedtools2.git
cd bedtools2
make
make install
cd ../

## SOFTWARE: bedGraphToBigWig
## VERSION: Latest
## TYPE: format conversion
## SOURCE_URL: http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bedGraphToBigWig
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bedGraphToBigWig
chmod +x bedGraphToBigWig

## SOFTWARE: bowtie2
## VERSION: 2.2.6
## TYPE: alignment
## SOURCE_URL: https://github.com/BenLangmead/bowtie2/releases/download/v2.2.6/bowtie2-2.2.6-linux-x86_64.zip
wget https://github.com/BenLangmead/bowtie2/releases/download/v2.2.6/bowtie2-2.2.6-linux-x86_64.zip
unzip bowtie2-2.2.6-linux-x86_64.zip && mv bowtie2*/bowtie2* . && rm -rf bowtie2-2.2.6*

## SOFTWARE: samtools
## VERSION: 1.9
## TYPE: file format conversion
## SOURCE_URL: https://github.com/samtools/samtools
wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
tar -xjf samtools-1.9.tar.bz2
cd samtools-1.9
make
cd ..
ln -s samtools-1.9 samtools

## SOFTWARE: SEACR
## VERSION: 1.3
## TYPE: peak calling
## SOURCE_URL: https://github.com/FredHutch/SEACR
git clone https://github.com/FredHutch/SEACR.git

## SOFTWARE: Trimmomatic
## VERSION: 0.36
## TYPE: adapter trimming
## SOURCE_URL: https://github.com/timflutre/trimmomatic
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip
unzip Trimmomatic-0.36.zip && rm Trimmomatic-0.36.zip

