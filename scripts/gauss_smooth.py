#!/usr/bin/env python3
# Clara Bakker

import sys
import math
import numpy as np
import scipy.stats

from scipy.stats import norm
from scipy.ndimage.filters import gaussian_filter

'''
Using a list of start and end points from paired-end reads, generate a gaussian
distribution around each pair's midpoint. Output can be formatted as bedgraph file
'''

def gauss_smooth(start, end, reads, bandwidth, chrLength, normR=1, *weights):
    if(len(start) != len(end) or len(start) != reads):
        print("Read/start/end count mismatch")
        sys.exit()

    counts = np.bincount((start+end)//2)

    KDE = gaussian_filter(counts.astype(float), sigma=bandwidth)

    return(KDE)

