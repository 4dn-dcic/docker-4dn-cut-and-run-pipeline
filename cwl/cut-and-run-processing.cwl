#!/usr/bin/env cwl-runner

class: "Workflow"

cwlVersion: v1.0

requirements:
- class: "InlineJavascriptRequirement"

- class: "DockerRequirement"
  dockerPull: "4dndcic/cut-and-run-pipeline:v1"
- class: "ScatterFeatureRequirement"


fdn_meta:
  category: "filter"
  data_types:
    - "CUT&RUN"
  description: "This is a subworkflow of the CUT&RUN processing pipeline. It takes in fastqs as input and performs merging, trimming, alignment, sorting, and creates coverage tracks. It produces a bedpe and a bigwig file."
  name: "cut-and-run-processing"
  title: "CUT&RUN Primary Processing"
  workflow_type: "CUT&RUN data analysis"

inputs:
  -
    fdn_format: "fastq"
    id: "#input_fastqs_R1"
    type: 
      -
        items: "File"
        type: "array"

  -
    fdn_format: "fastq"
    id: "#input_fastqs_R2"
    type: 
      -
        items: "File"
        type: "array"

  -
    fdn_format: "chromsizes"
    id: "#chr_sizes"
    type: "File"

  -
    fdn_format: "bowtie2_index"
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
    fdn_format: "bam"
    fdn_output_type: "processed"
    id: "#out_bam"
    outputSource: "#bowtie2/out_bam"
    type: "File?"

  -
    fdn_format: "bedpe"
    fdn_output_type: "processed"
    id: "#out_bedgraph"
    outputSource: "#viz/out_bedgraph"
    type: "File?"

  -
    fdn_format: "bigwig"
    fdn_output_type: "processed"
    id: "#out_bw"
    outputSource: "#viz/out_bw"
    type: "File?"

steps:
  -
    fdn_step_meta:
      analysis_step_types:
        - "merging"
      description: "Merging the fastq files"
    id: "#fastq_merge_1"
    in:
      -
        arg_name: "fastqs"
        fdn_format: "fastq"
        id: "#fastq_merge_1/fastq"
        source: "#input_fastqs_R1"
    out:
      -
        arg_name: "merged_fastq"
        fdn_format: "fastq"
        id: "#fastq_merge_1/merged_fastq"
    run: "fastq-merge.cwl"

  -
    fdn_step_meta:
      analysis_step_types:
        "merging"
      description: "Merging the second set of fastq files"
      software_used: ""
    id: "#fastq_merge_2"
    in:
      -
        arg_name: "fastqs"
        fdn_format: "fastq"
        id: "#fastq_merge_2/fastq"
        source: "#input_fastqs_R2"
    out:
      -
        arg_name: "merged_fastq"
        fdn_format: "fastq"
        id: "#fastq_merge_2/merged_fastq"
    run: "fastq-merge.cwl"

  -
    fdn_step_meta:
      analysis_step_types:
        "trimming"
      description: "Trimming the fastq files"
      software_used: "Trimmomatic_0.36"
    id: "#trim"
    in:
      -
        arg_name: "fastq1"
        fdn_format: "fastq"
        id: "#trim/fastq1"
        source: "#fastq_merge_1/merged_fastq"
        
      -
        arg_name: "fastq2"
        fdn_format: "fastq"
        id: "#trim/fastq2"
        source: "#fastq_merge_2/merged_fastq"
      
      -
        arg_name: "threads"
        id: "#trim/threads"
        source: "#nthreads_trim"
    out:
      -
        arg_name: "pairout1"
        fdn_format: "fastq"
        id: "#trim/pairout1"

      -
        arg_name: "pairout2"
        fdn_format: "fastq"
        id: "#trim/pairout2"
        
    run: "trim.cwl"
    
  -
    fdn_step_meta:
      analysis_step_types:
        "alignment"
      description: "Aligning the fastq files"
      software_used: "Bowtie_2.2.6"
    id: "#bowtie2"
    in:
      -
        arg_name: "fastq1"
        fdn_format: "fastq"
        id: "#bowtie2/fastq1"
        source: "#trim/pairout1"
        
      -
        arg_name: "fastq2"
        fdn_format: "fastq"
        id: "#bowtie2/fastq2"
        source: "#trim/pairout2"
      
      -
        arg_name: "index"
        fdn_format: "uncompressed_bowtie2Index"
        id: "#bowtie2/index"
        source: "#bowtie2_index"

      -
        arg_name: "threads"
        id: "#bowtie2/threads"
        source: "#nthreads_aln"

    out:
      -
        arg_name: "out_bam"
        fdn_format: "bam"
        id: "#bowtie2/out_bam"
    run: "bowtie2.cwl"
  
  -
    fdn_step_meta:
      analysis_step_types:
        - "merging"
        - "sorting"
      description: "Converting bam into bedpe, merging and sorting"
      software_used: "bedtools_2.29.0"
    id: "#merge_bamtobed"
    in:
      -
        arg_name: "bams"
        fdn_format: "bam"
        id: "#merge_bamtobed/bams"
        source: "#bowtie2/out_bam"
    out:
      -
        arg_name: "out_bedpe"
        fdn_format: "bedpe"
        id: "#merge_bamtobed/out_bedpe"
    run: "merge-bamtobed.cwl"
  
  -
    fdn_step_meta:
      analysis_step_types:
        "coverage"
      description: "Generating coverage tracks"
      software_used: "bedGraphToBigWig"
    id: "#viz"
    in:
      -
        arg_name: "bedpe"
        fdn_format: "bedpe"
        id: "#viz/bedpe"
        source: "#merge_bamtobed/out_bedpe"
        
      -
        arg_name: "chr_sizes"
        fdn_format: "chromsizes"
        id: "#viz/chr_sizes"
        source: "#chr_sizes"
      
    out:
      -
        arg_name: "out_bedgraph"
        fdn_format: "bg"
        id: "#viz/out_bedgraph"

      -
        arg_name: "out_bw"
        fdn_format: "bw"
        id: "#viz/out_bw"

    run: "viz.cwl"

