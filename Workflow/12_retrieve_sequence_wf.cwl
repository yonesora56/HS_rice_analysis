#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
label: "retrieve sequence and perform pairwise alignment (sub-workflow process)"
doc: |
  The process of retrieving protein sequences corresponding to pairs of structures hit by Foldseek, and performing pairwise alignments.
  This process assumes that the query, target, and both files are data that are predicted in AlphaFold DB.
  blastdbcmd: ../Tools/15_blastdbcmd_v2.cwl
  seqretsplit: ../Tools/16_seqretsplit.cwl
  needle (Global alignment): ../Tools/17_needle.cwl
  water (Local alignment): ../Tools/17_water.cwl

requirements:
  WorkReuse:
    enableReuse: true

# ----------WORKFLOW INPUTS----------
inputs:
  # makeblastdb inputs
  - id: INDEX_DIR_NAME
    type: string
    label: "index directory name"
    doc: "blast index directory name for blastdbcmd"
    format: edam:data_1049
    default: "index_uniprot_afdb_all_sequences"

  - id: INPUT_FASTA_FILE
    type: File
    label: "input fasta file"
    doc: "input fasta file for makeblastdb. Retrieve files in advance from uniprot."
    format: edam:format_1929
    default:
      class: File
      format: edam:format_1929
      location: ../Data/15_blastdbcmd_afdb_sequence/afdb_all_sequences.fasta

  # blastdbcmd inputs