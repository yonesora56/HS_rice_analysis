#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
label: "enrichment analysis (goatools)"
doc: "Enrichment analysis using goatools v1.4.12"

baseCommand: [find_enrichment.py]

arguments:
  - $(inputs.target_genelist.path)
  - $(inputs.background_genelist.path)
  - $(inputs.annotation_file.path)
  - --pval=$(inputs.pvalue)
  - --method=$(inputs.method)
  - --pval_field=$(inputs.pval_field)
  - --obo=$(inputs.obo_file.path)
  - --obsolete=$(inputs.obsolete_go)
  - --outfile=$(inputs.output_file_name)

inputs:
  - id: target_genelist
    type: File
    label: "Gene list"
    doc: "Your interest gene list"
    default:
      class: File
      location: ../Data/09_goatools/HN5_genes_up_rice.txt

  - id: background_genelist
    type: File
    label: "All gene list"
    doc: "All gene list including your interest gene list"
    default:
      class: File
      location: ../Data/09_goatools/ensembl/rice_all_genelist_r58.txt

  - id: annotation_file
    type: File
    label: "Gene-Ontology association file"
    doc: "Gene-Ontology association file. format example: https://github.com/moshi4/goatools-demo/tree/main/data"
    default:
      class: File
      location: ../Data/09_goatools/rice_go_annotation_r58_concatenated.txt

  - id: pvalue
    type: float
    label: "P-value"
    doc: "P-value"
    default: 0.01

  - id: method
    type: string
    label: "Method"
    doc: "Method"
    default: "fdr_bh"

  - id: pval_field
    type: string
    label: "P-value field"
    doc: "P-value field"
    default: "fdr_bh"

  - id: obo_file
    type: File
    label: "OBO file"
    doc: "ontology OBO file for replacing latest ontology file"
    default:
      class: File
      location: ../Data/09_goatools/go_v202503.obo

  - id: obsolete_go
    type: string
    label: "Obsolete GO"
    doc: "Strategy for handling obsolete GO terms {keep,replace,skip}"
    default: "replace"

  - id: output_file_name
    type: string
    label: "Output file name"
    doc: "Output file name"
    default: "rice_go_enrichment_up.tsv"

  - id: stdout_file_name
    type: string
    label: "Standard output file name"
    doc: "Standard output file name"
    default: "find_enrichment_stdout_up.txt"

stdout: $(inputs.stdout_file_name)

outputs:
  - id: enrichment_result
    type: File
    label: "Enrichment result"
    doc: "Enrichment result"
    outputBinding:
      glob: $(inputs.output_file_name)

  - id: stdout
    type: File
    label: "Standard output"
    doc: "Standard output"
    outputBinding:
      glob: $(inputs.stdout_file_name)


# hints:
#   - class: DockerRequirement
#     dockerPull: 

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/

