{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "demoapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "demoapp.fullname" -}}
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
{{- define "demoapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Shorthand for component names
*/}}
{{- define "demoapp.mysql.name" -}}
{{- include "demoapp.fullname" . -}}-mysql
{{- end -}}
{{- define "demoapp.redis.name" -}}
{{- include "demoapp.fullname" . -}}-redis
{{- end -}}
{{- define "demoapp.puma.name" -}}
{{- include "demoapp.fullname" . -}}-puma
{{- end -}}
{{- define "demoapp.sidekiq.name" -}}
{{- include "demoapp.fullname" . -}}-sidekiq
{{- end -}}
{{- define "demoapp.rails-env.name" -}}
{{- include "demoapp.fullname" . -}}-rails-env
{{- end -}}
{{- define "demoapp.mysql-env.name" -}}
{{- include "demoapp.fullname" . -}}-mysql-env
{{- end -}}
{{- define "demoapp.setup-db.name" -}}
{{- include "demoapp.fullname" . -}}-setup-db
{{- end -}}
