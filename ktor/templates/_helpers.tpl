{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ktor.name" -}}
{{- .Values.appName -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ktor.fullname" -}}
{{- .Values.appName -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ktor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "ktor.labels" -}}
app.kubernetes.io/name: {{ include "ktor.name" . }}
helm.sh/chart: {{ include "ktor.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{- define "ktor.image" -}}
{{- if .Values.skaffoldEnabled }}
{{- .Values.image.repository }}
{{- else }}
{{- .Values.image.repository }}:{{- .Values.image.tag }}
{{- end }}
{{- end }}

{{- define "ktor.ingress-namesapce-label" -}}
{{- if .Values.ingress.isNamespaced }}
{{- printf "-" }}{{- replace "apps-" "" .Values.namespace  }}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "ktor.ingress-namesapce-prefix" -}}
{{- if .Values.ingress.isNamespaced }}
{{- replace "apps-" "" .Values.namespace  }}{{- printf "." -}}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "ktor.ingress-component-http-prefix" -}}
{{- if .Values.ingress.http.prefix }}
{{- .Values.ingress.http.prefix }}{{- printf "." -}}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "ktor.ingress-component-grpc-prefix" -}}
{{- if .Values.ingress.grpc.prefix }}
{{- .Values.ingress.grpc.prefix }}{{- printf "." -}}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "ktor.full-end-url" -}}
{{- include "ktor.ingress-namesapce-prefix" . -}}{{ .Values.environment -}}.{{- .Values.mainDnsDomain }}
{{- end }}

{{- define "ktor.http-full-url" -}}
{{- printf "http" -}}.{{- include "ktor.fullname" . -}}.{{include "ktor.ingress-component-http-prefix" .}}{{- include "ktor.full-end-url" . -}}
{{- end }}

{{- define "ktor.grpc-full-url" -}}
{{- printf "grpc" -}}.{{- include "ktor.fullname" . -}}.{{include "ktor.ingress-component-grpc-prefix" .}}{{- include "ktor.full-end-url" . -}}
{{- end }}


{{- define "ktor.http-url" -}}
{{- if .Values.ingress.http.nameOverride}}
{{- .Values.ingress.http.nameOverride -}}.{{- include "ktor.full-end-url" . -}}
{{- else }}
{{- include "ktor.http-full-url" . -}}
{{- end }}
{{- end }}

{{- define "ktor.grpc-url" -}}
{{- if .Values.ingress.grpc.nameOverride}}
{{- .Values.ingress.grpc.nameOverride -}}.{{- include "ktor.full-end-url" . -}}
{{- else }}
{{- printf "%s.%s.%s" "grpc" .Values.ingress.grpc.prefix (include "ktor.full-end-url" .) -}}
{{- end }}
{{- end }}


{{- define "ktor.grpc-seviceName" -}}
 grpc-{{ include "ktor.fullname" .  }}{{ include "ktor.ingress-namesapce-label" .  }}
{{- end }}

{{- define "ktor.http-seviceName" -}}
 http-{{ include "ktor.fullname" .  }}{{ include "ktor.ingress-namesapce-label" .  }}
{{- end }}

{{- define "ktor.http-ssl-secret" -}}
 {{ regexReplaceAll "\\W+" (include "ktor.http-url" .) "-" -}}
{{- end }}

{{- define "ktor.grpc-ssl-secret" -}}
 {{ regexReplaceAll "\\W+" (include "ktor.grpc-url" .) "-" -}}
{{- end }}


{{- define "ktor.proto-prefix" -}}
{{-   regexReplaceAll "\\-" (include "ktor.fullname" .) "" -}}
{{- end -}}

{{- define "ktor.proto-service" -}}
{{-  regexReplaceAll "-service" (include "ktor.fullname" .)  "" | camelcase | title | printf "%sProtoService" -}}
{{- end -}}


{{- define "ktor.proto-default-full-path" -}}
{{- printf "%s.%s" (include "ktor.proto-default-path" .)    (include "ktor.proto-service" .) -}}
{{- end -}}

{{- define "ktor.proto-default-path" -}}
{{- if .Values.ingress.grpc.exposition.pathOverride}}
{{- .Values.ingress.grpc.exposition.pathOverride -}}
{{- else }}
{{- printf "%s.%s" .Values.protoPackage  (include "ktor.proto-prefix" .) -}}
{{- end }}
{{- end -}}


{{- define "ktor.cert-issuer" -}}
{{- if .Values.certificateIssuer }}
{{- .Values.certificateIssuer -}}
{{- else }}
{{- printf "letsencrypt-cluster-prod" -}}
{{- end }}
{{- end }}
