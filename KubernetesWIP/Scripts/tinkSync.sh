#!/bin/sh

ls -lah /manifests

for FILE in /manifests/*-tinkhardware.yaml; do
  echo "Processing hardware file ${FILE}"
done

for WorkflowFile in /manifests/*-tinkworkflow.yaml; do
  IGNITION_CONFIG="$(cat /etc/ignition.yaml)"
  IGNITION_B64=$(echo "${IGNITION_CONFIG}" | base64)

  echo "Processing worklow file ${WorkflowFile} with aditional ${IGNITION_B64}"
done

echo "Done?"
