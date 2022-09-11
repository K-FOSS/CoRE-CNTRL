#!/bin/sh

echo "Deploying Konnectivity"

ls -lah /manifests

cat /manifests/*
kubectl apply -f /manifests
