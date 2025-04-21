# 🧬 Unraveling Novel Biosynthetic Gene Clusters from the Siwa Oasis Microbiome

## Project Overview
This repository contains the complete bioinformatics pipeline, scripts, and supporting metadata for the metagenomic study titled:

"Unraveling Novel Biosynthetic Gene Clusters from the Siwa Oasis Microbiome"

This research investigates the microbial diversity and biosynthetic potential of the microbial communities in two historically significant and therapeutically acclaimed freshwater springs, Cleopatra and Fatnas, located in Egypt's Siwa Oasis. Through advanced metagenomic assembly, genome-resolved binning, and BGC discovery using cutting-edge computational tools, this study identified novel microbial lineages and biosynthetic gene clusters — including potential antibiotic-producing pathways — that could serve as candidates for future drug discovery.

![keyfindings](https://github.com/d1stadeyemi/SiwaBGC/blob/master/Images/key_findings.png)

## ✨ Key Contributions
1. Comprehensive metagenomic assembly and genome binning of microbial communities from underexplored freshwater hot springs.

2. Taxonomic and phylogenomic analysis of metagenome-assembled genomes (MAGs), including the identification of novel taxa.

3. Discovery and prioritization of biosynthetic gene clusters (BGCs) using state-of-the-art tools like antiSMASH, BiG-SCAPE, BiG-SLiCE, and DeepBGC.

4. Identification of novel lasso peptide BGCs with predicted antimicrobial activity.

5. Implementation of a reproducible bioinformatics workflow designed for natural product discovery from metagenomic data.

## 💡 Why This Study Matters
The study addresses two pressing challenges in natural product research:

1. The declining discovery rate of new bioactive metabolites due to the repeated rediscovery of known compounds.

2. The difficulty of prioritizing BGCs from the pool of metagenomic predictions.

By leveraging robust computational pipelines, this work demonstrates how underexplored environments — in this case, freshwater mineral springs — can serve as reservoirs of novel biosynthetic potential, expanding the scope of natural product discovery for pharmaceutical and industrial applications.

## 🧰 Pipeline Overview
The pipeline consists of the following stages:

1. Quality Control:
Fastp for raw read filtering and quality assessment.

2. Metagenomic Assembly:
MEGAHIT for assembling high-quality contigs.

3. Genome Binning:
MetaWRAP (using MaxBin2, MetaBAT2, CONCOCT) for genome reconstruction.

4. MAG Evaluation:
CheckM for completeness and contamination validation.

5. Taxonomic Classification:
Kraken2 and GTDB-Tk for read-based and genome-based taxonomic assignment.

6. Phylogenomic Analysis:
GToTree for SCG-based bacterial phylogenomic tree construction.

7. BGC Detection & Novelty Estimation:
antiSMASH for BGC prediction,
BiG-SCAPE for BGC clustering,
BiG-SLiCE for novelty detection,
DeepBGC for functional and therapeutic potential prediction.

8. Visual Analysis:
R-based scripts for abundance heatmaps, diversity analysis, and BGC annotation plots.

![pipeline](https://github.com/d1stadeyemi/SiwaBGC/blob/master/Images/Pipeline.png)

## 🔬 Tools & Dependencies
-   Python 3.9<br>
-   R 4.2<br>
-   Fastp v0.23.2<br>
-   Nonpareil v3.5.5<br>
-   MEGAHIT v1.2.9<br>
-   MetaWRAP v1.3.2<br>
-   CheckM<br>
-   Kraken2 v2.1.2<br>
-   GTDB-Tk v2.3.2<br>
-   GToTree v1.8.6<br>
-   AntiSMASH v7.1.0<br>
-   BiG-MAP v1.0.0<br>
-   BiG-SCAPE<br>
-   BiG-SLICE v2<br>
-   DeepBGC v0.1.31<br>
### Databases
-   CheckM database<br>
-   Kraken2 PlusPF (January, 2024 release) database<br>
-   GTDB (release r214)<br>
-   MiBIG v4 database<br>
-   BGC Atlas

## 📚 Recommended Citation
<span style="color:red"><strong>This study is yet to be published.<strong></span>

    Muhammad Ajagbe, Ali H. A. Elbehery, Shimaa F. Ahmed, Amged Ouf, Basma M. T. Abdoullateef, Rehab Abdallah, and Rania Siam (2025). Unraveling Novel Biosynthetic Gene Clusters from the Siwa Oasis Microbiome.  

## 📫 Contact
For questions, collaborations, or further discussion:

📧 Email: Corresponding author [aelbehery@aucegypt.edu] or the first author [d1stadeyemi@gmail.com]

🔗 LinkedIn: [MuhammadAjagbe](https://www.linkedin.com/search/results/all/?fetchDeterministicClustersOnly=true&heroEntityKey=urn%3Ali%3Afsd_profile%3AACoAACfL2awB01NHgXUUc2B3r_WfCxRleV5OZVU&keywords=muhammad%20ajagbe&origin=RICH_QUERY_TYPEAHEAD_HISTORY&position=0&searchId=14ed48c3-4fa5-4786-a314-c7aa09240e5d&sid=QiC&spellCorrectionEnabled=true)
