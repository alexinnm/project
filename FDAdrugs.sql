DROP TABLE AppDoc;
CREATE TABLE AppDoc (
AppDocID int (4),
ApplNo  varchar (6),
SeqNo varchar (4),
DocType varchar (50),
DocTitle varchar (100),
DocURL varchar (200),
DocDate datetime,
ActionType varchar (10),
DuplicateCounter int (4),
PRIMARY KEY (AppDocID),
KEY (ApplNo)
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/AppDoc.txt' INTO TABLE AppDoc IGNORE 1 LINES;
#table of all records in AppDoc but not in Application =1
SELECT COUNT(ApplNo), ApplNo, DocDate 
FROM AppDoc 
WHERE ApplNo NOT IN (SELECT r.ApplNo 
                        FROM RegActionDate r)
GROUP BY ApplNo;
#removes all docs in appdoc but not in application
DELETE FROM AppDoc
 WHERE ApplNo NOT IN (SELECT r.ApplNo 
                        FROM RegActionDate r);
ALTER TABLE AppDoc
ADD CONSTRAINT FOREIGN KEY(ApplNo) 
	REFERENCES RegActionDate(ApplNo) 
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE AppDocType_Lookup (
AppDocType varchar (50) Primary Key,
SortOrder int (4)
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/AppDocType_Lookup.txt' INTO TABLE AppDocType_Lookup IGNORE 1 LINES;

CREATE TABLE Application (
 ApplNo varchar(6),
 ApplType varchar (5),
 SponsorApplicant varchar (50),
 MostRecentLabelAvailableFlag bit (1),
 CurrentPatentFlag bit (1),
 ActionType varchar (10),
 Chemical_Type varchar (3),
 Therapeutic_Potential varchar (2),
 Orphan_Code varchar (1),
 KEY (Chemical_Type),
 CONSTRAINT PRIMARY KEY (ApplNo, Chemical_Type)
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/application.txt' INTO TABLE Application IGNORE 1 LINES;

CREATE TABLE DocType_Lookup (
DocType  varchar (4) Primary Key,
DocTypeDesc varchar (50)
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/DocType_Lookup.txt' INTO TABLE DocType_Lookup IGNORE 1 LINES;


CREATE TABLE Product (
ApplNo varchar (6),
ProductNo varchar (3),
Form varchar (255),
Dosage varchar (240),
ProductMktStatus tinyint (1),
TECode varchar (100),
ReferenceDrug bit (1),
Drugname varchar (125),
Activeingred varchar (255),
PRIMARY KEY (ApplNo, ProductNo, ProductMktStatus),
CONSTRAINT FOREIGN KEY(ApplNo) 
       REFERENCES Application(ApplNo) 
       ON DELETE CASCADE ON UPDATE CASCADE
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/Product.txt' INTO TABLE Product IGNORE 1 LINES;

CREATE TABLE Product_TECode (
ApplNo varchar (6),
ProductNo varchar (3),
TECode varchar (50),
TESequence int (4),
ProdMktStatus tinyint (1),
PRIMARY KEY (ApplNo, ProductNo, TESequence, ProdMktStatus),
CONSTRAINT FOREIGN KEY(ApplNo) 
       REFERENCES Product(ApplNo) 
       ON DELETE CASCADE ON UPDATE CASCADE
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/Product_TECode.txt' INTO TABLE Product_TECode IGNORE 1 LINES;

CREATE TABLE RegActionDate (
ApplNo varchar (6),
ActionType varchar (10),
InDocTypeSeqNo varchar (4),
DuplicateCounter int (4),
ActionDate datetime,
DocType varchar (4),
PRIMARY KEY (ApplNo, InDocTypeSeqNo, DuplicateCounter),
KEY (DocType)
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/RegActionDate.txt' INTO TABLE RegActionDate IGNORE 1 LINES;

ALTER TABLE RegActionDate
ADD KEY (DocType);

#This pulls a list of all the records in RegActionDate that are not in Application, some records have many
#rows because of many submissions.  = 803 unique AppNo records
SELECT COUNT(ApplNo), ApplNo, ActionDate 
FROM RegActionDate 
WHERE ApplNo NOT IN (SELECT a.ApplNo 
                        FROM Application a)
GROUP BY ApplNo;

#Code below deletes all records in RegActionDate but NOT in Application, (2933 records deleted)
DELETE FROM RegActionDate
 WHERE ApplNo NOT IN (SELECT a.ApplNo 
                        FROM Application a);

#adding the new foreign key to RegActionDate
ALTER TABLE RegActionDate
ADD FOREIGN KEY (ApplNo)
REFERENCES Application(ApplNo)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE ChemTypeLookup (
ChemicalTypeID int (4),
ChemicalTypeCode varchar (3),
ChemicalTypeDescription varchar (200),
KEY (ChemicalTypeCode),
PRIMARY KEY (ChemicalTypeID, ChemicalTypeCode),
CONSTRAINT FOREIGN KEY(ChemicalTypeCode) 
       REFERENCES Application(Chemical_Type) 
       ON DELETE CASCADE ON UPDATE CASCADE
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/ChemTypeLookup.txt' INTO TABLE ChemTypeLookup IGNORE 1 LINES;

CREATE TABLE ReviewClass_Lookup (
ReviewClassID int (4) Primary Key,
ReviewCode varchar (1),
LongDescritption varchar (100),
ShortDescription varchar (100)
);
LOAD DATA LOCAL INFILE '/Users/nlovejoy/Documents/Grad School/Yale SHP/Classes/Fall-15/Intro_to_DBs/rxdata/drugsatfda/ReviewClass_Lookup.txt' INTO TABLE ReviewClass_Lookup IGNORE 1 LINES;

SELECT COUNT(ApplNo), ApplType FROM Application GROUP BY ApplType ;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM AppDocType_Lookup WHERE AppDocType='AppDocType';
SELECT * FROM Application;



