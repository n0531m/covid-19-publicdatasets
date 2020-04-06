#StandardSQL
WITH t1 AS (
  SELECT
    *,
    `moritani-opendata`.covid19.normalizeLocationLabels(country_region, province_state) AS normalized,
    ST_GEOHASH(
      ST_GEOGPOINT(longitude, latitude),
      4
    ) AS geohash
  FROM
    `bigquery-public-data.covid19_jhu_csse.summary`
  WHERE
    date IN (
      SELECT
        date
      FROM
        `bigquery-public-data.covid19_jhu_csse.summary`
      GROUP BY
        date
      ORDER BY
        date DESC
      LIMIT
        1
    )
), t2 AS (
  SELECT
    *
  EXCEPT
    (
      country_region,
      province_state,
      normalized
    ),
    normalized.country_region AS country_region,
    normalized.province_state AS province_state,
  FROM
    t1
  ORDER BY
    date DESC,
    geohash,
    country_region,
    province_state
    -- , admin2
)
SELECT
  date,
  country_region,
  province_state,
  -- admin2,
  -- combined_key,
  SUM(confirmed) AS confirmed,
  SUM(deaths) AS deaths,
  SUM(recovered) AS recovered,
  SUM(active) AS active
FROM
  t2
GROUP BY
  date,
  country_region,
  province_state 
  -- , admin2
  -- , combined_key
ORDER BY
  deaths desc