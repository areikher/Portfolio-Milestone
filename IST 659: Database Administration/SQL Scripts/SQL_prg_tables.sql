DROP TABLE IF EXISTS prg_cat 

DROP TABLE IF EXISTS prg_litter 

DROP TABLE IF EXISTS prg_kitten 

DROP TABLE IF EXISTS prg_characteristic 

DROP TABLE IF EXISTS prg_adopter 

DROP TABLE IF EXISTS prg_organization 

 

CREATE TABLE prg_organization ( 

organization_id int identity, 

address varchar(50) NOT NULL, 

email_addresss varchar(30) unique NOT NULL, 

phone_number int NOT NULL, 

drop_off_date_time datetime NOT NULL, 

--drop_off_time time NOT NULL, 

CONSTRAINT PK_prg_organization PRIMARY KEY (organization_id), 

--CONSTRAINT U1_ prg_Organization UNIQUE (email_addresss) 

) 

CREATE TABLE prg_adopter ( 

adopter_id int identity, 

name varchar(30) NOT NULL, 

address varchar(50) NOT NULL, 

phone_number int NOT NULL, 

email_addresss varchar(30) unique NOT NULL, 

pick_up_date_time datetime NOT NULL,

CONSTRAINT PK_prg_adopter PRIMARY KEY (adopter_id), 

--CONSTRAINT U1_ prg_adopter UNIQUE (email_addresss) 

) 

CREATE TABLE prg_characteristic ( 

characteristic_id int identity, 

age int NOT NULL, 

weight float NOT NULL, 

breed varchar(30), 

color varchar(15), 

CONSTRAINT PK_prg_characteristic PRIMARY KEY (characteristic_id) 

) 

CREATE TABLE prg_kitten( 

kitten_id int identity, 

name varchar(15) NOT NULL, 

vaccine_status bit, 

adopter_id int, 

characteristic_id int NOT NULL, 

CONSTRAINT PK_prg_kitten PRIMARY KEY (kitten_id), 

CONSTRAINT FK1_prg_kitten FOREIGN KEY (characteristic_id) REFERENCES prg_characteristic(characteristic_id), 

CONSTRAINT FK2_prg_kitten FOREIGN KEY (adopter_id) REFERENCES prg_adopter(adopter_id) 

) 

CREATE TABLE prg_litter( 

litter_id int identity, 

number_of_kittens int NOT NULL, 

CONSTRAINT PK_prg_litter PRIMARY KEY (litter_id) 

) 

CREATE TABLE prg_cat ( 

cat_id int identity, 

name varchar(15) NOT NULL, 

pregnant_status bit NOT NULL, 

vaccine_status bit NOT NULL, 

adopter_id int, 

litter_id int, 

characteristic_id int NOT NULL, 

organization_id int NOT NULL, 

CONSTRAINT PK_prg_cat PRIMARY KEY (cat_id), 

CONSTRAINT FK1_prg_cat FOREIGN KEY (litter_id) REFERENCES prg_litter(litter_id), 

CONSTRAINT FK2_prg_cat FOREIGN KEY (adopter_id) REFERENCES  prg_adopter(adopter_id), 

CONSTRAINT FK3_prg_cat FOREIGN KEY (characteristic_id) REFERENCES prg_characteristic(characteristic_id), 

CONSTRAINT FK4_prg_cat FOREIGN KEY (organization_id) REFERENCES prg_organization(organization_id) 

) 

--SELECT * FROM prg_organization 

--SELECT * FROM prg_adopter  

--SELECT * FROM prg_characteristic  

--SELECT * FROM prg_kitten  

--SELECT * FROM prg_litter  

--SELECT * FROM prg_cat 
