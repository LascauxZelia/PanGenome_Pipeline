process TREE {

    input:
    path (aln)
    path (partition)
    val bootstrap
    val ncat
    val prefix
    val cpus
    
    output:
    path "*", emit: tree_directory
    path "*.nwk", emit: nwk
    
    script:
    """
    iqtree -s '$aln' -p '$partition' --seqtype DNA -m MFP -cmax '$ncat' -T AUTO -ntmax '$cpus' --prefix '$prefix' -B '$bootstrap' -bnni --safe
    """
}