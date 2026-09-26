![GitHub last commit (branch)](https://img.shields.io/github/last-commit/yonesora56/HS_rice_analysis/main)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![figshare Badge](https://img.shields.io/badge/figshare-556472?logo=figshare&logoColor=fff&style=flat-square)](https://doi.org/10.6084/m9.figshare.c.7835495.v3)
[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=python3.11&color=blue&logo=docker)](https://github.com/yonesora56/HS_rice_analysis/tree/main/.devcontainer)
[![X (@sorayone56)](https://img.shields.io/badge/X-sorayone56-black?style=flat&logo=x&logoColor=white)](https://x.com/sorayone56)

# HS_rice analysis scripts and notebooks

This repository contains the code and Jupyter notebooks used to create the following pre-print and [article in Bioinformatics advances](https://doi.org/10.1093/bioadv/vbag013) !

> **Functional Annotation of Novel Heat Stress-responsive Genes in Rice Utilizing Public Transcriptomes and Structurome**  
> *bioRxiv preprint*  
> DOI: [10.1101/2025.09.29.679423](https://doi.org/10.1101/2025.09.29.679423)

&nbsp;

&nbsp;

> @article{10.1093/bioadv/vbag013,
    author = {Yonezawa, Sora and Bono, Hidemasa},
    title = {Functional annotation of novel heat stress-responsive genes in rice utilizing public transcriptomes and structurome},
    journal = {Bioinformatics Advances},
    volume = {6},
    number = {1},
    pages = {vbag013},
    year = {2026},
    month = {01},
    abstract = {Life science databases include large collections of public transcriptome and large-scale structural data. The reuse and integration of these datasets may facilitate the identification of understudied genes and enable functional annotation across distantly related species, including plants and humans.In this study, we used heat stress-responsive genes in rice as a model to functionally annotate previously understudied genes by integrating publicly available transcriptome data with structural information from the AlphaFold Protein Structure Database. Initially, we conducted a meta-analysis of public heat stress-related transcriptome datasets, identified gene groups, and verified stress-related terms through enrichment analysis. Subsequently, we performed structural alignment and sequence alignment between rice and human proteins, focusing on candidates exhibiting low sequence similarity but high structural similarity. We further incorporated supplemental data from public databases, including shared domain information between rice and human. This approach yielded a unique set of these candidates, notably those associated with metal homeostasis, such as iron and copper metabolism. Overall, our integrative method provided insights into these genes by leveraging diverse, publicly available datasets.The “plant2human workflow” for this analysis is available at https://doi.org/10.48546/WORKFLOWHUB.WORKFLOW.1206.10.},
    issn = {2635-0041},
    doi = {10.1093/bioadv/vbag013},
    url = {https://doi.org/10.1093/bioadv/vbag013},
    eprint = {https://academic.oup.com/bioinformaticsadvances/article-pdf/6/1/vbag013/68211684/vbag013.pdf},
}

&nbsp;

The correspondence between the created figures, the code used, and the notebooks can be confirmed from each figure on figshare.

> Yonezawa, Sora; Bono, Hidemasa (2025). (Supplementary Files) Functional Annotation of Novel Heat Stress-responsive Genes in Rice Utilizing Public Transcriptomes and Structurome. figshare. Collection. https://doi.org/10.6084/m9.figshare.c.7835495

&nbsp;

## `.devcontainer` update (2026-09-24)

- Previous `.devcontainer` file is located in [./devcontainer_archive/](./devcontainer_archive/)

&nbsp;

&nbsp;

## R version (article related version) (~ 2026/03)

```bash
R version 4.4.1 (2024-06-14)
Platform: aarch64-unknown-linux-gnu
Running under: Debian GNU/Linux 11 (bullseye)

Matrix products: default
BLAS:   /usr/lib/aarch64-linux-gnu/openblas-pthread/libblas.so.3 
LAPACK: /usr/lib/aarch64-linux-gnu/openblas-pthread/libopenblasp-r0.3.13.so;  LAPACK version 3.9.0

locale:
 [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
 [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
 [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
[10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

time zone: Etc/UTC
tzcode source: system (glibc)

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

loaded via a namespace (and not attached):
 [1] digest_0.6.37     IRdisplay_1.1     base64enc_0.1-3   fastmap_1.2.0    
 [5] glue_1.8.0        htmltools_0.5.8.1 repr_1.1.7        lifecycle_1.0.4  
 [9] cli_3.6.5         vctrs_0.6.5       pbdZMQ_0.3-14     compiler_4.4.1   
[13] tools_4.4.1       evaluate_1.0.3    pillar_1.10.2     rlang_1.1.6      
[17] jsonlite_2.0.0    crayon_1.5.3      IRkernel_1.3.2    uuid_1.2-1 
```

&nbsp;

```bash
========================================
simona version 1.4.0
Bioconductor page: http://bioconductor.org/packages/simona/
Github page: https://github.com/jokergoo/simona
Documentation: https://jokergoo.github.io/simona/

If you use it in published research, please cite:
Gu, Z. simona: a Comprehensive R package for Semantic Similarity 
  Analysis on Bio-Ontologies. BMC Genomics, 2024.

This message can be suppressed by:
  suppressPackageStartupMessages(library(simona))
========================================




========================================
simplifyEnrichment version 2.0.0
Bioconductor page: https://bioconductor.org/packages/simplifyEnrichment/
Github page: https://github.com/jokergoo/simplifyEnrichment
Documentation: https://jokergoo.github.io/simplifyEnrichment/
Examples: https://simplifyenrichment.github.io/

If you use it in published research, please cite:
Gu, Z. simplifyEnrichment: an R/Bioconductor package for Clustering and 
  Visualizing Functional Enrichment Results, Genomics, Proteomics & 
  Bioinformatics 2022.

This message can be suppressed by:
  suppressPackageStartupMessages(library(simplifyEnrichment))
========================================


Loading required package: grid

========================================
ComplexHeatmap version 2.22.0
Bioconductor page: http://bioconductor.org/packages/ComplexHeatmap/
Github page: https://github.com/jokergoo/ComplexHeatmap
Documentation: http://jokergoo.github.io/ComplexHeatmap-reference

If you use it in published research, please cite either one:
- Gu, Z. Complex Heatmap Visualization. iMeta 2022.
- Gu, Z. Complex heatmaps reveal patterns and correlations in multidimensional 
    genomic data. Bioinformatics 2016.


The new InteractiveComplexHeatmap package can directly export static 
complex heatmaps into an interactive Shiny app with zero effort. Have a try!

This message can be suppressed by:
  suppressPackageStartupMessages(library(ComplexHeatmap))
========================================
```

