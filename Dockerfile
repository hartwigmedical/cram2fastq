FROM google/cloud-sdk:latest

RUN apt-get update
RUN apt-get --yes install openjdk-11-jre
RUN apt-get --yes install samtools
RUN apt-get --yes install picard-tools
RUN apt-get --yes install pigz

ENV BASEPATH=/home/dockerguy
ENV PATH=$PATH:$BASEPATH
ENV PICARDDIR="/usr/share/java"

WORKDIR $BASEPATH

COPY cram2fastq cram2bam bam2fastq ./

ENTRYPOINT ["./cram2fastq"]