
Select count(distinct Location) from MCases
Select count(distinct Location) from MFirstDose
Select count(distinct Location) from MFullDose 

Select Top 5 * from MCases

--Rename Indicator Value and Period Column
EXEC sp_rename 'MFullDose.Value',  'MCV2', 'COLUMN';
EXEC sp_rename 'MFirstDose.Value',  'MCV1', 'COLUMN';
EXEC sp_rename 'MCases.Value',  'Cases', 'COLUMN';
EXEC sp_rename 'MFullDose.Period',  'Year', 'COLUMN';
EXEC sp_rename 'MFirstDose.Period',  'Year', 'COLUMN';
EXEC sp_rename 'MCases.Period',  'Year', 'COLUMN';

--Drop columns not needed
ALTER TABLE MCases
DROP COLUMN  ValueType, ParentLocationCode, SpatialDimValueCode, Location_type, Period_type, IsLatestYear, Dim1, Dim1_type, Dim1ValueCode, Dim2, Dim2_type, Dim2ValueCode, 
Dim3_type, Dim3, Dim3ValueCode, DataSourceDimValueCode, DataSource, FactValueNumericPrefix, FactValueUoM, FactValueNumericLowPrefix, FactValueNumericLow, 
FactValueNumericHighPrefix, FactValueNumericHigh, FactValueTranslationID,FactComments, DateModified, FactValueNumeric, IndicatorCode, Indicator, Language ;

Select Top 5 * from MCases

ALTER TABLE MFirstDose
DROP COLUMN  ValueType, ParentLocationCode, SpatialDimValueCode, Location_type, Period_type, IsLatestYear, Dim1, Dim1_type, Dim1ValueCode, Dim2, Dim2_type, Dim2ValueCode, 
Dim3_type, Dim3, Dim3ValueCode, DataSourceDimValueCode, DataSource, FactValueNumericPrefix, FactValueUoM, FactValueNumericLowPrefix, FactValueNumericLow, 
FactValueNumericHighPrefix, FactValueNumericHigh, FactValueTranslationID,FactComments, DateModified, FactValueNumeric, IndicatorCode, Indicator, Language ;

Select Top 5 * from MFirstDose

ALTER TABLE MFullDose
DROP COLUMN  ValueType, ParentLocationCode, SpatialDimValueCode, Location_type, Period_type, IsLatestYear, Dim1, Dim1_type, Dim1ValueCode, Dim2, Dim2_type, Dim2ValueCode, 
Dim3_type, Dim3, Dim3ValueCode, DataSourceDimValueCode, DataSource, FactValueNumericPrefix, FactValueUoM, FactValueNumericLowPrefix, FactValueNumericLow, 
FactValueNumericHighPrefix, FactValueNumericHigh, FactValueTranslationID,FactComments, DateModified, FactValueNumeric, IndicatorCode, Indicator, Language ;


Select Top 5 * from MFullDose

--Explore Data
Select Location, max(Cases) as MaxCases from MCases Group by Location
Select Year, AVG(Cases) as AvgYearly from MCases Group by YEAR Order by AvgYearly desc

--Create addtl column for joins (Year plus country)
alter table MCases add NewIndex as CONCAT(CAST(Year AS varchar), Location);
alter table MFirstDose add NewIndex as CONCAT(CAST(Year AS varchar), Location);
alter table MFullDose add NewIndex as CONCAT(CAST(Year AS varchar), Location);

--Identify missing Fields in MFullDose
SELECT Location, MCases.NewIndex FROM MCases Group by Location, MCases.NewIndex
Having NewIndex NOT IN (SELECT NewIndex FROM MFullDose WHERE MCases.NewIndex = MFullDose.NewIndex)


--Create views for visualization
Create View MFirstDose2 as 
Select NewIndex, MCV1 from MFirstDose
Create View MFullDose2 as 
Select NewIndex, MCV2 from MFullDose

--Delete years from MCases that are not in other tables
DELETE FROM MCases WHERE Year between 1974 and 1999
Select Count(*) from MCases







