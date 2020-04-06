#!/bin/bash -v

PROJECT_ID=moritani-opendata
BQ_DATASET=covid19
BQ_TABLE=jhu_csse_summary_daily_latest

bq --project_id ${PROJECT_ID} show ${BQ_DATASET} || bq --project_id ${PROJECT_ID} mk ${BQ_DATASET}

cat sql_daily_summary.sql |  bq --project_id=$PROJECT_ID query \
--display_name="COVID-19 Latest Summary - Hourly Refresh" \
--destination_table=${BQ_DATASET}.${BQ_TABLE} \
--schedule="every 1 hours" \
--replace=true \
--nouse_legacy_sql

bq ls --transfer_config --transfer_location US


