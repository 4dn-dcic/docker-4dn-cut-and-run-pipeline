#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run:v1"

- class: "InlineJavascriptRequirement"

inputs:
  bedgr:
    type: "File"
    inputBinding:
      position: 1

  control:
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
      glob: "*.bed"

baseCommand:
 - "run-peak.sh"
