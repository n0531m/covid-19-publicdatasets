#DECLARE
#  PRECISION INT64 DEFAULT 6;
DECLARE PRECISION_GEOHASH INT64 DEFAULT 4;

WITH -- first table : only aggregating the rows with exact match on     country_region, province_state, longitude, latitude
-- also rounding lat/lng  to a set precision. (defined in declard param)
-- also adding a geohash value based point point
t1 AS (
    select
        country_region,
        province_state,
        `moritani-opendata`.covid19.normalizeLocationLabels(country_region, province_state) AS normalized,
        latitude,
        longitude,
        ST_GEOGPOINT(longitude, latitude) AS point,
        ST_GEOHASH(
            ST_GEOGPOINT(longitude, latitude),
            PRECISION_GEOHASH
        ) AS geohash,
        COUNT(*) AS numOfRows
    FROM
        `bigquery-public-data.covid19_jhu_csse.summary`
    GROUP BY
        country_region,
        province_state,
        longitude,
        latitude
),
-- second table aggregated based on rounded numbers
t2 AS (
    SELECT
        normalized.country_region as country_region,
        normalized.province_state as province_state,
        # lat AS latitude,
        # lng AS longitude,
        latitude,
        longitude,
        ST_ASTEXT(point) AS point,
        geohash,
        SUM(numOfRows) AS numOfRows
    FROM
        t1
    GROUP BY
        country_region,
        province_state,
        latitude,
        longitude,
        geohash,
        ST_ASTEXT(point)
),
t3 AS(
    SELECT
        *
    FROM
        t2
    WHERE
        -- excluding datapoints with missing lat/lng
        geohash IS NOT NULL 
        -- excluding datapoints with latlng of (0,0)
        AND geohash != st_geohash (
            st_geogpoint(0, 0),
            PRECISION_GEOHASH
        )
    ORDER BY
        geohash
),
t4 AS (
    SELECT
        geohash,
        -- ARRAY_AGG( STRUCT( country_region,
        --        province_state)) as  labels
        ARRAY_AGG(
            DISTINCT CONCAT(
                IF (
                    country_region IS NULL,
                    "[null]",
                    country_region
                ),
                --
                " || ",
                IF (
                    province_state IS NULL,
                    "[null]",
                    province_state
                )
            )
        ) AS labels 
        --  ORDER BY
        --  country_region, province_state) AS labels
,
        sum(numOfRows) as numOfRows
    FROM
        t3
    GROUP BY
        geohash 
        -- , country_region
        -- , province_state
)
SELECT
    geohash,
    labels,
    numOfRows
FROM
    t4
WHERE
    ARRAY_LENGTH(labels) > 1
order by
    geohash