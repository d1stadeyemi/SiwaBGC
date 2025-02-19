#!/bin/bash

# Load Conda
source ~/miniconda3/etc/profile.d/conda.sh

# Error on undefined variables
set -u 

# This script assembles metagenomic reads into contigs.
# Bins the contigs and select MAGs.
# Classifies the MAGs into taxa.
# Place MAGs within the GTDB reference genomes for phylogenomy.

# Check if at least one pair of clean reads is given
if [[ $# -lt 2 || $(($# % 2)) -ne 0 ]]; then
    echo "Usage: $0 Sample1_R1 Sample1_R2 [Sample2_R1 Sample2_R2...]"
    exit 1
fi

# Create output directories if not created
mkdir -p logs megahit_output metawrap_output

while [[ $# -gt 0 ]]; do # While their still reads to run
    # Define input files
    CLEANED_R1=$1
    CLEANED_R2=$2
    SAMPLE_NAME=$(basename "$CLEANED_R1" | cut -d"_" -f1) # Extract sample name

    # Check input files exit
    if [[ ! -f "$CLEANED_R1" || ! -f "$CLEANED_R2" ]]; then
        echo "Error! : One or both sample files ($CLEANED_R2, $CLEANED_R2) not found"
        exit 1
    fi

    # 1. Assembly with Megahit.
    echo "Running Megahit for ${SAMPLE_NAME} cleaned reads..."
    conda activate megahit
    megahit -v
    megahit -1 "$CLEANED_R1" -2 "$CLEANED_R2" -o megahit_output/"$SAMPLE_NAME"_output > logs/"$SAMPLE_NAME"_megahit.log 2>&1

    # Check the exit status of the last command. If it failed (exit status !=0), print error message and exit
    if [[ $? -ne 0 ]]; then
        echo "Error! Megahit failed for "$SAMPLE_NAME"_sample. Check logs/"$SAMPLE_NAME"_megahit.log for details"
        exit 1
    fi

    # 2. Binnning with metawrap
