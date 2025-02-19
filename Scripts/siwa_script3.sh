#!/bin/bash

# Load Conda
source ~/miniconda3/etc/profile.d/conda.sh

# Error on undefined variables
set -u 

# This script detects BGCs from MAGs and unbinned contigs Fasta files.
# Calculates the abundance of BGCs in each sample.
# Compares the putative BGCs with MiBIG and BGC atlas databases for novelty check.

# Define input directory
INPUT_DIR=$1

# Checks if an argument was provided
if [[ -z "$INPUT_DIR" ]]
then
    echo "Error: No input directory provided."
    echo "Usage: $(basename "$0") <MAGS_DIR>"
    echo "Description: MAGS_DIR should be a directory containing MAG files."
    exit 1
fi

# Check if input directory is a valid directory.
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

