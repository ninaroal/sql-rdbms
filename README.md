# __CREATION OF A BUSINESS INTELLIGENCE SYSTEM__

**1. What data will be used?**

This dataset is based on World Bank Group data. Specifically, the set of indicators on global bureaucracy will be used. We have two CSV files, one called “WWBIData” that contains the country names and codes, indicator names and codes, as well as the values of the indicators by year, starting with the year 2000 up to the year 2016. Then there is the file “WWBICountry”, which contains more detailed information on countries, regions, 2-alpha-code, income group, among others.
These files are updated to the year 2016, however, the most recent data can be found on the World Bank Group website, since they are public datasets (https://www.worldbank.org/en/).
Note: It is important to mention that this dataset has been slightly modified once downloaded from the World Bank Group site, since Pentaho Data Integration (PDI) has a bug that prevents tables with columns from being loaded whose name is numeric. For this reason, an “a” was added to the “WWBIData” file in front of the name of the year columns, passing, for example, from “2020” to “a2020”.

**2. Extraction of the CSV files to a staging database using PDI processes**
The first step in uploading these files to a database in Microsoft SQL Server Management Studio (SSMS) begins with extracting them. This data will be extracted, transformed and loaded into a “raw” database in SSMS called staging. This process described above is also known as "ETL" for its acronym  "extraction, transform, load", which will be orchestrated through the PDI tool, an open source software platform for data integration and analysis.

  **2.1. Create staging database and its tables, attach the table creation script**
As a first step I will create a database for the staging area in SSMS. In this stage the raw data is downloaded. In this simple case, a single database could be created and the tables belonging to the staging could be identified by placing “STG_...” at the beginning to separate them from the tables of the data warehouse itself. However, I have preferred to separate both processes by creating two databases, one for staging called WWBI_STG and another database for the data mart called WWBI_DWH.

**a. Creation of the staging database**
The database was created using the SSMS wizard. In the menu on the left was selected: Database -> New Database

![grafik](https://user-images.githubusercontent.com/84467687/193496292-51b93910-ca49-42f7-938b-2c81b045403c.png)

Then the database name “WWBI_STG” was set:

![grafik](https://user-images.githubusercontent.com/84467687/193496305-ef92e0c3-81ca-4ca2-8a4d-c815276e6d26.png)

**See Script here**
![grafik](https://user-images.githubusercontent.com/84467687/193496340-932821ac-94ba-4ca6-a6c3-3fcdb286b22f.png)

**b. Creation of the staging database tables**
As we mentioned in the first point, we have two files, therefore, two tables have been created as is. One table will represent the “WWBIData.csv” file, which will receive the name “STG_DATA”, and the other table will represent the “WWBICountry.csv” file, which will be called “STG_COUNTRY”.
The WWBI_STG database tables have been created with code through SQL Server. To do this, a window was opened as shown in the following image:
 
 ![grafik](https://user-images.githubusercontent.com/84467687/193496457-a70aeac4-122f-4950-95a0-b76329613f21.png)

**See Script here**
![grafik](https://user-images.githubusercontent.com/84467687/193496483-dfd44f37-ca41-484e-9f6b-1281fe1dbef9.png)
![grafik](https://user-images.githubusercontent.com/84467687/193496490-3d163932-a57e-4cfe-97fc-4c89d409a95f.png)

As noted above, all columns have been formatted with the "VARCHAR" type to avoid future errors, when extracting and loading the data through the data integration platform (in this case PDI, specifically Spoon) . Conversions to the correct data types can be done later in the Data Warehouse. 

**2.2) Answer the following questions regarding the charging processes**
The first thing that is done when starting the ETL process through Spoon is to create a connection to the database, in this case to the “WWBI_STG” database. Select new transformation in the “View” tab. Then in “Database connections” we have selected “New”. After naming the connection, “MS SQL Server (Native)” was selected as the connection type. Once the fields were filled in, we clicked on “Test”:

![grafik](https://user-images.githubusercontent.com/84467687/193496547-34c6820f-6f3e-4bf7-afc2-8b6d8e7bfe91.png)

The same step was repeated with the WWBI_DWH database:

![grafik](https://user-images.githubusercontent.com/84467687/193496558-058b607a-b686-4748-97ed-c78e6d67225d.png)
 
Finally, we click on “share” to create the transformation connection to the DB in SSMS.

![grafik](https://user-images.githubusercontent.com/84467687/193496575-501e29e1-5b46-4b67-9268-8f0cd1a2f3a9.png)

**- How many rows have been loaded in the Country staging table?, and How many rows have been loaded in the data staging table?**
115 rows have been loaded into the staging country table and 10005 rows into the staging data table:      
![grafik](https://user-images.githubusercontent.com/84467687/193496628-eb1796dd-3ede-46b9-afc9-771c497fd05a.png)

**See Script here**
![grafik](https://user-images.githubusercontent.com/84467687/193496754-4d5d8729-1314-4f2b-8166-90eb324c4a7b.png)
![grafik](https://user-images.githubusercontent.com/84467687/193496758-00ba6e8d-d80f-48e9-b6d6-11a40274d1e3.png)

**How many transformations did you use to perform the upload?**
For the staging phase I have carried out a transformation that encompasses two steps. One corresponds to the WWBIData file and the other corresponds to the WWBICountry file.
This could have been done equally well in two transformations in separate .ktr files.

**What objects have you used in these transformations?**
As can be seen in the image below, three objects were used for each table:

a.	Input: CSV file input 
b.	Output: Output Table
c.	Mapping: a mapping step was added to the table output (see second image below) 

![grafik](https://user-images.githubusercontent.com/84467687/193496878-5c66cdb5-62c5-49d7-b6df-b2008586bf22.png)

![grafik](https://user-images.githubusercontent.com/84467687/193496890-30ba419d-868a-4c8e-ad3c-1969ebce2a92.png)

**Have you used the Start component?**
No. The Start component is used only for jobs. The “Start” step is a mandatory component to start the orchestration of the transformations and helps to control possible errors. We will use a job and, therefore, the start step later to join the transformations from the staging process to the upload to the datamart database.

**3) Transformations and loading of data from the staging database to the data warehouse**
After having loaded the raw data in the staging database, we will proceed to create in datamart and the tables in SSMS. And then we will perform the transformation and loading of the staging tables to the dimension tables and fact table to the datamart database.

Starting from the two Data and Country staging tables, which have a large number of columns, we will end up creating three tables. First of all, we will create a fact table that we will call “FACT_WWBI” which will contain the country ID, the metrics ID, the year and the value. In secondly, two-dimension type tables will be created called “DIM_METRICAS” that will contain the ID of the metric and its description, and “DIM_COUNTRY” that will contain the country ID, country name, income group and other additional information.

The datamart diagram would look like this:

![grafik](https://user-images.githubusercontent.com/84467687/193496953-3db2c916-108a-4247-90cc-51d05cec822c.png)

It should be noted that we will have to perform a normalization of columns later, since the staging table STG_DATA contains the years in columns and for better analysis these values are required to be displayed in rows.

**3.1) Create the WWBI datamart and tables, attach table creation scripts**
As with the staging database we will create the database using the SSMS wizard. We will call this database “WWBI_DWH”.

![grafik](https://user-images.githubusercontent.com/84467687/193496974-50c0b0e2-da64-4138-b471-7beb1bc4f1d7.png) 

**See Script here**
![grafik](https://user-images.githubusercontent.com/84467687/193497053-ef060a95-b041-45e6-a55f-1caf92558a73.png)

- Creation of staging database tables
The tables of the WWBI_DWH database have been created in the same way as the staging database with code through SQL Server:

**See Script here**
![grafik](https://user-images.githubusercontent.com/84467687/193497069-3eacdd26-0baa-4b88-8f2f-3f4e5a9b341a.png)
![grafik](https://user-images.githubusercontent.com/84467687/193497079-0a5836eb-16ab-4aa8-9955-4a037b43b587.png)

 
**3.2) Perform the necessary transformations to load the datamart using PDI**
A transformation is first created with the connection to the DB "WWBI_DWH" in SSMS.

![grafik](https://user-images.githubusercontent.com/84467687/193497109-798fa10c-a9b6-4501-9c8d-6f9022485974.png)

3.3) Answer the following questions:
- How was the “dim_metrica” table loaded? Where are you from?
The DIM_METRICA table has been loaded through a "Table Entry", whose origin comes from the staging database, specifically from the STG_DATA table.

 ![grafik](https://user-images.githubusercontent.com/84467687/193497152-449fb0e3-7edf-4a72-bb61-ddf07520b6c6.png)

It is important to note that when the SQL query of the STG_DATA table was obtained, the DISTINC function was added to the SELECT. This prevents repeating measure numbers in the metric dimension table. This will be very important later when establishing relationships between tables, since it will allow a one-to-many cardinality.

![grafik](https://user-images.githubusercontent.com/84467687/193497162-dc749684-8bc7-43ab-8520-21cd41000549.png)

After that, the mapping was generated:

![grafik](https://user-images.githubusercontent.com/84467687/193497182-977d7363-1636-4600-816a-1cfcfd2276e5.png)

The DIM_COUNTRY table was also created starting from an "Input Table" with the same components, whose origin comes from the staging database, specifically from the STG_COUNTRY table.
 
![grafik](https://user-images.githubusercontent.com/84467687/193497192-05db5914-8723-46a9-88f6-66a86e7d4ec8.png)

- What components have been used to create the fact table?
As shown in the graph below, the following objects or components were used:
a. Input: Input Table of the staging database (source table STG_DATA)
b. Transform: Row Normalization
c. Mapping: a mapping step has been added to the table output
d. Output: Output Table (destination table FACT_WWBI)

![grafik](https://user-images.githubusercontent.com/84467687/193497201-1537f4ae-5764-42bb-a4b8-c13fca3fa765.png)
 
To avoid having data series that are not complete, a condition that selects the values that have data from the year 2000 could be additionally added in the Input step to the SQL query. In this case, the table will be left as originally came from.

![grafik](https://user-images.githubusercontent.com/84467687/193497210-e792cd6a-8603-42f5-970e-90c72b31c35e.png)

As mentioned above, we have to perform a normalization on the table and thus pass the years from the columns to the rows. A new column called ID_YEAR has been created where all the years will go and a new field called IN_VALUE which will contain the values of the metrics by year.

![grafik](https://user-images.githubusercontent.com/84467687/193497225-326a4018-489f-40bb-bd92-a1c25d01d3f1.png)

**How many rows have been loaded into the fact table?**
170,085 rows have been loaded into the fact table

**Why have the number of rows in the fact table multiplied?**
The number of rows have multiplied due to the row normalization that we have applied. This process is also known as "pivoting" a table, where the data that is housed in columns is changed to rearrange it in rows. Therefore, fewer columns were obtained, but more rows.

**4) Create the task that allows loading the entire datamart from the origins > staging > datamart**
**Has a transformation or a job been used and why?**
A job or work has been used. Jobs are entities made up of inputs from transformations and/or other jobs linked by jumps. These are useful because they help control possible errors (eg execution after success or failure of a step) and work on the structure of an operating system. It can be said that the jobs orchestrate all the transformations.
In the case of this exercise we will perform a load of the three transformations that we carried out previously and we will also add a message in the Log that indicates the success or failure of our process.

**What kind of objects have been used?**
The following objects have been used:
 
![grafik](https://user-images.githubusercontent.com/84467687/193497281-4565b44a-ffa8-424f-9c73-ad38c8155378.png)

As we can see in the following image we have used:
a. START: Jobs always start with a START object that does not need to be configured. As seen above, the jump has a yellow padlock, which indicates that the jump is an unconditional execution, that is, the destination is executed regardless of the result of the previous entry.
b. Transformation: the three transformations made in the previous steps (staging, dimensions and data mart fact table) were added. For this, the path where the transformations were saved was indicated:

 

c.	Write To Log: we execute an execution jump after success that we have called SUCESS. This step writes a message to the Log. Looking at the first image with the “ETL JOB” note, you can see that there is a green check mark above the jump arrow, which indicates that the destination is executed only if the previous job was successful.
 

d.	Write To Log: Finally, a run jump was applied after the failure that we have called ERROR. This step also writes a message to the Log. The red “X” symbol above the jump arrow indicates that the destination is executed only if the previous job has failed.

 

The objects that we have used to create the job are found in the “General” and “Utility” menus:

 
 

When executing the job we obtain the following log. As you can see, the job was executed successfully and you can read the custom message that was configured in the previous step.

 

5) Answer the following questions by performing SQL queries:
-- How many countries belong to each income group?
Query:
 

Result:
 

-- How many metrics are there, that have non-zero value in the year 2000?
Query:
 
RESULT:
 

6) Create a report in Power BI accessing the information of the newly loaded datamart
- Indicate the structure of the data model. Define the tables, their relationships and cardinalities.
As a first step, we import the data from the SQL Server database into PowerBI. The easiest method to do this is by pressing the “SQL Server” Button on the Start menu.

 

Then we write the server and the name of the database to extract (this last step is optional).
 
Then all the tables in the database will be displayed. We will choose the ones we want to use, which in this case are the two dimension tables and the fact table. Before loading the data, it is recommended to transform it in the event that, for example, a column is added to the table or the data format type of a column is changed. This step is finished by uploading the data to PowerBI.
 
Once the data has been loaded, to view and modify the structure of the data model, select the “Model” button on the left bar.
In the first instance we observe three tables: DIM_METRICA, DIM_COUNTRY and FACT_WWBI. Now relationships will be created between them. To do this, select the button in the start menu, in the Relations section.
This creates the relationship between the DIM_COUNTRY (Primary Key ID_COUNTRY) table and the FACT_WWBI (Foreign Key ID_COUNTRY) table. With a many-to-one cardinality type, since in the country dimension table we have a list of unique countries and in the fact table these values are repeated.
 

Similarly, the second relationship is created between the DIM_METRICAS (Primary Key ID_INDICATOR) table and the FACT_WWBI (Foreign Key ID_INDICATOR) table. As can be seen in the following image, the cardinality is several to one, since in the same way there are unique values of the indicators in the DIM_METRICS table.

 
The data model in PowerBI would be as follows:
 

7) Create the following visualizations, attach comments on why each type of visualization was chosen, as well as screenshots of the charts.
7.1) Evolution over time of “Public sector employment as part of paid employment” and “Public sector employment as part of formal employment” for Argentina
The metrics to be used are the following:
“Public sector employment as a share of paid employment”.
“Public sector employment as a share of formal employment”.

Evolution over time of "Public sector employment as part of paid employment" and "Public sector employment as part of formal employment" for Argentina 

In general, it can be seen that public sector employment in Argentina represents more than 30% of all formal jobs and approximately 20% of all paid jobs. A similar trend is also observed for both indicators. The two peaks between 2001 and 2004, and between 2012 and 2013, are striking.
1.	What type of graph has been used and why?
Line charts are best for plotting time series. Specifically, a stacked area chart was used, which is a variation of line charts, which represent the volume, as well as the time period in which it occurs.
2. What field has been used to filter the data?
DESC_COUNTRY and DESC_INDICATOR
 

3. What field has been used for the axis of the graph?
ID_YEAR

4. And in the legend?
DESC_INDICATOR

5. Which field was used to display the values?
IN_VALUE

7.2) Assess the average age of private and public sector employees by region
The metrics to be used are the following:
“Mean age of private paid employees”.
“Mean age of public paid employees”.



Median age of private and public sector employees by region
 
As can be seen in the graph, with the exception of North America, public sector workers are slightly older on average than private sector workers.
1. What type of graph has been used and why?
A clustered column and line chart has been used. Column charts are often used for discrete or numerical comparison between a set of categories. And the grouped column charts are of great use to compare all the categories, if we add another variable.
In this way we can see in the previous graph, that each of the categories (in this case the regions) are grouped by two columns, where the orange column represents the average age of private employees and the blue column represents the average age of public employees. Additionally, we have the green line that indicates the general average age of public and private workers.
2. What field has been used to filter the data?
DESC_INDICATOR
 

3. What field has been used for the axis of the graph?
DESC_REGION
4. In the legend?
DESC_INDICATOR
5. And in the values?
IN_VALUE
7.3) Make a graph of the average relative weight of technical positions in the private and public sectors over time. The graph should allow you to see the total volume of each metric and the total of both. The metrics to be used are the following:
“Relative wage of technicians in private sector (using clerk as reference)”.
“Relative wage of technicians in public sector (using clerk as reference)”

Relative average wage of technical positions in the private and public sectors over time 

Using the salary of a secretary as a base (see green line), the relative average weight of the salary of technical positions in the private sector is greater than that of technical positions in the public sector. Especially in the years 2009 and 2014.
1. What type of graph has been used and why?
Line charts are best for plotting time series. Specifically, a stacked area chart was used, which is a variation of line charts, which represent the volume, as well as the time period in which it occurs.
In addition, you can see the total volume of each metric and the total of both.
2. What field has been used to filter the data?
DESC_INDICATOR
 

3. What field has been used for the axis of the graph?
ID_YEAR
4. In the legend?
DESC_INDICATOR
5. And in the values?
Average of IN_VALUE
7.4) Obtain the average weight by region of spending on public employees with respect to GDP and public spending
The metrics to be used are the following:
“Wage bill as a percentage of GDP”.
“Wage bill as a percentage of Public Expenditure”.

 
Average weight by region of spending on public employees with respect to GDP and public spending
 

It can be seen that spending on public employees with respect to GDP is greater than spending on public employees with respect to public spending. This makes sense because public spending is part of GDP.
1. What type of graph has been used and why?
A horizontal stacked column chart has been used. Stacked charts allow you to compare totals and subtotals for subcategories. The total percentage average of each one of the indicators can be observed in the first level and, in turn, the weight that each region has in this indicator can be seen. This is how it is seen, for example, that North America has a weight of spending on public employees greater than that of the other regions.
2. What field has been used to filter the data?
DESC_INDICATOR
 
3. What field has been used for the axis of the graph?
DESC_REGION
4. And in the legend?
DESC_INDICATOR
5. And in the values?
Average of IN_VALUE
