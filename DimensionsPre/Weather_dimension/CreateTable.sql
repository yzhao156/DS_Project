
--DROP TABLE Weather_dimension;


create table Weather_dimension(
surrogate_key int,
Longitude (x) int,
Latitude (y) int,
Station Name varchar,
Climate ID int,
Date/Time varchar,
Year int,
Month int,
Day int,
Max Temp (°C) int,
Min Temp (°C) int,
Mean Temp (°C) int,
Heat Deg Days (°C) int,
Cool Deg Days (°C) int,
Total Rain (mm) int,
Total Rain Flag varchar,
Total Snow (cm) int,
Total Snow Flag varchar,
Total Precip (mm) int,
Snow on Grnd (cm) int,
Snow on Grnd Flag varchar,
primary key (surrogate_key)
)

\COPY Date_dimension FROM '/Users/yi/Desktop/DS_Phase2/DimensionsPre/Weather_dimension/Weather_dimension.csv' DELIMITER ',' CSV HEADER;
