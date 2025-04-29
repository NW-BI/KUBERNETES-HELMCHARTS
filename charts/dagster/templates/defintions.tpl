{{- define "dagster-service-name" -}}
  {{- printf "%s-dagster-webserver" .Release.Name -}}
{{- end -}}

{{- define "dagster-service-port" -}}
  {{- printf "8080" -}}
{{- end -}}


