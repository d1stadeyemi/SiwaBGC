#!/bin/bash

# Load Conda
source ~/miniconda3/etc/profile.d/conda.sh

# Error on undefined variables
set -u 

# This script detects BGCs from MAGs and unbinned contigs Fasta files.
# Calculates the abundance of BGCs in each sample.
# Compares the putative BGCs with MiBIG and BGC atlas databases for novelty check.

mkdir -p antismash_output

# Ensure at least one directory is provided
if [[ $# -lt 1 ]]; then
    echo "Error: No input directory provided."
    echo "Usage: $(basename "$0") <MAGS_DIR> [<MAGS_DIR2>...]"
    exit 1
fi

while [[ $# -gt 0 ]]; then
    # Define input directory
    INPUT_DIR=$1
    SAMPLE_NAME=$(basename "$INPUT_DIR" | cut -d"_" -f1) # Extract sample name

    # Check if input directory is not valid.
    if [[ ! -d "$INPUT_DIR" ]]
    then
        echo "Error: "$INPUT_DIR" is not a valid directory"
        echo "Usage: $(basename $0) <MAGS_DIR>"
        exit 1
    fi

    # Check if input directory is empty
    if ! find "$INPUT_DIR" -mindepth 1 | read -r _; then
        echo "Error: '$INPUT_DIR' is empty."
        exit 1
    fi

    # 1. Detect BGCs in samples
    conda activate antismash
    echo "Running Antismash on ${SAMPLE_NAME}_MAGs..."
    for fasta_file in "$INPUT_DIR"/*.fa; do
        OUTPUT_DIR=antismash_output/${SAMPLE_NAME}_$(basename "$fasta_file" .fa) 

done
