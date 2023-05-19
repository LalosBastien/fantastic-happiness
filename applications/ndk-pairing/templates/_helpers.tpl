{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ndk-pairing.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ndk-pairing.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ndk-pairing.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "ndk-pairing.serviceAccountName" -}}
{{- if .Values.rbac.create }}
{{- default (include "ndk-pairing.fullname" .) .Values.rbac.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.rbac.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for podsecuritypolicy.
*/}}
{{- define "ndk-pairing.podSecurityPolicy.apiVersion" -}}
{{- if semverCompare ">=1.3-0, <1.10-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "^1.10-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "ndk-pairing.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "ndk-pairing.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
