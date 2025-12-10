{{/*
Expand the name of the chart.
*/}}
{{- define "musiceventfinder.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "musiceventfinder.fullname" -}}
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
{{- define "musiceventfinder.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "musiceventfinder.labels" -}}
helm.sh/chart: {{ include "musiceventfinder.chart" . }}
{{ include "musiceventfinder.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "musiceventfinder.selectorLabels" -}}
app.kubernetes.io/name: {{ include "musiceventfinder.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
API specific labels
*/}}
{{- define "musiceventfinder.api.labels" -}}
{{ include "musiceventfinder.labels" . }}
app.kubernetes.io/component: api
{{- end }}

{{/*
API selector labels
*/}}
{{- define "musiceventfinder.api.selectorLabels" -}}
{{ include "musiceventfinder.selectorLabels" . }}
app.kubernetes.io/component: api
{{- end }}

{{/*
Database specific labels
*/}}
{{- define "musiceventfinder.db.labels" -}}
{{ include "musiceventfinder.labels" . }}
app.kubernetes.io/component: database
{{- end }}

{{/*
Database selector labels
*/}}
{{- define "musiceventfinder.db.selectorLabels" -}}
{{ include "musiceventfinder.selectorLabels" . }}
app.kubernetes.io/component: database
{{- end }}