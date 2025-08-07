#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
label: "extract foldseek result and hit id lists"
doc: |
  Extract foldseek result and hit id lists from foldseek result file.

requirements:
  WorkReuse:
    enableReuse: true

# ----------WORKFLOW INPUTS----------
inputs:
  - id: FOLDSEEK_RESULT_FILE
    type: File
    label: "foldseek result file"
    doc: "foldseek result file"
    format: edam:format_3475
    default:
      class: File
      format: edam:format_3475
      location: ../Data/14_foldseek_result/evalue01/foldseek_output_uniprot_rice_up_all_evalue01.tsv

  - id: TARGET_SPECIES
    type: int
    label: "extract target species result in foldseek result"
    doc: "extract target species result in foldseek result"
    default: 9606

  - id: OUTPUT_EXTRACT_FILE_NAME
    type: string
    label: "output file name"
    doc: "output file name"
    default: "foldseek_output_uniprot_rice_up_9606.tsv"

  - id: OUTPUT_UNIPROT_ID_COLUMN_NUMBER_QUERY_SPECIES
    type: int
    label: "output uniprot id column number query species"
    doc: "output uniprot id column number query species"
    default: 1

  - id: OUTPUT_UNIPROT_ID_COLUMN_NUMBER_HIT_SPECIES
    type: int
    label: "output uniprot id column number hit species"
    doc: "output uniprot id column number hit species"
    default: 2

  - id: OUTPUT_UNIPROT_ID_FILE_NAME_QUERY_SPECIES
    type: string
    format: edam:data_1050
    label: "output uniprot id file name query species"
    doc: "output uniprot id file name query species"
    default: "uniprot_id_rice_up_rice_idlist.txt"

  - id: OUTPUT_UNIPROT_ID_FILE_NAME_HIT_SPECIES
    type: string
    format: edam:data_1050
    label: "output uniprot id file name hit species"
    doc: "output uniprot id file name hit species"
    default: "uniprot_id_rice_up_human_idlist.txt"


# ----------OUTPUTS----------
outputs:
  - id: OUTPUT_EXTRACT_FILE
    type: File
    format: edam:format_3475
    outputSource: extract_target_species/output_extract_file

  - id: OUTPUT_UNIPROT_ID_FILE_QUERY_SPECIES
    type: File
    format: edam:format_3475
    outputSource: extract_uniprot_id_query_species/output_file

  - id: OUTPUT_UNIPROT_ID_FILE_HIT_SPECIES
    type: File
    format: edam:format_3475
    outputSource: extract_uniprot_id_hit_species/output_file


# ----------STEPS----------
steps:
  extract_target_species:
    run: ../Tools/12_extract_target_species.cwl
    in:
      input_file: FOLDSEEK_RESULT_FILE
      target_species: TARGET_SPECIES
      output_file_name: OUTPUT_EXTRACT_FILE_NAME
    out:
      - output_extract_file

  extract_uniprot_id_query_species:
    run: ../Tools/13_extract_id.cwl
    in:
      tsvfile: extract_target_species/output_extract_file
      column_number: OUTPUT_UNIPROT_ID_COLUMN_NUMBER_QUERY_SPECIES
      output_file_name: OUTPUT_UNIPROT_ID_FILE_NAME_QUERY_SPECIES
    out:
      - output_file

  extract_uniprot_id_hit_species:
    run: ../Tools/13_extract_id.cwl
    in:
      tsvfile: extract_target_species/output_extract_file
      column_number: OUTPUT_UNIPROT_ID_COLUMN_NUMBER_HIT_SPECIES
      output_file_name: OUTPUT_UNIPROT_ID_FILE_NAME_HIT_SPECIES
    out:
      - output_file

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
