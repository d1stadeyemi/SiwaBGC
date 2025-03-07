#!/bin/bash

# Load Conda
source ~/miniconda3/etc/profile.d/conda.sh

# Error on undefined variables
set -u 

# This script detects BGCs from MAGs and unbinned contigs Fasta files.
# Calculates the abundance of BGCs in each sample.
# Compares the putative BGCs with MiBIG and BGC atlas databases for novelty check.

mkdir -p logs antismash_output BGCs bigmap_output

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

    # Check if input directory is empty or not
    if ! find "$INPUT_DIR" -mindepth 1 | read -r _; then
        echo "Error: '$INPUT_DIR' is empty."
        exit 1
    fi

    # 1. Detect BGCs in samples with Antismash
    conda activate antismash
    echo "Running Antismash on ${SAMPLE_NAME}_MAGs..."
    
    for fasta_file in "$INPUT_DIR"/*.fa; do
        # Define output directory for antismash outputs.
        OUTPUT_DIR=antismash_output/${SAMPLE_NAME}_$(basename "$fasta_file" .fa)
        
        echo "Running Antismash on $(basename "$fasta_file")..." 

        antismash --output-dir "$OUTPUT_DIR" --tigrfam --asf --cc-mibig --cb-general \
        --cb-subclusters --cb-knownclusters --pfam2go --rre --smcog-trees --tfbs \
        --genefinding-tool prodigal-m "$fasta_file" \
        > logs/"$OUTPUT_DIR".log 2>&1

        if [[ $? -ne 0 ]]
        then
            echo "Error: Antismash failed for $(basename "$fasta_file")"
            echo "Check logs/"$OUTPUT_DIR".log for details"
            exit 1
        fi

        echo "Antismash completed for $(basename "$fasta_file"). Output saved to ${OUTPUT_DIR}"

    done
    
    conda deativate
    echo "Antismash complete for ${SAMPLE_NAME}_MAGs..."

    # 2. Rename BGC files
    echo "Renaming BGCs by adding prefixes with sample names..."

    find antismash_output -name "*.region001.gbk" -exec sh -c '
        for file; do
            mv "$file" "$(dirname "$file")/${SAMPLE_NAME}_$(basename "$file")"
    ' _ {} +

    # Collect all BGCs into a directory
    find antismash_output -name "*.region001.gbk" -exec mv -t BGC {} +

    # 3. Determine the abundance of BGCs with BIG-MAP
    conda activate BiG-MAP_process

    # Group BGCs into GCF with BiG-MAP.family.py
    python3 ~/BiG-MAP/src/BiG-MAP.family.py -D BGCs -b ~/BiG-SCAPE-1.1.9 \
    -pf ~/BiG-SCAPE-1.1.9 -O bigmap_output/BiG-MAP.family_output \
    > logs/bigmap_output/BiG-MAP.family_output.log 2>&1 
    
    if [[ $? -ne 0 ]]
    then
        echo "Error: BiG-MAP_process failed."
        echo "Check logs/bigmap_output/BiG-MAP.family_output.log for details"
        exit 1
    fi

    # Calculate BGC abundance with BiG-MAP.map.py
    python3 ~/BiG-MAP/src/BiG-MAP.map.py -I1 clean_reads/*qc_1* -I2 clean_reads/*qc_2* \
    -O bigmap_output/BiG-MAP.map_output -F bigmap_output/BiG-MAP.family_output \
    > logs/bigmap_output/BiG-MAP.map_output.log 2>&1

    if [[ $? -ne 0 ]]
    then
        echo "Error: BiG-MAP_process failed."
        echo "Check logs/bigmap_output/BiG-MAP.map_output.log for details"
        exit 1
    fi

    conda deactivate
    echo "BiG-MAP completed successfully."

    # 4. Compare BGCs with MiBIG BGCs using BiG-SLICE v2
    conda activate bigslice

    # Extract pfam domains in MiBiG BGCs and calculate cosine distance (default threshold=0.4)
    # to form GCFs
    bigslice -i bigslice_mibig_input bigslice_mibig_output

    # Compare BGCs to MibiG GCFs
    bigslice --query BGCs --n_ranks 2 bigslice_mibig_output

    conda deactivate
    echo "BiG-SLICE complete successfully."

done

# Pipeline successfully completed.
