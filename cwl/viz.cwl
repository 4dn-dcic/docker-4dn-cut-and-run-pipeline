#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run-pipeline:v1"

inputs:

  bedpe:
    type: "File"
    inputBinding:
      position: 1

  chr_sizes:
    type: "File"
    inputBinding:
      position: 2

  is_ctl:
    type: "boolean"
    inputBinding:
      position: 3
    default: false

  base_direc:
    type: "string?"
    inputBinding:
      position: 4
    default: ""

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
  out_bedgraph:
    type: "File?"
    outputBinding:
      glob: "*.bedgraph.gz"

  out_bw:
    type: "File?"
    outputBinding:
      glob: "*.bw"

baseCommand:
 - "run-viz.sh"
