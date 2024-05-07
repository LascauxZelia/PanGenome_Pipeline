/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    PRINT PARAMS SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//include { paramsSummaryLog; paramsSummaryMap } from 'plugin/nf-validation'

//def logo = NfcoreTemplate.logo(workflow, params.monochrome_logs)
//def citation = '\n' + WorkflowMain.citation(workflow) + '\n'
//def summary_params = paramsSummaryMap(workflow)

// Print parameter summary log to screen
//log.info logo + paramsSummaryLog(workflow) + citation

//WorkflowSievemod.initialise(params, log)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CONFIG FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// MODULE: Installed from local

include { ANNOTATION                     } from '../modules/local/prokka'
include { DIAMOND                        } from '../modules/local/diamond'
include { PANGENOME                      } from '../modules/local/roary'
include { PLOT                           } from '../modules/local/plot'
include { TREE                           } from '../modules/local/tree'
include { STATS                          } from '../modules/local/stats'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow PANGENOME {

    ch_genomes =  Channel.fromFilePairs('resources/genomes/*.fa', size: 1)

    //MODULE: ANNOTATION
    ANNOTATION(ch_genomes, params.kingdom, params.species, params.strain, params.mincontiglen, params.cpus)

    //MODULE: PANGENOME
    PANGENOME(ANNOTATION.out.gff, params.cpus)

    //MODULE: PARTITION
    PARTITION(PANGENOME.out.embl)

    //MODULE: TREE
    TREE(PANGENOME.out.aln, PARTITION.out.nex, params.bootstrap, params.ncat, params.prefix, params.cpus)

    //MODULE: PLOT
    PLOT(PANGENOME.out.rtab)

    //MODULE: SCOARY
    SCOARY(PANGENOME.out.pangenome_matrix, TREE.out.nwk, params.traits_csv, params.pvalue, )


}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    COMPLETION SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow.onComplete {

    println ( workflow.success ? """
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """ : """
        Failed: ${workflow.errorReport}
        exit status : ${workflow.exitStatus}
        """
    )
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/