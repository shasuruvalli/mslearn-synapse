CREATE DATABASE lakedb;
GO

USE lakedb;
GO

CREATE VIEW products_csv
AS
SELECT *
FROM
    OPENROWSET(
        BULK 'https://datalakexxxxxxx.dfs.core.windows.net/files/products/products.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    ) AS [result]
