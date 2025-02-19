#!/bin/bash

# Load Conda
source ~/miniconda3/etc/profile.d/conda.sh

# Error on undefined variables
set -u 

# This script detects BGCs from MAGs and unbinned contigs Fasta files.
# Calculates the abundance of BGCs.
# Compares the putative BGCs with MiBIG and BGC atlas databases for novelty check.