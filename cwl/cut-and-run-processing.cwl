---
class: "Workflow"

cwlVersion: v1.0

requirements:
- class: "InlineJavascriptRequirement"

- class: "ScatterFeatureRequirement"

inputs:
  -
    id: "#input_fastqs_R1"
    type: 
      - "null"
      -
        items: "File"
        type: "array"

  -
    id: "#input_fastqs_R2"
    type: 
      - "null"
      -
        items: "File"
        type: "array"

  -
    id: "#chr_sizes"
    type: "File"

  -
    id: "#bowtie2_index"
    type: "File"

  -
    type: "int"
    id: "#nthreads_trim"
    default: 4

  -
    type: "int"
    id: "#nthreads_aln"
    default: 4

outputs:
  -
    id: "#out_bam"
    outputSource: "#bowtie2/out_bam"
    type:
      items: "File"
  -
    id: "#out_bedgraph"
    outputSource: "#viz/out_bedgraph"
    type: "File?"

  -
    id: "#out_bw"
    outputSource: "#viz/out_bw"
    type: "File?"

steps:
  -
    id: "#fastq_merge_1"
    in:
      -
        id: "#fastq_merge_1/fastqs"
        source: "#input_fastqs_R1"
    out:
      -
        id: "#fastq_merge_1/merged_fastq"
    run: "fastq-merge.cwl"

  -
    id: "#fastq_merge_2"
    in:
      -
        id: "#fastq_merge_2/fastqs"
        source: "#input_fastqs_R2"
    out:
      -
        id: "#fastq_merge_2/merged_fastq"
    run: "fastq-merge.cwl"

  -
    id: "#trim"
    in:
      -
        id: "#trim/fastq1"
        source: "#fastq_merge_1/merged_fastq"
        
      -
        id: "#trim/fastq2"
        source: "#fastq_merge_2/merged_fastq"
      
      -
        id: "#trim/threads"
        source: "#nthreads_trim"
    out:
      -
        id: "#trim/pairout1"

      -
        id: "#trim/pairout2"
        
    run: "trim.cwl"
    
  -
    id: "#bowtie2"
    in:
      -
        id: "#bowtie2/fastq1"
        source: "#trim/pairout1"
        
      -
        id: "#bowtie2/fastq2"
        source: "#trim/pairout2"
      
      -
        id: "#bowtie2/index"
        source: "#bowtie2_index"

      -
        id: "#bowtie2/threads"
        source: "#nthreads_aln"

    out:
      -
        id: "#bowtie2/out_bam"
    run: "bowtie2.cwl"
  
  -
    id: "#merge_bamtobed"
    in:
      -
        id: "#merge_bamtobed/bams"
        source: "#bowtie2/out_bam"
    out:
      -
        id: "#merge_bamtobed/out_bedpe"
    run: "merge-bamtobed.cwl"
  
  -
    id: "#viz"
    in:
      -
        id: "#viz/bedpe"
        source: "#merge_bamtobed/out_bedpe"
        
      -
        id: "#viz/chr_sizes"
        source: "#chr_sizes"
      
    out:
      -
        id: "#viz/out_bedgraph"

      -
        id: "#viz/out_bw"

    run: "viz.cwl"

