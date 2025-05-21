{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fastapi.name" -}}
{{- .Values.appName -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fastapi.fullname" -}}
{{- .Values.appName -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fastapi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "fastapi.labels" -}}
app.kubernetes.io/name: {{ include "fastapi.name" . }}
helm.sh/chart: {{ include "fastapi.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Define image reference
*/}}
{{- define "fastapi.image" -}}
{{- if .Values.skaffoldEnabled }}
{{- .Values.image.repository }}
{{- else }}
{{- .Values.image.repository }}:{{- .Values.image.tag }}
{{- end }}
{{- end }}