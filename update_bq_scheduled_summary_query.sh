#!/bin/bash -v

PROJECT_ID=moritani-opendata

cat sql_daily_summary.sql |  bq --project_id=$PROJECT_ID query \
--display_name="COVID-19 Latest Summary - Hourly Refresh" \
--destination_table=covid19.jhu_csse_summary \
--schedule="every 1 hours" \
--replace=true \
--nouse_legacy_sql
