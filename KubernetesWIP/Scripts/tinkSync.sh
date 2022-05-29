#!/bin/sh

ls -lah /manifests

for FILE in /manifests/*-tinkhardware.yaml; do
  kubectl apply -f ${FILE}
  echo "Processing hardware file ${FILE}"
done

for WorkflowFile in /manifests/*-tinkworkflow.yaml; do
  IGNITION_CONFIG="$(cat /etc/ignition.yaml)"
  IGNITION_B64=$(echo "${IGNITION_CONFIG}" | base64 | tr -d '\n')

  WORKFLOW_FILE="$(cat ${WorkflowFile})"

  kubectl apply -n core-prod -f - <<EOT
${WORKFLOW_FILE}
    config: ${IGNITION_B64}
EOT

  echo "Processing worklow file ${WorkflowFile} with aditional ${IGNITION_B64}"
done

echo "Done?"
