#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run-pipeline:v1"

- class: "InlineJavascriptRequirement"

inputs:

  bedpe:
    type: "File"
    inputBinding:
      position: 1

  chr_sizes:
    type: "File"
    inputBinding:
      position: 2

  base_direc:
    type: "string?"
    inputBinding:
      position: 3
    default: "."

  outname:
    type: "string?"
    inputBinding:
      position: 4
    default: "out"

  outdir:
    type: "string"
    inputBinding:
      position: 5
    default: "."

outputs:
  out_bedgraph:
    type: "File?"
    outputBinding:
      glob: "*.bedgraph"

  out_bw:
    type: "File?"
    outputBinding:
      glob: "*.bw"

baseCommand:
 - "run-viz.sh"
