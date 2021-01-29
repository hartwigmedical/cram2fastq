# cram2fastq
Takes a CRAM URL, converts to FASTQ and uploads to GCS bucket.

### Running in Kubernetes

Need to have the right credentials and a cluster (only need this step once).
```shell script
gcloud container clusters get-credentials rerun-cluster --region europe-west4 --project hmf-crunch>
```

Execute
```shell script
cram2fastq_k8 run <gcp-user-project> <cram-url> <output-bucket> <sample-name>
```

Example HMF
```shell script
# execute
cram2fastq_k8 run "hmf-crunch" "gs://hmf-cram2fastq/cram/CPCT12345678T.cram" "hmf-cram2fastq" "CPCT12345678R"

# output will then be in
gs://hmf-cram2fastq/CPCT12345678T_FASTQ
```

Monitoring
```shell script
kubectl get jobs | grep cram2f
kubectl get pods | grep cram2f
kubectl logs <pod-name>
```