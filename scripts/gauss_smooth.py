#!/usr/bin/env python
# Clara Bakker
import sys
import math
import numpy as np
import scipy.stats

from scipy.stats import norm
from scipy.ndimage.filters import gaussian_filter

def gauss_smooth(start, end, reads, bandwidth, chrLength, normR=1, *weights):
    if(len(start) != len(end) or len(start) != reads):
        print("Read/start/end count mismatch")
        sys.exit()

    spread = 6*bandwidth
    half_spread = bandwidth*3

    counts = np.bincount((start+end)//2)

    KDE = gaussian_filter(counts.astype(float), sigma=bandwidth)

    return(KDE*10)

