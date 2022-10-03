-- How many rows have been loaded in the Country staging table?
SELECT count([Country Code]) AS TOTAL_FILAS
FROM [WWBI_STG].[dbo].[STG_COUNTRY]

-- How many rows have been loaded into the staging Data table?
SELECT count([Country Name]) AS TOTAL_FILAS
FROM [WWBI_STG].[dbo].[STG_DATA]