process assembly {
    input:
        val mypath
    output:
        //stdout
        val mypath
        //path "pyoutputs.txt", emit: pyoutputs
        
    
    """ 
    samplename=\$(echo ${mypath} | rev | cut -d "/" -f 1 | rev)
    #Call variants
    mkdir ${mypath}/variants
    singularity exec docker://staphb/samtools:1.12 samtools mpileup -A -d 8000 --reference ${params.reference}/NC_009942.fasta -B -Q 0 -o ${mypath}/alignment/\${samplename}.mpileup ${mypath}/alignment/\${samplename}.primertrim.sorted.bam
    cat ${mypath}/alignment/\${samplename}.mpileup | tee | singularity exec docker://staphb/ivar:1.3.2 ivar variants -r ${params.reference}/NC_009942.fasta -m 10 -p ${mypath}/variants/\${samplename}.variants -q 20 -t 0.25 -g ${params.reference}/nc009942.gff3
   
    #Generate consensus assembly
    mkdir ${mypath}/assembly
    #singularity exec docker://staphb/samtools:1.12 samtools mpileup -A -B -d 8000 --reference ${params.reference}/NC_009942.fasta -Q 0 ${mypath}/alignment/\${samplename}.primertrim.sorted.bam 
    cat ${mypath}/alignment/\${samplename}.mpileup | tee | singularity exec docker://staphb/ivar:1.3.2 ivar consensus -t 0 -m 10 -n N -p ${mypath}/assembly/\${samplename}.consensus

    """
}
