--DROP TABLE PHU_Location_dimension;


create table PHU_Location_dimension(
surrogate_key int,
Reporting_PHU_ID int,
Reporting_PHU varchar,
Reporting_PHU_Address varchar,
Reporting_PHU_City varchar,
Reporting_PHU_Postal_Code varchar,
Reporting_PHU_Website varchar,
Reporting_PHU_Latitude float,
Reporting_PHU_Longitude float,
primary key (surrogate_key)
);



\COPY PHU_Location_dimension FROM '/Users/yi/Desktop/DS_Project/DS_2_DataStaging/DimensionsPre/PHU_Location_dimension/PHU_Location_dimension.csv' DELIMITER ',' CSV HEADER;
