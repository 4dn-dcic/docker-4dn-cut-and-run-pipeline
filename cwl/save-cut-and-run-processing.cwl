#!/usr/bin/env cwl-runner

class: "Workflow"

cwlVersion: v1.0

requirements:
- class: "InlineJavascriptRequirement"
- class: "ScatterFeatureRequirement"

fdn_meta:
  category: "filter"
    data_types:
      - "CUT&RUN"
    description: "This is a subworkflow of the CUT&RUN processing pipeline. It takes in fastqs as input and performs merging, trimming, alignment, sorting, and creates coverage tracks. It produces a bedpe and a bigwig file."
    name: "cut-and-run-processing"
    title: "CUT&RUN Primary Processing"
    workflow_type: "CUT&RUN data analysis"

inputs:
  input_fastqs:
    fdn_format: "fastq"
    type: 
      -
        items: "File"
        type: "array"

  chr_sizes:
    fdn_format: "chromsizes"
    type: "File"

  bowtie2_index:
    fdn_format: "bowtie2_index"
    type: "File"

  norm:
    type: "string"
    inputBinding:
      position: 3
    default: "norm"

  stringency:
    type: "string"
    inputBinding:
      position: 4
    default: "relaxed"

  out:
    type: "string"
    inputBinding:
      position: 5
    default: "out"

  outdir:
    type: "string"
    inputBinding:
      position: 5
    default: "."

outputs:
  out_bedg:
    type: "File?"
    outputBinding:
      glob: "*.bed"

baseCommand:
 - "run-peak.sh"
