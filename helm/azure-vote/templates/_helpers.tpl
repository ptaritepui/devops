{{/*
Expand the name of the chart.
*/}}
{{- define "azure-vote.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "azure-vote.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "azure-vote.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create unified labels for prometheus components
*/}}
{{- define "azure-vote.common.matchLabels" -}}
app: {{ template "azure-vote.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "azure-vote.common.metaLabels" -}}
chart: {{ template "azure-vote.chart" . }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "azure-vote.azure_vote_front.labels" -}}
{{ include "azure-vote.azure_vote_front.matchLabels" . }}
{{ include "azure-vote.common.metaLabels" . }}
{{- end -}}

{{- define "azure-vote.azure_vote_front.matchLabels" -}}
component: {{ .Values.azure_vote_front.name | quote }}
{{ include "azure-vote.common.matchLabels" . }}
{{- end -}}

{{- define "azure-vote.azure_vote_back.labels" -}}
{{ include "azure-vote.azure_vote_back.matchLabels" . }}
{{ include "azure-vote.common.metaLabels" . }}
{{- end -}}

{{- define "azure-vote.azure_vote_back.matchLabels" -}}
component: {{ .Values.azure_vote_back.name | quote }}
{{ include "azure-vote.common.matchLabels" . }}
{{- end -}}



{{/*
Selector labels
*/}}
{{- define "azure-vote.selectorLabels" -}}
app.kubernetes.io/name: {{ include "azure-vote.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "azure-vote.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "azure-vote.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a fully qualified azure-vote-front name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "azure-vote.azure_vote_front.fullname" -}}
{{- if .Values.azure_vote_front.fullnameOverride -}}
{{- .Values.azure_vote_front.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.azure_vote_front.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.azure_vote_front.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified azure-vote-back name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "azure-vote.azure_vote_back.fullname" -}}
{{- if .Values.azure_vote_back.fullnameOverride -}}
{{- .Values.azure_vote_back.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.azure_vote_back.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.azure_vote_back.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

