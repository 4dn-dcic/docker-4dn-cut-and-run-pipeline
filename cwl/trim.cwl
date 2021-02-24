#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/cut-and-run-pipeline:v1"

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

  threads:
    type: "int"
    inputBinding:
      position: 3
    default: 4

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
  pairout1:
    type: "File?"
    outputBinding:
      glob: "*1P.fastq.gz"

  upairout1:
    type: "File?"
    outputBinding:
      glob: "*1U.fastq.gz"

  pairout2:
    type: "File?"
    outputBinding:
      glob: "*2P.fastq.gz"

  upairout2:
    type: "File?"
    outputBinding:
      glob: "2U.fastq.gz"

baseCommand:
 - "run-trim.sh"
