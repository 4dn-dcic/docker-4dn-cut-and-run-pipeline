#!/usr/bin/env python3
import sys
import os
import argparse
import numpy as np
import gauss_smooth as gs
from operator import itemgetter

def main(args):
    direc = str(args.base_direc or '')
    in_file = direc + args.in_bedpe
    chr_sizes = direc + args.chr_sizes
    out = direc + args.outname
    if os.path.exists(out):
        os.remove(out)
    sizes = {}
    with open(chr_sizes) as f:
        sizes = dict([ln.split() for ln in f])

    with open(in_file) as f:
        v = np.loadtxt(f, delimiter='\t', dtype='U9', comments='#', skiprows=0, usecols=(0,1,2,3,4,5))
    clean_bed = np.empty(shape=[0,6])
    # current chromosome
    chrm_choices = np.unique(v[:,0])

    for chrm in chrm_choices:
        w = v[v[:,0]==chrm] # check 1st read chr
        w = w[w[:,3]==chrm] # check 2nd read chr
        clean_bed = w[w[:,5].astype(int) - w[:,2].astype(int) < 1000] # check the reads are close
        # continue for chromosomes from chrom.sizes that don't show up in filtered bedpe
        if(sizes.get(chrm)):
            chr_len = int(sizes.get(chrm))
        else:
            continue
        # gauss_smooth(list_start, list_end, # of reads, bandwidth, chr_size, normR (nonfunctional)
        a = gs.gauss_smooth(clean_bed[:,1].astype(int),clean_bed[:,5].astype(int),len(clean_bed),5,chr_len,6)

        # recreate bedgraph format "chr start end signal:"
        # take nonzero elements of the output (places there is signal)
        nz = np.nonzero(a)
        sig_loc = np.array(itemgetter(*nz)(a))

        # create an array with chr name (for easy np stacking)
        repeat_chr=np.full((len(nz[0]),1),chrm)
        # base locations are in nz, each signal is for a single point in chr
        textarray = np.column_stack((repeat_chr,nz[0],np.add(nz[0],1),sig_loc))
        with open(out,'a') as f:
            np.savetxt(f,textarray,delimiter="\t",fmt="%s")



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--in_bedpe", type=str, help="path/to/input.bedpe")
    parser.add_argument("--chr_sizes", type=str, help="path/to/chrom.sizes")
    parser.add_argument("--outname", type=str, help="path/to/outname.bedgraph")
    parser.add_argument("--base_direc", type=str, nargs="?", default="", help="optional base directory prepended to ALL files")
    args = parser.parse_args()
    main(args)
