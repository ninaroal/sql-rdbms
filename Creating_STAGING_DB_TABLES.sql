-- CREATING STAGING DATABASE AND TABLES

-- Creating Staging Database "WWBI_STG"
CREATE DATABASE [WWBI_STG] 
CONTAINMENT = NONE 
ON PRIMARY 
( NAME = N'WWBI_STG', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL \DATA\WWBI_STG.mdf', 
SIZE = 8192KB, MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
LOG ON 
( NAME = N'WWBI_STG_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15. SQLEXPRESS\MSSQL\DATA\WWBI_STG_log.ldf', SIZE = 8192KB, MAXSIZE = 2048GB, FILEGROWTH = 65536KB) 
WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

-- Creating Staging Table "STG_COUNTRY"
CREATE TABLE STG_COUNTRY(
[Country Code] VARCHAR(250) NULL, 
[Short Name] VARCHAR(250) NULL, 
[Table Name] VARCHAR(250) NULL, 
[Long Name] VARCHAR(250) NULL, 
[2-alpha code] VARCHAR(250) NULL, 
[Currency Unit] VARCHAR(250) NULL, 
[Special Notes] VARCHAR(MAX) NULL, 
[Region] VARCHAR(250) NULL, 
[Income Group] VARCHAR(250) NULL, 
[WB-2 code] VARCHAR(250) NULL, 
[National accounts base year] VARCHAR(250) NULL, 
[National accounts reference year] VARCHAR (250) NULL, 
[SNA price valuation] VARCHAR(250) NULL, 
[Lending category] VARCHAR(250) NULL, 
[Other groups] VARCHAR(250) NULL, 
[System of National Accounts ] VARCHAR(250) NULL, 
[Alternative conversion factor] VARCHAR(250) NULL, 
[PPP survey year] VARCHAR(250) NULL, 
[Balance of Payments Manual in use] VARCHAR(250) NULL, 
[External debt Reporting status] VARCHAR (250) NULL, 
[System of trade] VARCHAR(250) NULL, 
[Government Accounting concept] VARCHAR(250) NULL, 
[IMF data dissemination standard] VARCHAR(250) NULL, 
[Latest population census] VARCHAR(MAX) NULL, 
[Latest household survey] VARCHAR(250) NULL, 
[Source of most recent Income and expenditure data] VARCHAR(250) NULL, 
[Vital registration complete] VARCHAR(250) NULL, 
[Latest agricultural census] VARCHAR(250) NULL, 
[Latest industrial data] VARCHAR(250) NULL, 
[Latest trade data] VARCHAR(250) NULL)

-- Creating Staging Table "STG_DATA"
CREATE TABLE STG_DATA(
[Country Name] VARCHAR(250) NULL, 
[Country Code] VARCHAR(250) NULL, 
[Indicator Name] VARCHAR(MAX) NULL, 
[Indicator Code] VARCHAR (250) NULL, 
a2000 VARCHAR(250) NULL, 
a2001 VARCHAR(250) NULL, 
a2002 VARCHAR(250) NULL, 
a2003 VARCHAR(250) NULL, 
a2004 VARCHAR(250) NULL, 
a2005 VARCHAR(250) NULL, 
a2006 VARCHAR(250) NULL, 
a2007 VARCHAR(250) NULL, 
a2008 VARCHAR(250) NULL, 
a2009 VARCHAR(250) NULL, 
a2010 VARCHAR(250) NULL, 
a2011 VARCHAR(250) NULL, 
a2012 VARCHAR(250) NULL, 
a2013 VARCHAR(250) NULL, 
a2014 VARCHAR(250) NULL, 
a2015 VARCHAR(250) NULL, 
a2016 VARCHAR(250) NULL)