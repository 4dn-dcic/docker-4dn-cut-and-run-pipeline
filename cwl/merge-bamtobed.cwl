#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run-pipeline:v1"

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

  bams:
    inputBinding:
      itemSeparator: " "
      position: 3
      separate: true
    type:
      items: "File"
      type: "array"

outputs:
  out_bedpe:
    type: "File?"
    outputBinding:
      glob: "*.bedpe.gz"

baseCommand:
 - "run-merge-bamtobed.sh"
