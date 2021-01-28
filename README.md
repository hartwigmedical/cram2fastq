# cram2fastq
Takes a CRAM URL, converts to FASTQ and uploads to GCS bucket.

### Running in Kubernetes

Need to have the right credentials and a cluster (only need this step once).

```shell script
gcloud container clusters get-credentials rerun-cluster --region europe-west4 --project hmf-crunch>
```

Execute

```shell script
cram2fastq_k8 run <cram-url> <output-bucket> <sample-name>
```

Monitoring

```shell script
kubectl get jobs
kubectl get pods
kubectl logs <pod-name>
```