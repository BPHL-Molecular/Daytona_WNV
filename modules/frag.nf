process frag {
    input:
        val mypath
 
    output:
        //stdout
        val mypath
        //path "pyoutputs.txt", emit: pyoutputs

    """
    samplename=\$(echo ${mypath} | rev | cut -d "/" -f 1 | rev)

    #Run kraken to check original fastq data in input folder for their species
    mkdir -p ${mypath}/kraken_out/
    singularity exec --cleanenv docker://staphb/kraken2:2.0.8-beta kraken2 --db /kraken2-db/minikraken2_v1_8GB/ --use-names --report ${mypath}/kraken_out/\${samplename}.report --output ${mypath}/kraken_out/\${samplename}_kraken.out --paired ${params.input}/\${samplename}_1.fastq.gz ${params.input}/\${samplename}_2.fastq.gz


    #singularity exec docker://staphb/bwa:latest bwa mem ${params.reference}/NC_009942.fasta ${mypath}/\${samplename}_1.fq.gz ${mypath}/\${samplename}_2.fq.gz|singularity exec docker://staphb/samtools:1.12 samtools view - -F 4 -u -h|singularity exec docker://staphb/samtools:1.12 samtools sort -n > ${mypath}/alignment/\${samplename}.namesorted.bam
    singularity exec docker://staphb/bwa:latest bwa mem ${params.reference}/NC_009942.fasta ${mypath}/\${samplename}_1.fq.gz ${mypath}/\${samplename}_2.fq.gz > ${params.output}/\${samplename}/aln-se.sam
    singularity exec docker://staphb/samtools:1.12 samtools view -F 4 -u -h -bo ${params.output}/\${samplename}/aln-se.bam ${params.output}/\${samplename}/aln-se.sam
    singularity exec docker://staphb/samtools:1.12 samtools sort -n -o ${params.output}/\${samplename}/alignment/\${samplename}.namesorted.bam ${params.output}/\${samplename}/aln-se.bam

    singularity exec docker://staphb/samtools:1.12 samtools fixmate -m ${mypath}/alignment/\${samplename}.namesorted.bam ${mypath}/alignment/\${samplename}.fixmate.bam

        #Create positional sorted bam from fixmate.bam
    singularity exec docker://staphb/samtools:1.12 samtools sort -o ${mypath}/alignment/\${samplename}.positionsort.bam ${mypath}/alignment/\${samplename}.fixmate.bam

        #Mark duplicate reads
    singularity exec docker://staphb/samtools:1.12 samtools markdup ${mypath}/alignment/\${samplename}.positionsort.bam ${mypath}/alignment/\${samplename}.markdup.bam

        #Remove duplicate reads
    singularity exec docker://staphb/samtools:1.12 samtools markdup -r ${mypath}/alignment/\${samplename}.positionsort.bam ${mypath}/alignment/\${samplename}.dedup.bam

        #Sort dedup.bam and rename to .sorted.bam
    singularity exec docker://staphb/samtools:1.12 samtools sort -o ${mypath}/alignment/\${samplename}.sorted.bam ${mypath}/alignment/\${samplename}.dedup.bam

       #Index final sorted bam
    
    """
}
