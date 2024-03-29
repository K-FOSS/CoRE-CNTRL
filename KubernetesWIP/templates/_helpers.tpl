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
{{- printf "%s.svc.%s" .Release.Namespace $domain -}}
{{- end -}}

{{- define "kubernetes.defaultClusterSearchDomain" -}}
{{- $domain := include "kubernetes.rootDomain" . -}}
{{- printf "%s.svc.%s" "default" $domain -}}
{{- end -}}

{{- define "kubernetes.clusterSearchDomain" -}}
{{- $domain := include "kubernetes.clusterDomain" . -}}
{{- printf "%s.svc.%s" "default" $domain -}}
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

{{- define "kubernetes.getKonnectivityAddress" -}}
{{- if eq .Values.kubernetes.konnectivityServer.service.type "LoadBalancer" -}}
{{- printf "%s" (.Values.kubernetes.konnectivityServer.service.loadBalancerIP | toString)  -}}
{{- else -}}
{{- template "kubernetes.fullname" . -}}-konnectivity-server.{{- template "kubernetes.rootDomain" -}}
{{- end -}}
{{- end -}}

{{- define "kubernetes.domains" -}}
{{- $rootSearchDomain := include "kubernetes.rootSearchDomain" . -}}
{{- $clusterRootDomain := include "kubernetes.clusterSearchDomain" . -}}
{{- $defaultClusterSearchDomain := include "kubernetes.defaultClusterSearchDomain" . -}}
{{- $searchDomains := list $rootSearchDomain $clusterRootDomain $defaultClusterSearchDomain  -}}
{{- $domains1 := dict "domains" (list) -}}
{{- $domains2 := dict "domains" (list) -}}
{{- $domains3 := dict "domains" (list) -}}
{{- range $indexCore, $rootDomain := $searchDomains -}}
{{- $domainList := splitList "." $rootDomain -}}
{{- $bits := printf "" -}}
{{- range $index, $domain := $domainList -}}
{{- if eq $indexCore 0 -}}
{{- $bits := printf ".%s%s" $domain $bits -}}
{{- $var := printf "%s" $bits | append $domains1.domains | set $domains1 "domains" -}}
{{- $domains1 | toRawJson -}}.,
{{- else if eq $indexCore 1 -}}
{{- $bits := printf ".%s%s" $domain $bits -}}
{{- $var := printf "%s" $bits | append $domains2.domains | set $domains2 "domains" -}}
{{- $domains2 | toRawJson -}}.,
{{- else if eq $indexCore 2 -}}
{{- $bits := printf ".%s%s" $domain $bits -}}
{{- $var := printf "%s" $bits | append $domains3.domains | set $domains3 "domains" -}}
{{- $domains3 | toRawJson -}}.,
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}