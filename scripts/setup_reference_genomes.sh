#!/bin/bash

set -euo pipefail

########################################################
# USAGE
# bash setup_reference_genomes.sh hg38
# bash setup_reference_genomes.sh ecoli
########################################################

GENOME=$1

########################################################
# HG38 SETUP (HUMAN REFERENCE GENOME)
########################################################

if [ "$GENOME" == "hg38" ]; then

    echo "Setting up hg38 reference genome..."

    REF_DIR="/path/to/out/hg38"
    mkdir -p "$REF_DIR"
    cd "$REF_DIR"

    echo "Step 1: Download reference files from NCBI (RefSeq GRCh38) ONCE before running this script"
    # wget GCF_000001405.39_GRCh38.p13_genomic.fna.gz
    # wget GCF_000001405.39_GRCh38.p13_genomic.gff.gz
    # wget GCF_000001405.39_GRCh38.p13_genomic.gtf.gz

    echo "Step 2: Unzipping files"
    gunzip *.gz || true

    FASTA="GCF_000001405.39_GRCh38.p13_genomic.fna"
    GFF="GCF_000001405.39_GRCh38.p13_genomic.gff"

    echo "Step 3: Indexing genome"

    samtools faidx "$FASTA"

    picard CreateSequenceDictionary \
        R="$FASTA" \
        O="${FASTA%.fna}.dict"

    bwa index -a bwtsw "$FASTA"

    echo "Step 4: Inspecting GFF features"
    grep -v '^#' "$GFF" | cut -f3 | sort | uniq -c | sort -nr

    echo "hg38 setup complete."

########################################################
# ECOLI SETUP (BACTERIAL GENOME)
########################################################

elif [ "$GENOME" == "ecoli" ]; then

    echo "Setting up E. coli reference genome..."

    REF_DIR="/mnt/data/references/ecoli"
    mkdir -p "$REF_DIR"
    cd "$REF_DIR"

    ACCESSION="GCF_000005845.2"

    echo "Step 1: Download E. coli genome (ASM584v2)"
    # wget ${ACCESSION}_genomic.fna.gz
    # wget ${ACCESSION}_genomic.gff.gz
    # wget ${ACCESSION}_genomic.gtf.gz

    echo "Step 2: Unzipping files"
    gunzip *.gz || true

    FASTA="${ACCESSION}_genomic.fna"
    GFF="${ACCESSION}_genomic.gff"

    echo "Step 3: Indexing genome"

    samtools faidx "$FASTA"

    picard CreateSequenceDictionary \
        R="$FASTA" \
        O="${FASTA%.fna}.dict"

    bwa index -a bwtsw "$FASTA"

    echo "Step 4: Inspecting GFF features"
    grep -v '^#' "$GFF" | cut -f3 | sort | uniq -c | sort -nr

    # STEP 5: CREATE INTERVAL LIST (rRNA + gene features)
    echo "Step 5: Creating interval list"

    java -Xmx4g -jar /path/to/interval-tools.jar \
        GffFeaturesToIntervalList \
        -r "$FASTA" \
        -g "$GFF" \
        -o "ecoli.interval_list" \
        -i CDS:CDS \
        -i snoRNA:ncRNA \
        -i miRNA:ncRNA \
        -i tRNA:tRNA \
        -i lnc_RNA:ncRNA \
        -l 5S:5S \
        -l 16S:16S \
        -l 23S:23S \
        -l mRNA:mRNA

    echo "E. coli setup complete."

else
    echo "Usage: bash setup_reference_genomes.sh [hg38|ecoli]"
    exit 1
fi
