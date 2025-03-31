#!/bin/bash 

# Load Conda 
source ~/miniconda3/etc/profile.d/conda.sh

# Handle different errors
set -u # Error on undefined variables
set -o pipefail # Detect errors in pipeline

# This script receives merged paired-end reads.
# Conducts quality control on the reads.
# Measures sequencing quality.
# Taxonomic classification of reads.
# Determines microbial diversity among samples.

# Check if at least one pair of reads is given 
if [[ $# -lt 2 || $(($# % 2)) -ne 0 ]]; then
    echo "Usage: $0 Sample1_R1 Sample1_R2 [Sample2_R1 Sample2_R2...]"
    exit 1
fi

# Create output directories if not created 
mkdir -p logs fastp_output nonpareil_output

# Initialize samples array
SAMPLES=()

while [[ $# -gt 0 ]]; do # While their still reads to run
    # Define input files 
    RAW_READS_R1=$1
    RAW_READS_R2=$2
    SAMPLE_NAME=$(basename "$RAW_READS_R1" | cut -d"_" -f1) # Extract sample name 

    # Check input files exit 
    if [[ ! -f "$RAW_READS_R1" || ! -f "$RAW_READS_R2" ]]; then
        echo "Error! : One or both sample files ($RAW_READS_R1, $RAW_READS_R2) not found"
        exit 1
    fi

    # Save to array
    SAMPLES+=("$SAMPLE_NAME" "$RAW_READS_R1" "$RAW_READS_R2")

    # Shift to next pair
    shift 2
done

# 1. Quality control with Fastp
echo "Running Fastp on all samples..."

for ((i = 0; i < ${#SAMPLES[@]}; i += 3)); do
    SAMPLE_NAME=${SAMPLES[i]}
    RAW_READS_R1=${SAMPLES[i+1]}
    RAW_READS_R2=${SAMPLES[i+2]}

    echo "Processing ${SAMPLE_NAME}_sample..."
    fastp -i "$RAW_READS_R1" -I "$RAW_READS_R2" -o fastp_output/"$SAMPLE_NAME"_cleaned_r1.fastq -O fastp_output/"$SAMPLE_NAME"_cleaned_r2.fastq > logs/"$SAMPLE_NAME"_fastp.log 2>&1

    # Check the exit status of the last command. If it failed (exit status !=0), print error message and exit
    if [[ $? -ne 0 ]]; then
        echo "Error! Fastp failed for "$SAMPLE_NAME"_sample. Check logs/"$SAMPLE_NAME"_fastp.log for details"
        exit 1
    fi
done

echo "Fastp completed for all samples. Output saved to 'fastp_output'"

# 2. Evaluate sequence quality with Nonpareil 
conda activate nonpareil
echo "Running Nonpareil on all samples..."

for ((i = 0; i < ${#SAMPLES[@]}; i += 3)); do
    SAMPLE_NAME=${SAMPLES[i]}

    echo "Processing ${SAMPLE_NAME}_sample..."
    nonpareil -s fastp_output/"$SAMPLE_NAME"_cleaned_r1.fastq -T kmer -k 15 -f fastq -b nonpareil_output/"$SAMPLE_NAME"_output > logs/"$SAMPLE_NAME"_nonpareil.log 2>&1

    # Check the exit status of the last command. If it failed (exit status !=0), print error message and exit 
    if [[ $? -ne 0 ]]; then
        echo "Error! Nonpareil failed for ${SAMPLE_NAME}_sample. Check logs/"$SAMPLE_NAME"_nonpareil.log for details"
        exit 1
    fi
done

echo "Sequence quality successfully estimated for all samples with Nonpareil. Output saved to 'nonpareil_output'"
conda deactivate

# 3. Evaluate reads taxonomy with Kraken 2 
echo "Running Kraken 2 on all samples..."

for ((i = 0; i < ${#SAMPLES[@]}; i += 3)); do
    SAMPLE_NAME=${SAMPLES[i]}

    echo "Processing ${SAMPLE_NAME}_sample..." 


echo "Pipeline finished successfully"