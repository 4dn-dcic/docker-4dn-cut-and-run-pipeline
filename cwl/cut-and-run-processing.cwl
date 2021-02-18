#!/usr/bin/env cwl-runner

class: "Workflow"

cwlVersion: v1.0

requirements:
- class: "InlineJavascriptRequirement"

- class: "DockerRequirement"
  dockerPull: "4dndcic/cut-and-run-pipeline:v1"

fdn_meta:
  category: "filter"
  data_types:
      - "CUT&RUN"
  description: "This is a subworkflow of the CUT&RUN processing pipeline. It takes in fastqs as input and performs merging, trimming, alignment, sorting, and creates coverage tracks. It produces a bedpe and a bigwig file."
  name: "cut-and-run-processing"
  title: "CUT&RUN Primary Processing"
  workflow_type: "CUT&RUN data analysis"

inputs:
  input_fastqs_R1:
    fdn_format: "fastq"
    type: 
      -
        items: "File"
        type: "array"

  input_fastqs_R2:
    fdn_format: "fastq"
    type: 
      -
        items: "File"
        type: "array"

  chr_sizes:
    fdn_format: "chromsizes"
    type: "File"

  bowtie2_index:
    fdn_format: "bowtie2_index"
    type: "File"

  nthreads_trim:
    type: "int"
    default: 4

  nthreads_aln:
    type: "int"
    default: 4

outputs:
  out_bam:
    fdn_format: "bam"
    fdn_output_type: "processed"
    outputSource: "bowtie2/out_bam"
    type: "File?"

  out_bedgraph:
    fdn_format: "bedpe"
    fdn_output_type: "processed"
    outputSource: "viz/out_bedgraph"
    type: "File?"

  out_bw:
    fdn_format: "bigwig"
    fdn_output_type: "processed"
    outputSource: "viz/out_bw"
    type: "File?"

steps:
  fastq_merge_1:
    fdn_step_meta:
      analysis_step_types:
        "merging"
      description: "Merging the fastq files"
      software_used: ""
    in:
      fastq_merge_1/fastq:
        arg_name: "fastqs"
        fdn_format: "fastq"
        source: "input_fastqs_R1"
    out:
      fastq_merge_1/merged_fastq:
        arg_name: "merged_fastq"
        fdn_format: "fastq"
    run: "fastq-merge.cwl"

  fastq_merge_2:
    fdn_step_meta:
      analysis_step_types:
        "merging"
      description: "Merging the second set of fastq files"
      software_used: ""
    in:
      fastq_merge_2/fastq:
        arg_name: "fastqs"
        fdn_format: "fastq"
        source: "input_fastqs_R2"
    out:
      fastq_merge_2/merged_fastq:
        arg_name: "merged_fastq"
        fdn_format: "fastq"
    run: "fastq-merge.cwl"

  trim:
    fdn_step_meta:
      analysis_step_types:
        "trimming"
      description: "Trimming the fastq files"
      software_used: "Trimmomatic_0.36"
    in:
      trim/fastq1:
        arg_name: "fastq1"
        fdn_format: "fastq"
        source: "fastq_merge_1/merged_fastq"
        
      trim/fastq2:
        arg_name: "fastq2"
        fdn_format: "fastq"
        source: "fastq_merge_2/merged_fastq"
      
      trim/threads:
        arg_name: "threads"
        source: "nthreads_trim"
    out:
      trim/pairout1:
        arg_name: "pairout1"
        fdn_format: "fastq"

      trim/pairout2:
        arg_name: "pairout2"
        fdn_format: "fastq"
        
    run: "trim.cwl"
    
  bowtie2:
    fdn_step_meta:
      analysis_step_types:
        "alignment"
      description: "Aligning the fastq files"
      software_used: "Bowtie_2.2.6"
    in:
      bowtie2/fastq1:
        arg_name: "fastq1"
        fdn_format: "fastq"
        source: "trim/pairout1"
        
      bowtie2/fastq2:
        arg_name: "fastq2"
        fdn_format: "fastq"
        source: "trim/pairout2"
      
      bowtie2/index:
        arg_name: "index"
        fdn_format: "uncompressed_bowtie2Index"
        source: "bowtie2_index"

      bowtie2/threads:
        arg_name: "threads"
        source: "nthreads_aln"

    out:
      bowtie2/out_bam:
        arg_name: "out_bam"
        fdn_format: "bam"
    run: "bowtie2.cwl"
  
  merge_bamtobed:
    fdn_step_meta:
      analysis_step_types:
        "merging"
        "sorting"
      description: "Converting bam into bedpe, merging and sorting"
      software_used: "bedtools_2.29.0"
    in:
      merge_bamtobed/bams:
        arg_name: "bams"
        fdn_format: "bam"
        source: "bowtie2/out_bam"
    out:
      merge_bamdtobed/out_bedpe:
        arg_name: "out_bedpe"
        fdn_format: "bedpe"
    run: "merge_bamtobed.cwl"
  
  viz:
    fdn_step_meta:
      analysis_step_types:
        "coverage"
      description: "Generating coverage tracks"
      software_used: "bedGraphToBigWig"
    in:
      viz/bedpe:
        arg_name: "bedpe"
        fdn_format: "bedpe"
        source: "merge_bamtobed/out_bedpe"
        
      viz/chr_sizes:
        arg_name: "chr_sizes"
        fdn_format: "chromsizes"
        source: "chr_sizes"
      
    out:
      viz/out_bedgraph:
        arg_name: "out_bedgraph"
        fdn_format: "bg"

      viz/out_bw:
        arg_name: "out_bw"
        fdn_format: "bw"

    run: "viz.cwl"

