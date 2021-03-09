--DROP TABLE Special_Measures_dimension;


create table Special_Measures_dimension(
ssurrogate_key int,
Reporting_PHU varchar,
Reporting_PHU_id int,
Title varchar,
Description varchar,
Keyword_1 varchar,
Keyword_2 varchar,
Start-date varchar,
End-date varchar,
primary key (surrogate_key)
)

\COPY Date_dimension FROM '/Users/yi/Desktop/DS_Phase2/DimensionsPre/Special_Measures_dimension/Special_Measures_dimension.csv' DELIMITER ',' CSV HEADER;
