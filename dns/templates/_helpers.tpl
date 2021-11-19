{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dns.name" -}}
{{- .Values.appName -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dns.fullname" -}}
{{- .Values.appName -}}
{{- end -}}

{{- define "dns.ingress-component-postfix" -}}
{{- if .Values.postfix }}
{{- .Values.postfix }}{{- printf "." -}}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{- define "dns.full-end-url" -}}
{{- include "dns.ingress-component-postfix" . -}}{{- .Values.environment -}}.{{- .Values.mainDnsDomain -}}
{{- end }}

{{- define "dns.http-full-url" -}}
{{- include "dns.fullname" . -}}.{{- include "dns.full-end-url" . -}}
{{- end }}

{{- define "dns.http-seviceName" -}}
{{ include "dns.fullname" .  }}
{{- end }}

{{- define "dns.http-ssl-secret" -}}
 {{ regexReplaceAll "\\W+" (include "dns.http-full-url" .) "-" }}
{{- end }}

