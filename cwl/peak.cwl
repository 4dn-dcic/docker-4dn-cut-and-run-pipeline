#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run-pipeline:v1"

inputs:
  input_bg:
    type: "File"
    inputBinding:
      position: 1

  input_bg_ctl:
    type: "File"
    inputBinding:
      position: 2

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
      glob: *peaks.$(inputs:stringency).bed.gz

baseCommand:
 - "run-peak.sh"
