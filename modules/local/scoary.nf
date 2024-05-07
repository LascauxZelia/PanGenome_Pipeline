process GWAS {

    input:
    path (matrix)
    path (traits)
    val pvalue
    val evalue
    val cpus
    
    output:
    path "*", emit: gwas
    
    script:
    """
    scoary -g '$matrix' -t '$traits' -o scoary_out -p '$pvalue' -e '$evalue' --threads '$cpus'
    """
}


