## Author: Oliver Abinader


# Reference Genome Setup Pipeline

A reproducible workflow for **setting up reference genomes** for downstream bioinformatics analysis, including genome retrieval, indexing, annotation inspection, and interval list generation.

---

## Overview

This repository provides a standardized pipeline for preparing reference genomes for:

* RNA-seq analysis
* Single-cell RNA-seq workflows
* Genome alignment (BWA, STAR)
* rRNA depletion workflows
* Interval-based genomic filtering

The pipeline supports both **eukaryotic (human hg38)** and **prokaryotic (E. coli)** reference genome setups.

---

# 1. Genome Download (NCBI)

Reference genomes are retrieved from NCBI Assembly databases using RefSeq assemblies.

Typical inputs include:

* Genome FASTA file (`.fna`)
* Gene annotation file (`.gff`)
* Gene annotation file (`.gtf`)

---

# 2. Human Reference Genome Setup (hg38)

The human reference genome (GRCh38 / hg38) is prepared for downstream alignment and analysis.

Key steps include:

### Genome organization

* Create structured reference directory
* Store FASTA and annotation files together for reproducibility

---

### Annotation inspection

Genome annotation features are summarized to understand genomic composition:

* Gene features
* Transcript types
* Non-coding RNA classes

This helps validate annotation completeness and structure.

---

### Genome indexing

The reference genome is indexed for alignment tools:

* FASTA index for sequence retrieval
* Sequence dictionary for compatibility with downstream tools
* BWA index for read alignment

These indexes ensure compatibility with standard NGS pipelines.

---

# 3. Bacterial Reference Genome Setup (E. coli)

A bacterial reference genome (ASM584v2) is also prepared following the same principles:

* Genome FASTA retrieval
* Annotation download (GFF/GTF)
* Standard indexing procedures

---

# 4. Interval List Generation (E. coli Example)

For bacterial genomes, interval lists are generated to define genomic regions for downstream filtering and analysis.

These interval lists include:

* rRNA regions (5S, 16S, 23S)
* tRNA regions
* protein-coding genes (CDS)
* non-coding RNAs (miRNA, snoRNA, lncRNA)

---

## Purpose of Interval Lists

Interval lists are used to:

* define target regions for depletion workflows
* support read filtering strategies
* enable region-specific quantification
* improve downstream analysis specificity

---

# 5. Key Outputs

Each genome setup produces:

* Reference FASTA files
* Annotation files (GFF/GTF)
* Sequence index files
* Genome dictionaries
* Alignment indexes (BWA)
* Interval list files (for targeted workflows)

---

# 6. Applications

This pipeline supports:

* RNA-seq alignment workflows
* Single-cell RNA-seq preprocessing
* rRNA depletion design
* Comparative genomics
* Custom reference genome construction
