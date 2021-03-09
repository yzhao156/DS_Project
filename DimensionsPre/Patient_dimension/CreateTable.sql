--DROP TABLE Patient_dimension;


create table Patient_dimension(
surrogate_key int,
Age_Group varchar,
Client_Gender varchar,
Case_AcquisitionInfo varchar,
Outbreak_Related varchar,
primary key (surrogate_key)
);



\COPY Patient_dimension FROM '/Users/yi/Desktop/DS_Phase2/DimensionsPre/Patient_dimension/Patient_dimension.csv' DELIMITER ',' CSV HEADER;
