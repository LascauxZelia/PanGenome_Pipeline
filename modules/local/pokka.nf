process ANNOTATION {
    publishDir "results/annotations/${genome.baseName}/*", mode: 'copy'

    input:
    tuple val(genome), path(fa)
    val kingdom
    val genus
    val species
    val strain
    val mincontiglen
    val cpus
    
    output:
    tuple val(genome), path(fa), path('*_genomic.gff'), emit: gff
    path "*", emit: annotation_all
    
    script:
    """
    prokka --addgenes --addmrna --compliant --notrna --force \\
           --outdir results/annotations/${genome.baseName} \\
           --locustag ${genome.baseName} \\
           --prefix ${genome.baseName}_genomic \\
           --centre UU --genus "$genus" \\
           --species "$species" --strain "$strain" \\
           --kingdom "$kingdom" --cpus "$cpus" \\
           --mincontiglen "$mincontiglen" ${fa} &> results/logs/${genome.baseName}_prokka.log
    """
}