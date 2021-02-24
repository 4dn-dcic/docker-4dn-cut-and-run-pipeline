#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run:v1"

- class: "InlineJavascriptRequirement"

inputs:

  fastq1:
    type: "File"
    inputBinding:
      position: 1

  fastq2:
    type: "File"
    inputBinding:
      position: 2

  index:
    type: "File"
    inputBinding:
      position: 3

  threads:
    type: "int"
    inputBinding:
      position: 4
    default: 4

  outname:
    type: "string?"
    inputBinding:
      position: 5
    default: "out"

  outdir:
    type: "string"
    inputBinding:
      position: 6
    default: "."

outputs:
  out_bam:
    type:
      items: "File"
      type: "array"
    outputBinding:
      glob: "*.bam"

baseCommand:
 - "run-bowtie2.sh"
