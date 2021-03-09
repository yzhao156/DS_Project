
--DROP TABLE Weather_dimension;


create table Weather_dimension(
surrogate_key int,
LongitudeX float,
LatitudeY float,
StationName varchar,
ClimateID varchar,
DateTime varchar,
Year float,
Month float,
Day float,
MaxTempInC float,
MinTempInC float,
MeanTempInC float,
HeatDegDaysInC float,
CoolDegDaysInC float,
TotalRainInmm float,
TotalRainFlag varchar,
TotalSnowIncm float,
TotalSnowFlag varchar,
TotalPrecipInmm float,
SnowonGrndIncm float,
SnowonGrndFlag varchar,
primary key (surrogate_key)
);

\COPY Weather_dimension FROM '/Users/yi/Desktop/DS_Phase2/DimensionsPre/Weather_dimension/Weather_dimension.csv' DELIMITER ',' CSV HEADER;
