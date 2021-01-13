FROM google/cloud-sdk:latest

# add repo tools
RUN apt-get update
RUN apt-get --yes install openjdk-11-jre
RUN apt-get --yes install pigz
RUN apt-get --yes install picard-tools

# add helper scripts
ADD bam2fastq bam2fastq
ADD cram2bam cram2bam
ADD cram2fastq cram2fastq
ADD cram_or_bam_to_fastq cram_or_bam_to_fastq

# install samtools
ADD "https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2" "samtools-1.11.tar.bz2"
RUN tar xjf "samtools-1.11.tar.bz2" \
    && cd samtools-1.11 \
    && ./configure --prefix=/usr \
    && make \
    && make install

# final preparations
RUN chmod +x bam2fastq cram2bam cram2fastq

ENTRYPOINT ["./cram2fastq"]