#!/bin/bash

# Load Conda
source ~/miniconda3/etc/profile.d/conda.sh

# Error on undefined variables
set -u 

# This script assembles metagenomic reads into contigs.
# Bins the contigs and select MAGs.
# Classifies the MAGs into taxa.
# Place MAGs within the GTDB reference genomes for phylogenomy.