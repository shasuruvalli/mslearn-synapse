SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE weather_forecast (
	[season] bigint,
	[mnth] bigint,
	[holiday] bigint,
	[weekday] bigint,
	[workingday] bigint,
	[weathersit] bigint,
	[temp] real,
	[atemp] real,
	[hum] real,
	[windspeed] real
	);
GO

COPY INTO dbo.weather_forecast
    (season, mnth, holiday, weekday, workingday, weathersit, temp, atemp, hum, windspeed)
FROM 'https://datalakexxxxxxx.dfs.core.windows.net/files/data/weather-forecast.csv'
WITH(
    FIRSTROW=2,
    CREDENTIAL = (IDENTITY='Managed Identity')
);
GO
