#!/bin/bash

PROJECT_ID=moritani-opendata

bq query --project_id $PROJECT_ID --nouse_legacy_sql --format json  < sql_test_udf.sql | jq

