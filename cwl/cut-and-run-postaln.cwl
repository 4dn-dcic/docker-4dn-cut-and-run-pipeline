---
class: "Workflow"

cwlVersion: v1.0

requirements:
- class: "InlineJavascriptRequirement"

- class: "ScatterFeatureRequirement"

inputs:
  -
    id: "#input_bedpe"
    type:
      - "null"
      -
        items: "File"
        type: "array"
  
  -
    id: "#input_bedpe_ctl"
    type:
      - "null"
      -
        items: "File"
        type: "array"

  -
    id: "#chr_sizes"
    type: "File"

  -
    id: "#is_ctl"
    type: "boolean"
    default: "true"

  -
    id: "#norm"
    type: "string"
    default: "norm"
  
  -
    id: "#stringency"
    type: "string"
    default: "relaxed"

outputs:
  -
    id: "#out_bedg"
    outputSource: "#peak/out_bedg"
    type: "File?"

  -
    id: "#out_bw"
    outputSource: "#viz/out_bw"
    type: "File?"

steps:
  -
    id: "#bedpe_merge"
    in:
      -
        id: "#bedpe_merge/bedpes"
        source: "#input_bedpe"
    out:
      -
        id: "#bedpe_merge/merged_bedpe"
    run: "merge.cwl"

  -
    id: "#bedpe_merge_ctl"
    in:
      -
        id: "#bedpe_merge_ctl/bedpes"
        source: "#input_bedpe_ctl"
    out:
      -
        id: "#bedpe_merge_ctl/merged_bedpe"
    run: "merge.cwl"
  -
    id: "#viz"
    in:
      -
        id: "#viz/bedpe"
        source: "#bedpe_merge/merged_bedpe"
      -
        id: "#viz/chr_sizes"
        source: "#chr_sizes"
    out:
      -
        id: "#viz/out_bedgraph"
      -
        id: "#viz/out_bw"
    run: "viz.cwl"
  -
    id: "#viz_ctl"
    in:
      -
        id: "#viz_ctl/bedpe"
        source: "#bedpe_merge_ctl/merged_bedpe"
      -
        id: "#viz/chr_sizes"
        source: "#chr_sizes"
      -
        id: "#viz/is_ctl"
        source: "is_ctl"
    out:
      -
        id: "#viz_ctl/out_bedgraph"
      -
        id: "#viz/out_bw"
    run: "viz.cwl"
  -
    id: "#peak"
    in:
      -
        id: "#peak/input_bg"
        source: "#viz/out_bedgraph"
      -
        id: "#peak/input_bg_ctl"
        source: "#viz_ctl/out_ctl_bedgraph"
      -
        id: "#peak/norm"
        source: "#norm"
      -
        id: "#peak/stringency"
        source: "#stringency"
    out:
      -
        id: "#peak/out_bedg"
    run: "peak.cwl"
