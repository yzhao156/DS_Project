DROP TABLE Date_dimension;

create table Date_dimension(
surrogate_key int,
sasdate int,
date_key int,
word_date varchar,
date date,
year int,
quarter int,
month int,
day_of_month int,
week int,
day_of_week varchar,
weekday int,
month_and_year varchar,
holiday varchar,
timezone_id varchar,
timezone varchar,
timezone_offset int,
primary key (surrogate_key)
);

\COPY Date_dimension FROM '/Users/yi/Desktop/DS_Phase2/DimensionsPre/Date_dimension/Date_dimension.csv' DELIMITER ',' CSV HEADER;

