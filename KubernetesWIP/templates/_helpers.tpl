{{/* vim: set filetype=gohtmltmpl: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kubernetes.name" -}}
{{- default "kubernetes" .Values.kubernetes.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kubernetes.rootDomain" -}}
{{- default "cluster.local" .Values.kubernetes.hostClusterDomain -}}
{{- end -}}

{{- define "kubernetes.clusterDomain" -}}
{{- default "cluster.local" .Values.kubernetes.clusterName -}}
{{- end -}}

{{- define "kubernetes.rootSearchDomain" -}}
{{- $domain := include "kubernetes.rootDomain" . -}}
{{- printf "%s.svc.%s" .Release.Namespace $domain }}
{{- end -}}

{{- define "kubernetes.clusterSearchDomain" -}}
{{- $domain := include "kubernetes.clusterDomain" . -}}
{{- printf "%s.svc.%s" "default" $domain }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubernetes.fullname" -}}
{{- if .Values.kubernetes.fullnameOverride -}}
{{- .Values.kubernetes.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "kubernetes" .Values.kubernetes.nameOverride -}}
{{- if or (eq $name .Release.Name) (eq (.Release.Name | upper) "RELEASE-NAME") -}}
{{- $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create a default certificate name.
*/}}
{{- define "kubernetes.certname" -}}
{{- if .Values.kubernetes.certnameOverride -}}
{{- .Values.kubernetes.certnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- template "kubernetes.fullname" . -}}
{{- end -}}
{{- end -}}



{{/*
Take the first IP address from the serviceSubnet for the kube-dns service.
*/}}
{{- define "kubernetes.getCoreDNS" -}}
  {{- $octetsList := splitList "." .Values.kubernetes.networking.serviceSubnet -}}
  {{- printf "%d.%d.%d.%d" (index $octetsList 0 | int) (index $octetsList 1 | int) (index $octetsList 2 | int) 10 -}}
{{- end -}}

{{- define "kubernetes.getServiceAPIAddress" -}}
  {{- $octetsList := splitList "." .Values.kubernetes.networking.serviceSubnet -}}
  {{- printf "%d.%d.%d.%d" (index $octetsList 0 | int) (index $octetsList 1 | int) (index $octetsList 2 | int) 1 -}}
{{- end -}}

{{- define "kubernetes.getAPIHostnamePort" -}}
  {{- printf "%s:%d" (.Values.kubernetes.apiServer.service.loadBalancerIP | toString) (.Values.kubernetes.apiServer.port | int)  -}}
{{- end -}}

