#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run:v1"

- class: "InlineJavascriptRequirement"

inputs:
  bwa_index:
    type: "File"
    inputBinding"
      position: 1

  fastq1:
    type: "File"
    inputBinding:
      position: 2

  fastq2:
    type: "File"
    inputBinding:
      position: 3

  threads:
    type: "int"
    inputBinding:
      position: 4
    default: 4

  outdir:
    type: "string?"
    inputBinding:
      position: 5

  outname:
    type: "string"
    inputBinding:
      position: 6

outputs:
  out_bam:
    type: "File?"
    outputBinding:
      glob: "*.bam"

baseCommand:
 - "run-bwa-mem.sh"
