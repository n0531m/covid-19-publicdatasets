CREATE OR REPLACE FUNCTION
  `moritani-opendata`.covid19.normalizeLocationLabels (country_region string,
    province_state string) AS ((
    SELECT
      STRUCT(
        CASE
          WHEN country_region IN ("South Korea", "Korea, South", "Republic of Korea") THEN "South Korea"
          WHEN country_region IN ("Mainland China") THEN "China"
          WHEN country_region IN ("Vietnam", "Viet Nam") THEN "Vietnam"
          WHEN country_region IN ("Bahamas",
          "Bahamas, The") THEN "Bahamas"
          WHEN country_region IN ("Russia", "Russian Federation") THEN "Russia"
          WHEN country_region IN ("Gambia",
          "The Gambia") THEN "Gambia"
          WHEN country_region IN ("Moldova", "Republic of Moldova") THEN "Moldova"
          WHEN country_region IN ("Gambia",
          "Gambia, The") THEN "Gambia"
          WHEN country_region IN ("Taiwan", "Taiwan*", "Taipei and environs") THEN "Taiwan"
          WHEN country_region IN ("Republic of Ireland",
          "Ireland") THEN "Ireland"
          WHEN country_region IN ("Iran (Islamic Republic of)", "Iran") THEN "Iran"
          WHEN country_region IN ("Czechia",
          "Czech Republic") THEN "Czech Republic"
          WHEN province_state IN ("Hong Kong") THEN "Hong Kong"
          WHEN province_state IN ("Macau") THEN "Macau"
          WHEN country_region IN ("Guam") AND province_state IS NULL THEN "US"
          WHEN country_region IN ("Cayman Islands")
        AND province_state IS NULL THEN "United Kingdom"
          WHEN country_region IN ("Aruba") AND province_state IS NULL THEN "Netherlands"
          WHEN country_region IN ("Curacao")
        AND province_state IS NULL THEN "Netherlands"
          WHEN country_region IN ("Guadeloupe") AND province_state IS NULL THEN "France"
          WHEN country_region IN ("Mayotte")
        AND province_state IS NULL THEN "France"
          WHEN country_region IN ("French Guiana") AND province_state IS NULL THEN "France"
          WHEN country_region IN ("Saint Barthelemy")
        AND province_state IS NULL THEN "France"
          WHEN country_region IN ("Gibraltar") AND province_state IS NULL THEN "United Kingdom"
          WHEN country_region IN ("US")
        AND province_state IN ("Puerto Rico") THEN "Puerto Rico"
        ELSE
        TRIM(country_region)
      END
        AS country_region,
        CASE
          WHEN country_region = province_state THEN NULL
          WHEN country_region IN ("US")
        AND province_state IN ("Virgin Islands",
          "Virgin Islands, U.S.",
          "United States Virgin Islands") THEN "Virgin Islands"
          WHEN country_region IN ("US") AND province_state IN ("Santa Clara, CA", "Santa Clara County, CA") THEN "Santa Clara Country, CA"
          WHEN country_region IN ("US")
        AND province_state IN ("Orange, CA",
          "Orange County, CA") THEN "Orange Country, CA"
          WHEN province_state IN ("Fench Guiana") THEN "French Guiana"
          WHEN country_region IN ("Guam")
        AND province_state IS NULL THEN "Guam"
          WHEN country_region IN ("Cayman Islands") AND province_state IS NULL THEN "Cayman Islands"
          WHEN country_region IN ("Aruba")
        AND province_state IS NULL THEN "Aruba"
          WHEN country_region IN ("Curacao") AND province_state IS NULL THEN "Curacao"
          WHEN country_region IN ("Guadeloupe")
        AND province_state IS NULL THEN "Guadeloupe"
          WHEN country_region IN ("Mayotte") AND province_state IS NULL THEN "Mayotte"
          WHEN country_region IN ("French Guiana")
        AND province_state IS NULL THEN "French Guiana"
          WHEN country_region IN ("US") AND province_state IN ("Puerto Rico") THEN NULL
          WHEN country_region IN ("Saint Barthelemy")
        AND province_state IS NULL THEN "Saint Barthelemy"
          WHEN country_region IN ("Gibraltar") AND province_state IS NULL THEN "Gibraltar"
          WHEN country_region IN ("United Kingdom")
        AND province_state IN ("UK") THEN NULL
          WHEN province_state IN ("Hong Kong") THEN NULL
          WHEN province_state IN ("Macau") THEN NULL
          WHEN province_state IN ("Taiwan") THEN NULL
        ELSE
        TRIM(province_state)
      END
        AS province_state) AS result ));
