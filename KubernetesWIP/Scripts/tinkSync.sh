#!/bin/sh

ls -lah /manifests

for FILE in /manifests/*-tinkhardware.yaml; do
  echo "Processing hardware file ${FILE}"
done

for WorkflowFile in /manifests/*-tinkworkflow.yaml; do
  echo "Processing worklow file ${WorkflowFile}"
done

echo "Done?"
