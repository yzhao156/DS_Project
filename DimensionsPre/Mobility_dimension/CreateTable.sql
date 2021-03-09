--DROP TABLE Mobility_dimension;


create table Mobility_dimension(
surrogate_key int,
country_region_code varchar,
country_region varchar,
sub_region_1 varchar,
sub_region_2 varchar,
place_id varchar,
date varchar,
retail_and_recreation_percent_change_from_baseline int,
grocery_and_pharmacy_percent_change_from_baseline int,
parks_percent_change_from_baseline int,
transit_stations_percent_change_from_baseline int,
workplaces_percent_change_from_baseline int,
residential_percent_change_from_baseline int,
primary key (surrogate_key)
)

\COPY Date_dimension FROM '/Users/yi/Desktop/DS_Phase2/DimensionsPre/Mobility_dimension/Mobility_dimension.csv' DELIMITER ',' CSV HEADER;
