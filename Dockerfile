FROM google/cloud-sdk:latest

RUN apt-get update
RUN apt-get --yes install openjdk-11-jre

ADD cram2fastq cram2fastq

ENTRYPOINT ["./cram2fastq"]