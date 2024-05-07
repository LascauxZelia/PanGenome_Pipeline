process PANGENOME {
    tag "${gff}"
    
    publishDir "results/pangenome/summary_statistics.txt", mode: 'copy'
    publishDir "results/pangenome/gene_presence_absence.csv", mode: 'copy'

    input:
    tuple val(genome), path(fa), path(gff)
    val cpus
    
    output:
    path 'core_alignment_header.embl', emit: embl_file
    path 'core_gene_alignment.aln', emit: aln
    path 'summary_statistics.txt', emit: stats
    path 'gene_presence_absence.csv', emit: pangenome_matrix
    path '*.Rtab', emit: rtab
    path "*", emit: pangenome
    
    script:
    """
    roary -f pangenome -p '$cpus' -e -n -v '$gff'
    """
}