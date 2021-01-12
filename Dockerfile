FROM google/cloud-sdk:latest

RUN apt-get update
RUN apt-get --yes install openjdk-11-jre
RUN apt-get --yes install samtools
RUN apt-get --yes install picard-tools
RUN apt-get --yes install pigz

ADD cram2fastq cram2fastq
ADD cram2bam cram2bam
ADD bam2fastq bam2fastq

ENTRYPOINT ["./cram2fastq"]
