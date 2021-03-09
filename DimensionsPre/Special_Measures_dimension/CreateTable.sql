--DROP TABLE Special_Measures_dimension;


create table Special_Measures_dimension(
surrogate_key int,
Reporting_PHU varchar,
Reporting_PHU_id int,
Title varchar,
Description varchar,
Keyword_1 varchar,
Keyword_2 varchar,
StartDate varchar,
EndDate varchar,
primary key (surrogate_key)
);

\COPY Special_Measures_dimension FROM '/Users/yi/Desktop/DS_Phase2/DimensionsPre/Special_Measures_dimension/Special_Measures_dimension.csv' DELIMITER ',' CSV HEADER;
