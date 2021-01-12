FROM google/cloud-sdk:latest

RUN apt-get update
RUN apt-get --yes install openjdk-11-jre

ENV BASEPATH=/home/dockerguy
ENV PATH=$PATH:$BASEPATH

WORKDIR $BASEPATH

COPY cram2fastq $BASEPATH/cram2fastq
COPY cram2bam $BASEPATH/cram2bam
COPY bam2fastq $BASEPATH/bam2fastq

ENTRYPOINT ["./cram2fastq"]