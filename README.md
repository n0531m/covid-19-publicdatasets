# covid-19-publicdatasets

there is a public dataset [COVID-19 Public Dataset Program](https://console.cloud.google.com/marketplace/details/bigquery-public-datasets/covid19-public-data-program) by Google as in this [blog post](https://cloud.google.com/blog/products/data-analytics/free-public-datasets-for-covid19)

If you look at the dataset in detail, you will notice that values for fields such as Country, State/Province name fluctuates quite a bit. This is understandable due to the nature of the data, but sometimes inconvenient if you just want cleaner data, without having to do that your self.
This repo includes some snippets that can be applied to clean up some of it's data, 

The source being in Google BigQuery, wrote these as BigQuery related resources

# Made available
These are living in my own project and made accessible as long as you have a authenticated Google account. 
* `moritani-opendata`.covid19.normalizeLocationLabels : UDF that is hosted my project that take two parameters `country_region` and `province_state` and returns a struct with the refined values.
* `moritani-opendata.covid19.jhu_csse_summary_daily_latest` : a table with daily summary. Made public so anyone should be able to just query it.

# Making your own
In case you want to replicate the same to your own project (maybe for some tweaks), below can be used. 
* [udf_normalizeLocationLabels.sql](udf_normalizeLocationLabels.sql) : This sql creates or updates the function above. Replace `moritani-opendata` and `covid19` with your respective GCP Project ID and BigQuery Dataset name to create in your own environment. 
* [update_bq_udf.sh](update_bq_udf.sh) : shell script to run the sql above and create a persistent udf via Cloud SDK 
* [sql_daily_summary.sql](sql_daily_summary.sql) : a sql that utilized the UDF above and create a daily summary table. Can be used to create a view, but also can be scheduled to materilize. 
* [update_bq_scheduled_summary_query.sh](update_bq_scheduled_summary_query.sh) : a shell script to setup a scheduled query that will run the sql above at a set interval (set to an hour), and store results in the given destination. 


## Disclaimer
Country names can be sometimes polical and tricky and complex to have a uniform agreement on. Whatever chosen here has no intension to be on any side, but rather focus on standardizing the field values where it should be. With that, it should be easy to switch it to whatever appropriate for the context of the use case. thanks you for your understanding. 

