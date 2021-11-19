{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "spring-boot.name" -}}
{{- .Values.appName -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spring-boot.fullname" -}}
{{- .Values.appName -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spring-boot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "spring-boot.labels" -}}
app.kubernetes.io/name: {{ include "spring-boot.name" . }}
helm.sh/chart: {{ include "spring-boot.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{- define "spring-boot.image" -}}
{{- if .Values.skaffoldEnabled }}
{{- .Values.image.repository }}
{{- else }}
{{- .Values.image.repository }}:{{- .Values.image.tag }}
{{- end }}
{{- end }}

{{- define "spring-boot.ingress-namesapce-label" -}}
{{- if .Values.ingress.isNamespaced }}
{{- printf "-" }}{{- .Values.namespace }}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "spring-boot.ingress-namesapce-postfix" -}}
{{- if .Values.ingress.isNamespaced }}
{{- .Values.namespace }}{{- printf "." -}}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "spring-boot.ingress-component-postfix" -}}
{{- if .Values.ingress.postfix }}
{{- .Values.ingress.postfix }}{{- printf "." -}}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "spring-boot.full-end-url" -}}
{{- include "spring-boot.ingress-component-postfix" . -}}{{- include "spring-boot.ingress-namesapce-postfix" . -}}{{ .Values.environment -}}.{{- .Values.mainDnsDomain }}
{{- end }}

{{- define "spring-boot.http-full-url" -}}
{{- printf "http" -}}.{{- include "spring-boot.fullname" . -}}.{{- include "spring-boot.full-end-url" . -}}
{{- end }}

{{- define "spring-boot.grpc-full-url" -}}
{{- printf "grpc" -}}.{{- include "spring-boot.fullname" . -}}.{{- include "spring-boot.full-end-url" . -}}
{{- end }}


{{- define "spring-boot.http-url" -}}
{{- if .Values.ingress.http.nameOverride}}
{{- .Values.ingress.http.nameOverride -}}.{{- include "spring-boot.full-end-url" . -}}
{{- else }}
{{- include "spring-boot.http-full-url" . -}}
{{- end }}
{{- end }}

{{- define "spring-boot.grpc-url" -}}
{{- if .Values.ingress.grpc.nameOverride}}
{{- .Values.ingress.grpc.nameOverride -}}{{- include "spring-boot.full-end-url" . -}}
{{- else }}
{{- include "spring-boot.grpc-full-url" . -}}
{{- end }}
{{- end }}


{{- define "spring-boot.grpc-seviceName" -}}
 grpc-{{ include "spring-boot.fullname" .  }}{{ include "spring-boot.ingress-namesapce-label" .  }}
{{- end }}

{{- define "spring-boot.http-seviceName" -}}
 http-{{ include "spring-boot.fullname" .  }}{{ include "spring-boot.ingress-namesapce-label" .  }}
{{- end }}

{{- define "spring-boot.http-ssl-secret" -}}
 {{ regexReplaceAll "\\W+" (include "spring-boot.http-url" .) "-" }}
{{- end }}

{{- define "spring-boot.grpc-ssl-secret" -}}
 {{ regexReplaceAll "\\W+" (include "spring-boot.grpc-url" .) "-" }}
{{- end }}
