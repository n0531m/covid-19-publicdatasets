#!/bin/bash -v

PROJECT_ID=moritani-opendata

cat udf_normalizeLocationLabels.sql \
  | bq --project_id $PROJECT_ID query --nouse_legacy_sql
