#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LascauxZelia/PanGenome_Pipeline
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/LascauxZelia/PanGenome_Pipeline
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE & PRINT PARAMETER SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Print help message if needed
if (params.help || params.h) {
    helpMessage()
    citationInfo()
    System.exit(0)
}else if ( !(params.resultsDir) ) {
  log.info "ERROR: no output directory given, will not continue"
  helpMessage()
  exit 0
}

citationInfo()
startupMessage()

def versionLogo() {
  log.info "================================================================================="
  log.info "================================================================================="
  log.info "=====================     PANGENOME  PIPELINE  VERSION 0.1    ==================="
  log.info "================================================================================="
  log.info "================================================================================="
  log.info "Author                                        : Zelia Bontemps"
  log.info "email                                         : zelia.bontemps@imbim.uu.se"
  log.info "version                                       : 0.1"
  log.info ""
}

def citationInfo() {
  log.info "============================ Citation =========================================="
  log.info "XX pipeline is published in XX and available here:"
  log.info "doi:10."
  log.info ""
}

def startupMessage(){
  log.info "====================== Local data options ======================================"
  log.info "Single_end                                   : $params.single_end"
  log.info "Local_input                                  : $params.local_input"
  log.info "assembly_input                               : $params.assembly_input"
  log.info ""
  log.info "====================== Diamond options ======================================="
  log.info "No diamond                                   : $params.nodiamond"
  log.info "Minimum number of reads alignments           : $params.diamond_min_align_reads"
  log.info ""
  log.info "====================== MacSyFinder options ==================================="
  log.info "No MacSyFinder                               : $params.nomacsyfinder"
  log.info "Model path                                   : $params.modelpath"
  log.info "Model name                                   : $params.model"
  log.info "Nomber of models                             : $params.nbmodel"
  log.info "Coverage                                     : $params.coverage"
  log.info "evalue                                       : $params.evalue"
  log.info ""
  log.info "====================== Output options ========================================"
  log.info "Main output dir (general)                    : $params.resultsDir"
  log.info "Publish dir mode                             : $params.publish_dir_mode"
  log.info ""
  log.info "====================== Run options =========================================="
  log.info "Help                                         : $params.help"
  log.info "Number of threads                            : $params.cpus"
  log.info "Binaries location (use default if singularity image is used)"
  log.info "Python 3 binary used                         : $params.python3"
  log.info ""
}

def helpMessage() {
  // Display help message
  log.info "========================== Usage ========================================="
  log.info ""
  log.info "Example:"
  log.info "nextflow run main.nf "
  log info "           --resultsDir <OUTDIR> "
  log info "           --genomes <PATH/TO/CAT_database> "
  log.info ""
  log.info "Options:"
  log.info "--help, --h                       : Show this help and exit"
  log.info "Please read the documentation: github.com/LascauxZelia/PanGenome_Pipeline"
  log.info ""
  log.info "========================================================================="
}
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOW FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { PANGENOME } from './workflows/pangenome'

//
// WORKFLOW: Run main LascauxZelia/sieve analysis pipeline
//
workflow NF_PANGENOME {
    PANGENOME ()
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN ALL WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
//
workflow {
    NF_PANGENOME ()
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
