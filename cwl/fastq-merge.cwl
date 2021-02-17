#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run:v1"

- class: "InlineJavascriptRequirement"

inputs:

  outname:
    type: "string?"
    inputBinding:
      position: 1
    default: "out"

  outdir:
    type: "string"
    inputBinding:
      position: 2
    default: "."

  fastqs:
    inputBinding:
      itemSeparator: " "
      position: 3
      separate: true
    type:
      items: "File"
      type: "array"

outputs:
  merged_fastq:
    type: "File?"
    outputBinding:
      glob: "*.fastq.gz"

baseCommand:
 - "run-fastq-merge.sh"
