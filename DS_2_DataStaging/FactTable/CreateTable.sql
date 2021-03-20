
--DROP TABLE Covid19_Tracking_Fact_Table;


create table Covid19_Tracking_Fact_Table(
Id int,
Onset_date_key int,
Reported_date_key int,
Test_date_key int,
Specimen_date_key int,
Patient_key int,
PHU_location_key int,
Special_measure_key int,
Mobility_key int,
Weather_key int,
Resolved int,
Unresolved int,
Fatal int,
foreign key  (Onset_date_key) references Date_dimension(surrogate_key),
foreign key  (Reported_date_key) references Date_dimension(surrogate_key),
foreign key  (Test_date_key) references Date_dimension(surrogate_key),
foreign key  (Specimen_date_key) references Date_dimension(surrogate_key),
foreign key  (Patient_key) references Patient_dimension(surrogate_key),
foreign key  (PHU_location_key) references PHU_Location_dimension(surrogate_key),
foreign key  (Special_measure_key)  references Special_Measures_dimension(surrogate_key),
foreign key  (Mobility_key) references Mobility_dimension(surrogate_key),
foreign key  (Weather_key) references Weather_dimension(surrogate_key)
);

\COPY Covid19_Tracking_Fact_Table FROM '/Users/yi/Desktop/DS_Project/DS_2_DataStaging/FactTable/Covid19_Tracking_Fact_Table.csv' DELIMITER ',' CSV HEADER;
