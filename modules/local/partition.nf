process PARTITION {

    input:
    path (embl_file)
    
    output:
    path "core_gene_partition.nex", emit: nex
    
    script:
    """
    # Creates a NEXUS file with partitions
    # Standard SeqIO.write doesn't work without sequences

    from Bio import SeqIO
    import os

    # read the embl file with partitions
    embl = SeqIO.read('$embl_file')
    # features contain start and stop for each gene in core_gene_alignment

    # form a NEXUS file
    nexus = ["#NEXUS", "BEGIN SETS;"]
    for i in range(len(embl.features)):
        start = int(embl.features[i].location.start)
        end = int(embl.features[i].location.end)
        charset = "  charset part%i = %s-%s;" % (i+1, start+1, end)
        nexus.append(charset)
    # add list line of the NEXUS file
    nexus.append("END;")

    # write it
    with open(output_nexus, 'w') as f:
        for line in nexus:
            f.write("%s\n" % line)
    """
}