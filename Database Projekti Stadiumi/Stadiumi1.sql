create database Stadiumi1

use Stadiumi1



 -------------------------- TABELAT-------------------------------------

 create table Organizuesi(

	IDOrganizuesi int identity(1,1) not null,
	Emri varchar(50) not null unique,
	Rruga varchar(50),
	ZIPCode int,
	Sheti varchar(50) not null,
	Adresa varchar(50), 

	constraint PKOrganizuesi primary key (IDOrganizuesi) 
 
 )
 

 

create table Ndeshja (

	IDNdeshja int identity(1,1) not null,
	Titulli varchar(75) not null,
	Loja char(12),
	Buxheti money,

	constraint PKNdeshja primary key (IDNdeshja),
	constraint checkLLojiLojes check (Loja in ('Futboll','Voleyboll','Boks','Ping-pong','Shah','Tjeter'))
	

)


create table OrariNdeshjes (

	IDNdeshja int not null,
	IDOrari int not null,
	Data date not null,
	kohaFillimit time(0) not null,
	kohaMbarimit time(0) not null,

	constraint PKOrariNdeshja primary key(IDNdeshja, IDOrari),
	constraint FKOrariNdeshja foreign key (IDNdeshja) references Ndeshja (IDNdeshja),

)

create table Organizon (

	IDNdeshja int not null,
	IDOrganizuesi int not null,

	constraint PKOrganizon primary key (IDNdeshja, IDOrganizuesi),
	constraint FKOrganizonNdeshjen foreign key (IDNdeshja) references Ndeshja (IDNdeshja),
	constraint FKOrganizohetNga foreign key (IDOrganizuesi) references Organizuesi (IDOrganizuesi)

)

create table Shikuesi (

	IDShikuesi int identity(1,1) not null,
	Emri varchar(30) not null,
	Mbiemri varchar(30) not null,
	Gjinia char(1),
	Mosha int,
	Ndihma bit not null, -- po ose jo i nevoitet ndihme
	Rruga varchar(50),
	ZIPCode int,
	Shteti varchar(50) not null,
	Vendbanimi varchar(50),

	constraint PKShikuesi primary key(IDShikuesi),
	constraint ShikuesiGjinia check (Gjinia in ('M','F','N'))

)

create table ShikuesiShikonNdeshjen (
	
	IDShikuesi int,
	IDNdeshja int,

	constraint PKShikuesiShikonNdeshjen primary key (IDShikuesi, IDNdeshja),
	constraint FKSSN1 foreign key (IDShikuesi) references Shikuesi (IDShikuesi),
	constraint FKZZN2 foreign key (IDNdeshja) references Ndeshja (IDNdeshja)

)

create table nrTelefonitShikuesit (

	IDShikuesi int,
	NumriTelefonit char(20) unique, --qe te mos kete nr telefonit te njejte

	constraint FKIDShikuesiTelefoni foreign key (IDShikuesi) references Shikuesi (IDShikuesi),
	constraint PKnrTelefonitIDShikuesi primary key (IDShikuesi, NumriTelefonit)

)

create table Bileta (

	IDBileta int identity(1,1),
	Çmimi money not null,
	mënyraBlerjes bit not null, -- 0 for online, 1 for manual
	Shikuesi int not null,
	Ndeshja int not null,
	Ulësja char(8) null,

	constraint PKBileta primary key (IDBileta),
	constraint FKBiletaShikuesi foreign key (Shikuesi) references Shikuesi (IDShikuesi),
	constraint FKBiletaNdeshja foreign key (Ndeshja) references Ndeshja (IDNdeshja),

)

create table OrariPunes (

	IDOrariPunes varchar(20),
	SllotiKohor char(8),
	Fillon time(0) not null,
	Mbaron time(0) not null,

	constraint PKOrari primary key (IDOrariPunes),
	constraint validateTimeSlot check (SllotiKohor in ('Paradite', 'Pasdite'))

)

create table DitePune (

	DitePune char(9),
	IDOrariPunes varchar(20)

	constraint PKDitePune primary key (DitePune, IDOrariPunes),
	constraint FKDitePune foreign key (IDOrariPunes) references OrariPunes (IDOrariPunes),
	constraint validateDay check (DitePune in ('E Hënë','E Martë','E Mërkurë','E Enjte','E Premtë','E Shtunë','E Diel'))

)

create table shkallaPageses (

	IDShkalla char(3),
	Pozita varchar(20) not null,
	PagaMin money not null,
	PagaMax money not null

	constraint PKShkallaPageses primary key (IDShkalla)

)

create table Pagesa (

	IDPagesa varchar(10),
	Stafi int not null,
	sasiaPageses money not null,
	DEPData date,
	DEPOra time(0),

	constraint PKPagesa primary key (IDPagesa),
	constraint FKPagesaStafi foreign key (Stafi) references Stafi (IDStafi),


)


create table Stafi (

	IDStafi int identity(1,1),
	Emri varchar(30) not null,
	Mbiemri varchar(30) not null,
	Gjinia char(1),
	Ditëlindja date,
	Rruga varchar(50),
	ZIPCode int,
	Shteti varchar(50) not null,
	Vendbanimi varchar(50),
	Mosha as convert(int, datediff(hour, Ditëlindja, getDate()))/8760,
	Orari varchar(20) not null,
	ShkallaPageses char(3),


	constraint StafiGjinia check (Gjinia in ('M','F','N')),
	constraint FKStafi1 foreign key (Orari) references OrariPunes (IDOrariPunes),
	constraint FKStafi2 foreign key (ShkallaPageses) references ShkallaPageses (IDShkalla),
	constraint PKStafi primary key (IDStafi),

)

create table nrTelefonitStafi (

	IDStafi int,
	NumriTelefonit char(20) unique,

	constraint FKStafiTelefoni foreign key (IDStafi) references Stafi (IDStafi),
	constraint PKnrTelefonitStafi primary key (IDStafi, NumriTelefonit)

)


create table Menaxhues (

	IDMenaxhues int,
	Pozita varchar(15) not null,

	constraint PKMenaxhues primary key (IDMenaxhues),
	constraint CheckPozita check (Pozita in ('Shitje','CEO', 'HR', 'Marketing')),
	constraint FKMenaxhues foreign key (IDMenaxhues) references Stafi (IDStafi)

)

create table Mirëmbajtës (

	IDMirëmbajtës int,
	Detyra varchar(15),
	PërfaqësuesiMM int,

	constraint PKMirëmbajtës primary key (IDMirëmbajtës),
	constraint checkDetyra check (Detyra in (null, 'Pastrues', 'Inxhinier', 'IT', 'Tjetër')),
	constraint FKMirëmbajtësPërfaq foreign key (PërfaqësuesiMM) references Mirëmbajtës (IDMirëmbajtës),
	constraint FKMirëmbajtës foreign key (IDMirëmbajtës) references Stafi (IDStafi)

)

create table Sigurimi (

	IDSigurimi int,
	sektori int not null,
	PërfaqësuesiS int,

	constraint PKSigurimi primary key (IDSigurimi),
	constraint checkSektori check (sektori between 1 and 8),
	constraint FKSigurimiPërfaq foreign key (PërfaqësuesiS) references Sigurimi (IDSigurimi),
	constraint FKSigurimi foreign key (IDSigurimi) references Stafi (IDStafi)

)

create table Udhëzues (

	IDUdhëzues int,
	llojiNdihmës varchar(20) not null,
	PërfaqësuesiN int,

	constraint PKUdhëzues primary key (IDUdhëzues),
	constraint checkLlojiNdihmës check (llojiNdihmës in ('Shërbyes','Recepsionist', 'Transportues')),
	constraint FKUdhëzuesPërfaq foreign key (PërfaqësuesiN) references Udhëzues (IDUdhëzues),
	constraint FKNdihmës foreign key (IDUdhëzues) references Stafi (IDStafi)

)

create table MenaxheriRishikonOrganizimin (

	Menaxhuesi int,
	Ndeshja int,
	Organizuesi int,
	
	constraint PK_MRO primary key (Ndeshja, Organizuesi, Menaxhuesi),
	constraint OrgMen foreign key (Ndeshja, Organizuesi) references Organizon (IDNdeshja, IDOrganizuesi),
	constraint FK_MSE foreign key (Menaxhuesi) references Menaxhues (IDMenaxhues)

)

----------------[INSERTIMET NE TABLEA]---------------------------


insert into Organizuesi values ('Santiago Bernabeu','Lagjja Kalabria', 10000, 'Kosova', 'Prishtinë')
insert into Organizuesi values ('Universiteti AAB', 'Lagjja Kalabria', 10000, 'Kosova', 'Prishtinë')
insert into Organizuesi values ('NFL','345 Park Avenue New York',10154,'USA','New York City')
insert into Organizuesi values ('Universal Music Group','Hammersmith Rd, Hammersmith', 200,'UK','Londra')
insert into Organizuesi values ('Komuna e Prishtinës','UÇK-2',10000,'Kosova','Prishtinë')
insert into Organizuesi values ('Gjirafa','Magjistralja Prishtine - Ferizaj', 10000 ,'Kosova','Prishtinë')
insert into Organizuesi values ('Komuna e Kamenicës','Filizat ',60000,'Kosova','Kamenicë')
insert into Organizuesi values ('Komuna e Tetovës','Isa Mustafa, 12',50000,'Kosova','Gjakovë')
insert into Organizuesi values ('Komuna e Istogut','Hava e madhe, 34',33000,'Kosova','Istog')
insert into Organizuesi values ('Komuna e Gjilanit','Adem Jashari, 12 115',60000,'Kosova','Gjilan')
insert into Organizuesi values ('Devolli','Zahir Pajaziti, M9', 30000,'Kosova','Pejë')
insert into Organizuesi values ('UEFA','2220 Colorado Ave, Santa Monica, CA ',20000, 'USA','California')


insert into Ndeshja values ('Barcelona - Real Madrid', 'Futboll', 100000)
insert into Ndeshja values ('Chelsea - Aresnal','Futboll', 80000)
insert into Ndeshja values ('MC Gregor vs Khabibi', 'Boks', 750000)
insert into Ndeshja values ('KV-Kamenica vs KV-Gjilani','Voleyboll', 3000)
insert into Ndeshja values ('Kasparov - Magnus Carlsen ', 'Shah', 50000)
insert into Ndeshja values ('Anglia - Spanja', 'Futboll', 80000)
insert into Ndeshja values ('Kosova - Shqiperia', 'Futboll', 2500)
insert into Ndeshja values ('Brazil - Argentina', 'Futboll', 3000000)
insert into Ndeshja values ('Ernesto Hoost - Mc Gregor','Boks', 1500000)
insert into Ndeshja values ('''Talent Show'' 2021', 'Tjeter', 2500)

insert into OrariNdeshjes values (1,1,'2023-1-24','15:00','16:30')
insert into OrariNdeshjes values (2,1,'2023-5-12','20:00', '23:00')
insert into OrariNdeshjes values (2,2,'2023-5-13','21:00','00:00')
insert into OrariNdeshjes values (3,1,'2023-4-12','21:00','23:00')
insert into OrariNdeshjes values (3,2,'2023-4-15','21:00', '23:00')
insert into OrariNdeshjes values (3,3,'2023-4-22','21:00','23:00')
insert into OrariNdeshjes values (4,1,'2023-5-5','15:00','18:00')
insert into OrariNdeshjes values (5,1,'2023-2-13','21:00','23:00')
insert into OrariNdeshjes values (6,1,'2023-7-7','15:00','18:00')
insert into OrariNdeshjes values (6,2,'2023-7-9','07:00','10:00')
insert into OrariNdeshjes values (6,3,'2023-7-11','10:00','13:00')
insert into OrariNdeshjes values (6,4,'2023-7-13','21:00','23:00')
insert into OrariNdeshjes values (6,5,'2023-7-15','15:00','18:00')
insert into OrariNdeshjes values (6,6,'2023-7-17','15:00','18:00')
insert into OrariNdeshjes values (6,7,'2023-7-19','21:00','23:00')
insert into OrariNdeshjes values (6,8,'2023-7-21','12:00','15:00')
insert into OrariNdeshjes values (7,1,'2023-5-7','07:00','10:00')
insert into OrariNdeshjes values (8,1,'2023-11-15','15:00','18:00')
insert into OrariNdeshjes values (8,2,'2023-11-22','15:00','18:00')
insert into OrariNdeshjes values (9,1,'2023-9-12','12:00','15:00')
insert into OrariNdeshjes values (10,1,'2023-3-12','12:00','15:00')
insert into OrariNdeshjes values (10,2,'2023-3-13','12:00','15:00')
insert into OrariNdeshjes values (11,1,'2023-3-1','15:00','18:00')
insert into OrariNdeshjes values (11,2,'2023-6-1','15:00','18:00')
insert into OrariNdeshjes values (11,3,'2023-9-1','12:00','15:00')


insert into Organizon values (1,1)
insert into Organizon values (1,2)
insert into Organizon values (2,3)
insert into Organizon values (2,7)
insert into Organizon values (3,3)
insert into Organizon values (4,8)
insert into Organizon values (4,11)
insert into Organizon values (4,12)
insert into Organizon values (4,13)
insert into Organizon values (4,14)
insert into Organizon values (5,8)
insert into Organizon values (5,9)
insert into Organizon values (6,6)
insert into Organizon values (7,8)
insert into Organizon values (8,5)
insert into Organizon values (8,8)
insert into Organizon values (9,2)
insert into Organizon values (10,4)
insert into Organizon values (10,8)
insert into Organizon values (11,8)
insert into Organizon values (11,11)
insert into Organizon values (11,12)
insert into Organizon values (11,13)
insert into Organizon values (11,14)
insert into Organizon values (11,9)
insert into Organizon values (59,5)


insert into Shikuesi values ('Artin','Dervishi','M',19,0,'Rruga Bugaqaj',62000,'Kosova','Koretin')
insert into Shikuesi values ('Suad','Sylejmani','M',19,0,'Rruga Bugaqaj',62000,'Kosova','Koretin')
insert into Shikuesi values ('Hamdi','Canaj','M',60,1,'Rruga Festimi',30000,'Kosova','Prishtina')
insert into Shikuesi values ('Remzi','Hamiti','M',44,1,'Rruga Shqiperia',62000,'Kosova','Gjilan')
insert into Shikuesi values ('Eliza','Maksuti','F',20,0,'Rruga Maksuti',62000,'Kosova','Gjilan')
insert into Shikuesi values ('Festim','Hoda','M',24,0,'Rruga Hoda',62000,'Kosova','Koretin')
insert into Shikuesi values ('Gert','Redenica','M',18,0,'Rruga Pavarsia',62000,'Kosova','Kamenice')
insert into Shikuesi values ('Sadri','Kallaba','M',19,0,'Rruga Kallaba',62000,'Kosova','Koretin')
insert into Shikuesi values ('Valmir','Krasniqi','M',20,1,'Rruga Bugaqaj',62000,'Kosova','Koretin')
insert into Shikuesi values ('Leorian','Demolli','M',19,0,'Rruga Demolli',62000,'Kosova','Krileva')
insert into Shikuesi values ('Rinesa','Zuzaku','F',19,0,'Rruga Zuzaku',62000,'Kosova','Kamenice')
insert into Shikuesi values ('Blend','Canaj','M',19,0,'Rruga Canaj',62000,'Kosova','Kamenice')



insert into ShikuesiShikonNdeshjen values (1,1)
insert into ShikuesiShikonNdeshjen values (1,2)
insert into ShikuesiShikonNdeshjen values (1,3)
insert into ShikuesiShikonNdeshjen values (1,5)
insert into ShikuesiShikonNdeshjen values (1,8)
insert into ShikuesiShikonNdeshjen values (2,1)
insert into ShikuesiShikonNdeshjen values (2,3)
insert into ShikuesiShikonNdeshjen values (2,4)
insert into ShikuesiShikonNdeshjen values (2,5)
insert into ShikuesiShikonNdeshjen values (2,6)
insert into ShikuesiShikonNdeshjen values (3,1)
insert into ShikuesiShikonNdeshjen values (3,2)
insert into ShikuesiShikonNdeshjen values (3,3)
insert into ShikuesiShikonNdeshjen values (4,4)
insert into ShikuesiShikonNdeshjen values (4,1)
insert into ShikuesiShikonNdeshjen values (5,1)
insert into ShikuesiShikonNdeshjen values (5,2)
insert into ShikuesiShikonNdeshjen values (6,1)
insert into ShikuesiShikonNdeshjen values (6,4)
insert into ShikuesiShikonNdeshjen values (7,5)
insert into ShikuesiShikonNdeshjen values (8,7)
insert into ShikuesiShikonNdeshjen values (9,1)
insert into ShikuesiShikonNdeshjen values (9,2)
insert into ShikuesiShikonNdeshjen values (9,14)
insert into ShikuesiShikonNdeshjen values (10,14)
insert into ShikuesiShikonNdeshjen values (11,59)
insert into ShikuesiShikonNdeshjen values (12,59)
insert into ShikuesiShikonNdeshjen values (9,59)
insert into ShikuesiShikonNdeshjen values (1,48)
insert into ShikuesiShikonNdeshjen values (2,48)
insert into ShikuesiShikonNdeshjen values (8,48)
insert into ShikuesiShikonNdeshjen values (4,53)
insert into ShikuesiShikonNdeshjen values (5,52)
insert into ShikuesiShikonNdeshjen values (6,55)
insert into ShikuesiShikonNdeshjen values (12,59)



insert into nrTelefonitShikuesit values (1, '+383 45 994 307')
insert into nrTelefonitShikuesit values (1, '+383 44 138 689')
insert into nrTelefonitShikuesit values (1, '+383 44 706 856')
insert into nrTelefonitShikuesit values (2, '+383 45 665 123')
insert into nrTelefonitShikuesit values (2, '+383 44 123 121')
insert into nrTelefonitShikuesit values (2, '+383 44 124 554')
insert into nrTelefonitShikuesit values (3, '+383 45 990 145')
insert into nrTelefonitShikuesit values (3, '+383 44 456 128')
insert into nrTelefonitShikuesit values (3, '+383 44 961 491')
insert into nrTelefonitShikuesit values (3, '+383 44 102 221')
insert into nrTelefonitShikuesit values (4, '+383 44 449 121')
insert into nrTelefonitShikuesit values (4, '+383 44 761 113')
insert into nrTelefonitShikuesit values (4, '+383 44 331 221')
insert into nrTelefonitShikuesit values (5, '+383 44 223 223')
insert into nrTelefonitShikuesit values (5, '+383 45 566 542')
insert into nrTelefonitShikuesit values (6, '+383 45 910 001')
insert into nrTelefonitShikuesit values (6, '+383 45 991 921')
insert into nrTelefonitShikuesit values (6, '+383 45 911 119')
insert into nrTelefonitShikuesit values (7, '+383 45 120 441')
insert into nrTelefonitShikuesit values (7, '+383 45 215 675')
insert into nrTelefonitShikuesit values (8, '+383 45 122 567')
insert into nrTelefonitShikuesit values (8, '+383 45 351 990')
insert into nrTelefonitShikuesit values (8, '+383 45 990 991')
insert into nrTelefonitShikuesit values (9, '+383 45 122 538')
insert into nrTelefonitShikuesit values (9, '+383 45 583 519')
insert into nrTelefonitShikuesit values (9, '+383 45 115 551')
insert into nrTelefonitShikuesit values (10, '+383 45 224 507')

insert into Bileta values (60,0,2,6,'4-12-022')
insert into Bileta values (20, 1,1,1,null)
insert into Bileta values (20, 1,2,1,null)
insert into Bileta values (20, 0,3,1,null)
insert into Bileta values (20, 0,4,1,null)
insert into Bileta values (20, 1,5,1,null)
insert into Bileta values (20, 1,6,1,null)
insert into Bileta values (20, 1,9,1,null)
insert into Bileta values (330,0,1,8,'2-10-002')
insert into Bileta values (350,0,10,8,'1-25-078')
insert into Bileta values (10,0,1,5,'1-12-031')
insert into Bileta values (10,0,2,5,'2-03-004')
insert into Bileta values (10,0,7,5,'2-04-001')
insert into Bileta values (0,1,2,4,null)
insert into Bileta values (0,1,4,4,null)
insert into Bileta values (0,1,6,4,null)
insert into Bileta values (0,1,8,7,null)
insert into Bileta values (410,0,1,2,'4-04-005')
insert into Bileta values (360,0,3,2,'6-09-089')
insert into Bileta values (290,0,5,2,'8-23-099')
insert into Bileta values (450,0,6,2,'3-12-022')
insert into Bileta values (210,0,1,3,'3-12-044')
insert into Bileta values (170,0,2,3,'7-22-091')
insert into Bileta values (150,1,3,3,'5-18-076')
insert into Bileta values (300,1,9,3,'1-11-056')
insert into Bileta values (280,1,9,3,'1-11-056')
insert into Bileta values (300,1,9,3,'1-11-056')



insert into shkallaPageses values ('MP1', 'Menaxhues', 4500, 10000)
insert into shkallaPageses values ('MP2', 'Menaxhues', 4800, 12000)
insert into shkallaPageses values ('MP3', 'Menaxhues', 4000, 9000)
insert into shkallaPageses values ('MP4', 'Menaxhues', 4400, 9500)
insert into shkallaPageses values ('N1', 'Ndihmës', 600, 800)
insert into shkallaPageses values ('N2', 'Ndihmës', 450, 550)
insert into shkallaPageses values ('S1', 'Sigurimi', 450, 500)
insert into shkallaPageses values ('MM1', 'Mirëmbajtës', 1000, 1200)
insert into shkallaPageses values ('MM2', 'Mirëmbajtës', 300, 400)
insert into shkallaPageses values ('MM3', 'Mirëmbajtës', 1500, 2000)

Select * from shkallaPageses
Select * from Stafi

insert into Stafi values ('Afrim', 'Dervishi', 'M', '1980-12-10','Rruga Bugaqaj',62000,'Kosove','Koretin','Menaxhues 1' , 'MP1')
insert into Stafi values ('Avdi', 'Sylejmani', 'M', '1979-12-10','Kosova /Prishtinë',62000,'Kosove','Koretin', 'Menaxhues 2' , 'MP2')
insert into Stafi values ('Feime', 'Syla', 'F', '1989-12-10','Kosova /Gjilan',62000,'Kosove','Koretin','Menaxhues 3' , 'MP3')
insert into Stafi values ('Sahadet', 'Sherifi', 'F', '1989-12-10','Kosova /Gjilan',62000,'Kosove','Koretin','Menaxhues 4' , 'MP4')
insert into Stafi values ('Blend', 'Canaj', 'M', '1999-12-10','Kosova /Gjilan',62000,'Kosove','Koretin','Sigurimi 1' , 'S1')
insert into Stafi values ('Erina', 'Haxhiu', 'F', '2000-12-10','Kosova /Gjakova',62000,'Kosove','Koretin','Ndihmës 1' , 'N1')
insert into Stafi values ('Olta', 'Dervishi', 'F', '2001-12-10','Kosova /Gjakova',62000,'Kosove','Koretin','Ndihmës 2' , 'N2')
insert into Stafi values ('Fatlum', 'Korqa', 'M', '1997-12-10','Kosova /Prizren',62000,'Kosove','Koretin','Mirëmbajtës 1' , 'MM1')
insert into Stafi values ('Flatron', 'Halimi', 'M', '1994-12-10','Kosova /Prishtine',62000,'Kosove','Koretin','Mirëmbajtës 1' , 'MM2')
insert into Stafi values ('Genc', 'Sadiku', 'M', '1991-12-10','Kosova /Prizren',62000,'Kosove','Koretin','Mirëmbajtës 3' , 'MM3')


insert into nrTelefonitStafi values (31,'+383 44 123 145')
insert into nrTelefonitStafi values (32,'+383 44 613 124')
insert into nrTelefonitStafi values (33,'+383 44 153 167')
insert into nrTelefonitStafi values (34,'+383 44 623 613')
insert into nrTelefonitStafi values (35,'+383 45 989 566')
insert into nrTelefonitStafi values (36,'+383 45 201 112')
insert into nrTelefonitStafi values (37,'+383 45 451 567')
insert into nrTelefonitStafi values (38,'+383 45 441 900')
insert into nrTelefonitStafi values (40,'+383 45 111 990')

insert into Menaxhues values (31,'CEO')
insert into Menaxhues values (32,'Shitje')
insert into Menaxhues values (33,'HR')
insert into Menaxhues values (34,'Marketing')

insert into Udhëzues values (36,'Shërbyes',36)
insert into Udhëzues values (37,'Recepsionist',36);


insert into Sigurimi values (35,4,35)


insert into Mirëmbajtës values (38,'IT',38)
insert into Mirëmbajtës values (40,'Pastrues',38)
insert into Mirëmbajtës values (43,'Inxhinier',38)

delete from MenaxheriRishikonOrganizimin


insert into MenaxheriRishikonOrganizimin values (31,1,1)
insert into MenaxheriRishikonOrganizimin values (31,1,2)
insert into MenaxheriRishikonOrganizimin values (31,2,3)
insert into MenaxheriRishikonOrganizimin values (31,2,7)
insert into MenaxheriRishikonOrganizimin values (31,3,3)
insert into MenaxheriRishikonOrganizimin values (31,23,6)
insert into MenaxheriRishikonOrganizimin values (31,24,8)
insert into MenaxheriRishikonOrganizimin values (31,25,6)
insert into MenaxheriRishikonOrganizimin values (31,19,9)
insert into MenaxheriRishikonOrganizimin values (31,18,12)

insert into MenaxheriRishikonOrganizimin values (32,1,1)
insert into MenaxheriRishikonOrganizimin values (32,1,2)
insert into MenaxheriRishikonOrganizimin values (32,18,3)
insert into MenaxheriRishikonOrganizimin values (33,19,3)
insert into MenaxheriRishikonOrganizimin values (31,23,8)
insert into MenaxheriRishikonOrganizimin values (32,24,11)
insert into MenaxheriRishikonOrganizimin values (32,25,14)
insert into MenaxheriRishikonOrganizimin values (32,28,13)
insert into MenaxheriRishikonOrganizimin values (32,29,4)

insert into MenaxheriRishikonOrganizimin values (32,30,4)

insert into MenaxheriRishikonOrganizimin values (32,32,13)
insert into MenaxheriRishikonOrganizimin values (33,35,4)

insert into MenaxheriRishikonOrganizimin values (34,36,5)
insert into MenaxheriRishikonOrganizimin values (35,37,13)

insert into MenaxheriRishikonOrganizimin values (35,40,4)
insert into MenaxheriRishikonOrganizimin values (36,42,4)
insert into MenaxheriRishikonOrganizimin values (37,44,13)
insert into MenaxheriRishikonOrganizimin values (38,46,5)
insert into MenaxheriRishikonOrganizimin values (36,47,4)
insert into MenaxheriRishikonOrganizimin values (34,48,3)
insert into MenaxheriRishikonOrganizimin values (34,51,3)
insert into MenaxheriRishikonOrganizimin values (31,53,3)
insert into MenaxheriRishikonOrganizimin values (31,55,13)
insert into MenaxheriRishikonOrganizimin values (31,59,6)

Select * from Menaxhues
Select * from MenaxheriRishikonOrganizimin
Select * from Ndeshja
Select * from Organizuesi

insert into Pagesa values ('PgM-1',31,4500,'2023-01-05','12:20:43')
insert into Pagesa values ('PgM-2',32,10000,'2023-12-05','16:51:05')
insert into Pagesa values ('PgM-3',33,6600,'2023-01-05','11:13:48')
insert into Pagesa values ('PgM-4',34,5100,'2023-01-05','19:13:57')
insert into Pagesa values ('PgN-1',36,750,'2023-01-08','19:12:11')
insert into Pagesa values ('PgN-2',37,500,'2023-01-09','08:01:02')
insert into Pagesa values ('PgS-1',35,450,'2023-01-06','07:04:56')
insert into Pagesa values ('PgMM1',38,1200,'2023-01-04','14:05:44')
insert into Pagesa values ('PgMM2',40,400,'2023-01-04','15:55:32')
insert into Pagesa values ('PgMM3',43,1660,'2023-01-05','10:01:04')


insert into OrariPunes values ('Menaxhues 1', 'Paradite', '07:00', '20:00')
insert into OrariPunes values ('Menaxhues 2', 'Pasdite', '17:00','04:00')
insert into OrariPunes values ('Menaxhues 3','Paradite','08:00','21:00')
insert into OrariPunes values ('Menaxhues 4','Pasdite','15:00','01:00')
insert into OrariPunes values ('Ndihmës 1','Paradite','09:00','17:00')
insert into OrariPunes values ('Ndihmës 2','Pasdite','17:00','01:00')
insert into OrariPunes values ('Sigurimi 1','Paradite','09:00','22:00')
insert into OrariPunes values ('Sigurimi 2', 'Pasdite','22:00','09:00')
insert into OrariPunes values ('Mirëmbajtës 1','Paradite','07:00','15:00')
insert into OrariPunes values ('Mirëmbatjës 2','Paradite','09:00','17:00')
insert into OrariPunes values ('Mirëmbajtës 3','Pasdite','12:00','20:00')


Select * from DitePune

insert into DitePune values ('E Hënë', 'Menaxhues 1')
insert into DitePune values ('E Martë', 'Menaxhues 1')
insert into DitePune values ('E Mërkurë', 'Menaxhues 1')
insert into DitePune values ('E Enjte', 'Menaxhues 1')
insert into DitePune values ('E Premtë', 'Menaxhues 1')
insert into DitePune values ('E Shtunë', 'Menaxhues 1')

insert into DitePune values ('E Martë', 'Menaxhues 2')
insert into DitePune values ('E Mërkurë', 'Menaxhues 2')
insert into DitePune values ('E Enjte', 'Menaxhues 2')
insert into DitePune values ('E Premtë', 'Menaxhues 2')
insert into DitePune values ('E Shtunë', 'Menaxhues 2')
insert into DitePune values ('E Diel', 'Menaxhues 2')

insert into DitePune values ('E Hënë', 'Menaxhues 3')
insert into DitePune values ('E Martë', 'Menaxhues 3')
insert into DitePune values ('E Enjte', 'Menaxhues 3')
insert into DitePune values ('E Premtë', 'Menaxhues 3')
insert into DitePune values ('E Shtunë', 'Menaxhues 3')
insert into DitePune values ('E Diel', 'Menaxhues 3')

insert into DitePune values ('E Hënë', 'Menaxhues 4')
insert into DitePune values ('E Mërkurë', 'Menaxhues 4')
insert into DitePune values ('E Enjte', 'Menaxhues 4')
insert into DitePune values ('E Premtë', 'Menaxhues 4')
insert into DitePune values ('E Shtunë', 'Menaxhues 4')
insert into DitePune values ('E Diel', 'Menaxhues 4')

insert into DitePune values ('E Hënë', 'Ndihmës 1')
insert into DitePune values ('E Martë', 'Ndihmës 1')
insert into DitePune values ('E Mërkurë', 'Ndihmës 1')
insert into DitePune values ('E Enjte', 'Ndihmës 1')
insert into DitePune values ('E Premtë', 'Ndihmës 1')

insert into DitePune values ('E Mërkurë', 'Ndihmës 2')
insert into DitePune values ('E Enjte', 'Ndihmës 2')
insert into DitePune values ('E Premtë', 'Ndihmës 2')
insert into DitePune values ('E Shtunë', 'Ndihmës 2')
insert into DitePune values ('E Diel', 'Ndihmës 2')

insert into DitePune values ('E Hënë', 'Sigurimi 1')
insert into DitePune values ('E Mërkurë', 'Sigurimi 1')
insert into DitePune values ('E Enjte', 'Sigurimi 1')
insert into DitePune values ('E Shtunë', 'Sigurimi 1')

insert into DitePune values ('E Martë', 'Sigurimi 2')
insert into DitePune values ('E Premtë', 'Sigurimi 2')
insert into DitePune values ('E Shtunë', 'Sigurimi 2')
insert into DitePune values ('E Diel', 'Sigurimi 2')

insert into DitePune values ('E Hënë', 'Mirëmbajtës 1')
insert into DitePune values ('E Martë', 'Mirëmbajtës 1')
insert into DitePune values ('E Mërkurë', 'Mirëmbajtës 1')
insert into DitePune values ('E Enjte', 'Mirëmbajtës 1')
insert into DitePune values ('E Premtë', 'Mirëmbajtës 1')
insert into DitePune values ('E Shtunë', 'Mirëmbajtës 1')

insert into DitePune values ('E Hënë', 'Mirëmbajtës 2')
insert into DitePune values ('E Martë', 'Mirëmbajtës 2')
insert into DitePune values ('E Mërkurë', 'Mirëmbajtës 2')
insert into DitePune values ('E Enjte', 'Mirëmbajtës 2')
insert into DitePune values ('E Premtë', 'Mirëmbajtës 2')
insert into DitePune values ('E Shtunë', 'Mirëmbajtës 2')
insert into DitePune values ('E Diel', 'Mirëmbajtës 2')

insert into DitePune values ('E Hënë', 'Mirëmbajtës 3')
insert into DitePune values ('E Martë', 'Mirëmbajtës 3')
insert into DitePune values ('E Mërkurë', 'Mirëmbajtës 3')
insert into DitePune values ('E Enjte', 'Mirëmbajtës 3')
insert into DitePune values ('E Premtë', 'Mirëmbajtës 3')

-------------------------------------------------[ UPDATES ]-------------------------------------------------

update Bileta
set Çmimi *= 1.10
where mënyraBlerjes = 1

update Bileta
set Çmimi = 5
where Bileta.Çmimi = 0

Select * from Ndeshja
update Ndeshja
set Buxheti +=5000

update Organizuesi
set rruga = 'Lagjja e Spitali'
where IDOrganizuesi = 2

update organizuesi
set rruga = 'Lagjja Kalabria'
where IDOrganizuesi = '8'

update Organizuesi
set zipcode = 14100
where ZIPCode = 14112

update Ndeshja
set Loja = 'Tjetër'
where IDNdeshja = 1

update Ndeshja
set buxheti = 100000
where IDNdeshja = 9

update Ndeshja
set buxheti = 0
where IDNdeshja = 5

update Ndeshja
set buxheti = 1400
where IDNdeshja = 1

update Shikuesi
set emri = 'Viola', mbiemri= 'Terstena'
where IDShikuesi = 3

update Shikuesi
set gjinia = 'N'
where IDShikuesi = 11

update Shikuesi
set Ndihma = 0
where Ndihma = 1

update Shikuesi
set rruga = 'Dervishi, 13'
where rruga = 'Bugaqaj'

update Bileta
set Çmimi = 20
where Çmimi = 10

update Bileta
set Ulësja = '5-15-024'
where Ulësja = '1-11-056'

update Bileta
set mënyraBlerjes = 1
where IDBileta = 4

update stafi
set emri = 'Remzie'
where emri = 'Feime'

update stafi
set Ditëlindja = '1980-06-30'
where IDStafi = 5


update Organizuesi
set Emri = 'UEFA'
where IDOrganizuesi = 3

update Organizuesi
set Emri = 'Teto'
where IDOrganizuesi = 6


-------------------------------------------------[ DELETES ]-------------------------------------------------

delete from Bileta
where len(Bileta.Ulësja) is null 

delete from Bileta
where IDBileta = 1

delete from Shikuesi
where IDShikuesi = 13;

delete from Ndeshja
where Loja = 'Tjeter'

delete from MenaxheriRishikonOrganizimin
where Menaxhuesi = 1 and Ndeshja = 1 and Organizuesi = 1

delete from MenaxheriRishikonOrganizimin
where Menaxhuesi = 4

delete from nrTelefonitShikuesit
where IDShikuesi = 3

delete from nrTelefonitStafi
where IDStafi = 5

delete from DitePune
where DitePune = 'E Diel' and IDOrariPunes = 'Menaxhues 2'

delete from DitePune
where DitePune = 'E Diel' and IDOrariPunes = 'Ndihmës 2'

delete from DitePune
where DitePune = 'E Diel' and IDOrariPunes = 'Mirëmbajtës 2'




---------------------------------------[Query të thjeshta me një relacion ne nje tabele:]--------------------------------------------

	SELECT * FROM Ndeshja;
	SELECT Titulli from Ndeshja;
	Select * from Ndeshja where Loja = 'Futboll';
	Select * from Ndeshja where Buxheti = 3500 AND IDNdeshja = 7;
	Select * from Ndeshja where Loja = 'Boks' And Buxheti = 751000 AND IDNdeshja =3;
	Select Loja from Ndeshja;
	Select * from Ndeshja where Titulli = 'Barcelona - Real Madrid' AND Buxheti = 1900;
	Select * from Ndeshja where Loja = 'Shah';
	Select * from Shikuesi;
	Select Emri  from Shikuesi ;
	Select * from Shikuesi where Emri = 'Artin' AND Mbiemri = 'Dervishi';
	Select * from Shikuesi where Emri = 'Suad' AND Mbiemri = 'Sylejmani';
	Select * from Organizuesi where Sheti = 'Kosova';
	Select * from Shikuesi where Ndihma = 1;
	Select * from Organizuesi where Emri = 'NFL';
	Select * from Organizuesi where ZIPCode = 14100;
	Select kohaFillimit from OrariNdeshjes where kohaFillimit > '19:00';


	
---------------------------------------[Query të thjeshta me një relacion ne me shume se nje tabele:]--------------------------------------------


	SELECT n.Titulli,s.Emri ,s.Mbiemri
	From Ndeshja n , Shikuesi s
	Where n.IDNdeshja = s.IDShikuesi
	Order by s.Emri

	SELECT o.Emri,o.Sheti,n.Loja ,SUM(n.Buxheti) [nr.Buxhetit]
	FROM Organizuesi o, Ndeshja n
	WHERE o.IDOrganizuesi = n.IDNdeshja
	AND n.Buxheti>20000
	GROUP BY o.Emri,O.Sheti,n.Loja
	ORDER BY[nr.Buxhetit] desc

	Select s.*, nr.NumriTelefonit
	FROM Stafi s,nrTelefonitStafi nr
	where s.IDStafi = nr.IDStafi


	Select   st.Emri,st.Mbiemri, MIN(s.PagaMin) [Paga me e ulet]
	From shkallaPageses s , Stafi st
	where s.IDShkalla = st.ShkallaPageses
	GROUP BY st.Emri,st.Mbiemri,s.PagaMin
	ORDER BY[Paga me e ulet] 


	Select s.Emri , s.Mbiemri , s.Mosha, m.Detyra ,m.PërfaqësuesiMM
	From Stafi s , Mirëmbajtës m 
	WHERE S.IDStafi = m.IDMirëmbajtës
	GROUP BY s.Emri,s.Mbiemri,s.Mosha,m.Detyra,m.PërfaqësuesiMM
	

	Select s.Emri , s.Mbiemri , s.Mosha, m.Pozita , MAX(sh.PagaMax)[Paga me e madhe]
	From Stafi s , Menaxhues m  , shkallaPageses sh 
	WHERE S.IDStafi = m.IDMenaxhues and s.ShkallaPageses = Sh.IDShkalla
	GROUP BY s.Emri,s.Mbiemri,s.Mosha,m.Pozita
	ORDER BY[Paga me e madhe] desc


	Select s.Emri , s.Mbiemri , n.Titulli ,ond.Data , o.Fillon , o.Mbaron
	From Ndeshja n , OrariNdeshjes ond , Stafi s , OrariPunes o 
	where n.IDNdeshja =  ond.IDNdeshja and s.Orari = o.IDOrariPunes
	Order by ond.Data 
	

	SELECT Ndeshja.Titulli, OrariNdeshjes.Data, OrariNdeshjes.kohaFillimit
	FROM Ndeshja
	JOIN ShikuesiShikonNdeshjen ON Ndeshja.IDNdeshja = ShikuesiShikonNdeshjen.IDNdeshja
	JOIN Shikuesi ON ShikuesiShikonNdeshjen.IDShikuesi = Shikuesi.IDShikuesi
	JOIN OrariNdeshjes ON Ndeshja.IDNdeshja = OrariNdeshjes.IDNdeshja
	WHERE Shikuesi.IDShikuesi = 4
	


---------------------------------------[Query të avancuar me një relacion ne me shume se nje tabele:]--------------------------------------------

	-------------Shfaq gjinin e shikuesve që shikojnë ndeshjen me IDNdeshja = 2 dhe nuk janë në nevojë të ndihmës:--------------------
	SELECT s.Gjinia 
	FROM Shikuesi s 
	RIGHT JOIN ShikuesiShikonNdeshjen ON s.IDShikuesi = ShikuesiShikonNdeshjen.IDShikuesi
	WHERE ShikuesiShikonNdeshjen.IDNdeshja = 2 AND s.Ndihma = 0


	-------------Shfaq emrat e të gjitha shteteve ku jetojnë shikuesit që shikojnë ndeshjen me IDNdeshja = 1:--------------------

		SELECT DISTINCT Shteti FROM Shikuesi
	INNER JOIN ShikuesiShikonNdeshjen on Shikuesi.IDShikuesi = ShikuesiShikonNdeshjen.IDShikuesi
	WHERE ShikuesiShikonNdeshjen.IDNdeshja = 1

	-------------Shfaq shikuesit që shikojnë ndeshjen me IDNdeshja = 4 dhe kanë moshën në mes të 20 dhe 25:--------------------
	SELECT Emri, Mbiemri FROM Shikuesi
	INNER JOIN ShikuesiShikonNdeshjen ON Shikuesi.IDShikuesi = ShikuesiShikonNdeshjen.IDShikuesi
	WHERE ShikuesiShikonNdeshjen.IDNdeshja=2 and Shikuesi.Mosha >19 and Shikuesi.Mosha<26


	SELECT Ndeshja.Titulli, AVG(Shikuesi.Mosha) as Mosha_mesatare, COUNT(DISTINCT Shikuesi.Emri) as Numri_shikuesve
	FROM Ndeshja
	INNER JOIN Shikuesi ON Shikuesi.IDShikuesi =IDNdeshja
	GROUP BY Ndeshja.Titulli
	HAVING COUNT(DISTINCT Shikuesi.Emri) > 1
	ORDER BY Mosha_mesatare DESC;

	
		SELECT COUNT(*)  as Numri_Shikuesve
	FROM Ndeshja n
	Full JOIN Shikuesi s ON n.IDNdeshja =s.IDShikuesi
	WHERE n.Loja = 'Boks';
	

	SELECT Ndeshja.*, Shikuesi.*
	FROM Ndeshja
	Left JOIN Shikuesi ON Ndeshja.IDNdeshja = Shikuesi.IDShikuesi
	WHERE Ndeshja.Titulli = 'Barcelona - Real Madrid';


	SELECT Shikuesi.*
	FROM Ndeshja n
	INNER JOIN ShikuesiShikonNdeshjen s ON n.IDNdeshja = s.IDNdeshja
	INNER JOIN Shikuesi ON s.IDShikuesi = Shikuesi.IDShikuesi
	WHERE n.Loja = 'Futboll' AND Shikuesi.Mosha > 10;


	SELECT Shikuesi.*
	FROM Ndeshja
	INNER JOIN ShikuesiShikonNdeshjen ON Ndeshja.IDNdeshja = ShikuesiShikonNdeshjen.IDNdeshja
	INNER JOIN Shikuesi ON ShikuesiShikonNdeshjen.IDShikuesi = Shikuesi.IDShikuesi
	WHERE Ndeshja.Loja = 'Futboll' AND Shikuesi.Mosha > 20 AND Shikuesi.Ndihma = 1;


	SELECT Organizuesi.Emri, Ndeshja.Loja, SUM(Ndeshja.Buxheti) as Buxheti_Ndeshjes
	FROM Ndeshja
	INNER JOIN Organizon ON Ndeshja.IDNdeshja = Organizon.IDNdeshja
	INNER JOIN Organizuesi ON Organizon.IDOrganizuesi = Organizuesi.IDOrganizuesi
	GROUP BY Organizuesi.Emri, Ndeshja.Loja;



		SELECT Menaxhues.Pozita, Organizuesi.Emri, Ndeshja.Loja
	FROM Menaxhues
	JOIN MenaxheriRishikonOrganizimin ON Menaxhues.IDMenaxhues = MenaxheriRishikonOrganizimin.Menaxhuesi
	JOIN Organizon ON MenaxheriRishikonOrganizimin.Ndeshja = Organizon.IDNdeshja AND MenaxheriRishikonOrganizimin.Organizuesi = Organizon.IDOrganizuesi
	JOIN Ndeshja ON Organizon.IDNdeshja = Ndeshja.IDNdeshja
	JOIN Organizuesi ON Organizon.IDOrganizuesi = Organizuesi.IDOrganizuesi
	WHERE Menaxhues.Pozita = 'CEO'
	ORDER BY Organizuesi.Emri, Ndeshja.Loja
	

	SELECT Shikuesi.Emri, Shikuesi.Mbiemri, Ndeshja.Titulli
	FROM Shikuesi
	JOIN ShikuesiShikonNdeshjen ON Shikuesi.IDShikuesi = ShikuesiShikonNdeshjen.IDShikuesi
	JOIN Ndeshja ON ShikuesiShikonNdeshjen.IDNdeshja = Ndeshja.IDNdeshja
	WHERE Shikuesi.Ndihma = 0;


---------------------------------------[Subquery të thjeshta]--------------------------------------------



		SELECT Emri
			FROM Stafi
			WHERE IDStafi IN (
			  SELECT IDMenaxhues
			  FROM Menaxhues
			  WHERE Pozita = 'HR'
			)


	
	------------Nje subquery qe tregon data dhe koha e nisjes se ndeshjes me IDNdeshja = 1:--------------------

		SELECT Data, kohaFillimit
			FROM OrariNdeshjes
			WHERE IDNdeshja = (SELECT IDNdeshja
							   FROM Ndeshja
							   WHERE IDNdeshja = 1);


	------------Nje subquery qe tregon emrat e shikuesve qe shikojne ndeshjen me IDNdeshja = 2:--------------------
		SELECT Emri, Mbiemri
			FROM Shikuesi
			WHERE IDShikuesi IN (SELECT IDShikuesi
								 FROM ShikuesiShikonNdeshjen
								 WHERE IDNdeshja = (SELECT IDNdeshja
													FROM Ndeshja
													WHERE IDNdeshja = 2));


	-------------Nje subquery qe tregon numrin e shikuesve qe shikojne ndeshjen me IDNdeshja = 3:--------------------
		SELECT COUNT(*) as Numri_Shikuesve
			FROM ShikuesiShikonNdeshjen
			WHERE IDNdeshja = (SELECT IDNdeshja
							   FROM Ndeshja
							   WHERE IDNdeshja = 3);

		-------------Nje subquery qe tregon ID te organizuesit me ndeshjen me titull:--------------------
		SELECT IDOrganizuesi
			FROM Organizon
			WHERE IDNdeshja = (SELECT IDNdeshja
							   FROM Ndeshja
							   WHERE Titulli = 'Kasparov - Magnus Carlsen');

			-------------Nje subquery qe tregon titullin e ndeshjes te cilen do ta ndjek shikuesi me ate ID--------------------
		SELECT Titulli
			FROM Ndeshja
			WHERE IDNdeshja IN (SELECT IDNdeshja
								FROM ShikuesiShikonNdeshjen
								WHERE IDShikuesi = 1);


			-------------Nje subquery qe tregon emrin dhe mbiemrin e stafit te cilet paguhen me shume sesa nje vlere--------------------

		SELECT Emri, Mbiemri 
			FROM Stafi 
			WHERE IDStafi IN (
			  SELECT Stafi 
			  FROM Pagesa 
			  WHERE sasiaPageses > 1000
		)
							

			-------------Nje subquery qe tregon	emrat e organizuesve të ndeshjeve që kanë buxhet më të lartë se :	--------------------		
						
		SELECT Emri
			FROM Organizuesi
			WHERE IDOrganizuesi IN (
				SELECT IDOrganizuesi
				FROM Organizon
				WHERE IDNdeshja IN (
					SELECT IDNdeshja
					FROM Ndeshja
					WHERE Buxheti > 500000
				)
			)



---------------------------------------[Subquery të Avancuara]--------------------------------------------

	-------------Subquery në klauzolën SELECT:--------------------

	SELECT Titulli, Loja, Buxheti, 
	(SELECT COUNT(IDOrganizuesi) 
	FROM Organizon 
	WHERE Organizon.IDNdeshja = Ndeshja.IDNdeshja) AS NumriOrganizuesve 
	FROM Ndeshja;

	-------------Subquery në klauzolën FORM:--------------------

	SELECT Titulli, Loja, Buxheti
	FROM Ndeshja
	WHERE IDNdeshja IN (SELECT IDNdeshja FROM Organizon WHERE IDOrganizuesi = (SELECT IDOrganizuesi FROM Organizuesi WHERE Emri = 'UEFA'))


	-------------Subquery në klauzolën WHERE :--------------------

	SELECT  Data, kohaFillimit, kohaMbarimit 
	FROM OrariNdeshjes
	WHERE Data > (SELECT MIN(Data)
					FROM OrariNdeshjes)

	-------------Subquery në klauzolën HAVING :--------------------
	SELECT Loja, AVG(Buxheti) as MesatarjaBuxhetit
	FROM Ndeshja
	GROUP BY Loja
	HAVING AVG(Buxheti) > (SELECT AVG(Buxheti)
							FROM Ndeshja)

	-------------Subquery në klauzolën WHERE dhe JOIN:--------------------
	
	SELECT Titulli, Ndeshja.Loja, Emri
	FROM Ndeshja
	JOIN Organizon ON Ndeshja.IDNdeshja = Organizon.IDNdeshja
	JOIN Organizuesi ON Organizon.IDOrganizuesi = Organizuesi.IDOrganizuesi
	WHERE Organizuesi.Sheti = 'Kosova' AND Ndeshja.Buxheti > 50000

	-------------Subquery në klauzolën SELECT dhe JOIN:--------------------

	SELECT Titulli, Loja, (SELECT SUM(Buxheti) FROM Ndeshja) as TotaliBuxhetit,
	(SELECT COUNT(IDNdeshja) FROM OrariNdeshjes WHERE Data = '2023-5-12') as 
	NumriNdeshjeveNeDaten2023
	FROM Ndeshja


	-------------Subquery në klauzolën WHERE:--------------------

	SELECT Loja, COUNT(IDNdeshja) as NumriNdeshjeve
	FROM Ndeshja
	WHERE Buxheti > (SELECT AVG(Buxheti) FROM Ndeshja)
	GROUP BY Loja



---------------------------------------[query/Subquery duke perdorur operacionet e algjebrës relacionale ]--------------------------------------------


	---------------UNION--------------------
	SELECT Emri FROM Shikuesi
	WHERE Gjinia = 'M'

	UNION

	SELECT Emri FROM Shikuesi
	WHERE Gjinia = 'F'
	--------------UNION: Merr të gjithë organizuesit që kanë organizuar ndeshje futbolli dhe ndeshje të tjera:--------------------
	SELECT Emri, Rruga, ZIPCode, Sheti
	FROM Organizuesi
	WHERE IDOrganizuesi IN (
		SELECT IDOrganizuesi
		FROM Organizon
		WHERE IDNdeshja IN (
			SELECT IDNdeshja
			FROM Ndeshja
			WHERE Loja = 'Futboll'
		)
		UNION
		SELECT IDOrganizuesi
		FROM Organizon
		WHERE IDNdeshja IN (
			SELECT IDNdeshja
			FROM Ndeshja
			WHERE Loja != 'Futboll'
		)
	);

	---------------INTERSECT:Shfaq të gjitha rreshtat që janë të përbashkëta në të dy kërkimet --------------------
	SELECT Emri FROM Shikuesi
	WHERE Mosha > 25

	INTERSECT

	SELECT Emri FROM Shikuesi
	WHERE Ndihma = 1
	---------------Intersection: Merr të gjithë shikuesit që kanë shikuar ndeshje futbolli dhe ndeshje të tjera:--------------------

	SELECT Emri, Mbiemri, Gjinia, Mosha, Ndihma, Rruga, ZIPCode, Shteti, Vendbanimi
	FROM Shikuesi
	WHERE IDShikuesi IN (
		SELECT IDShikuesi
		FROM ShikuesiShikonNdeshjen
		WHERE IDNdeshja IN (
			SELECT IDNdeshja
			FROM Ndeshja
			WHERE Loja = 'Futboll'
		)
		INTERSECT
		SELECT IDShikuesi
		FROM ShikuesiShikonNdeshjen
		WHERE IDNdeshja IN (
			SELECT IDNdeshja
			FROM Ndeshja
			WHERE Loja != 'Futboll'
		)
	);

	

	---------------EXCEPT: Shfaq te gjithe Shikuesit nga Kosova por jo nga Koretini--------------------
	SELECT Emri FROM Shikuesi
	WHERE Shteti = 'Kosova'

	EXCEPT

	SELECT Emri FROM Shikuesi
	WHERE Vendbanimi = 'Koretin'



	---------------Except: Merr të gjithë organizuesit që kanë organizuar ndeshje futbolli por jo ndeshje të tjera:--------------------
	SELECT Emri, Rruga, ZIPCode, Sheti
	FROM Organizuesi
	WHERE IDOrganizuesi IN (
		SELECT IDOrganizuesi
		FROM Organizon
		WHERE IDNdeshja IN (
			SELECT IDNdeshja
			FROM Ndeshja
			WHERE Loja = 'Futboll'
		)
		EXCEPT
		SELECT IDOrganizuesi
		FROM Organizon
		WHERE IDNdeshja IN (
			SELECT IDNdeshja
			FROM Ndeshja
			WHERE Loja != 'Futboll'
		)
	);

	---------------INTERSECT --------------------

	SELECT Emri, Mbiemri, Gjinia, Mosha
	FROM Shikuesi
	WHERE Mosha > 20

	INTERSECT

	SELECT Emri, Mbiemri, Gjinia, Mosha
	FROM Shikuesi
	WHERE Gjinia = 'M'
	
	---------------EXCEPT --------------------
	SELECT Titulli, Loja, Buxheti
	FROM Ndeshja
	WHERE Loja = 'Futboll'

	EXCEPT

	SELECT Titulli, Loja, Buxheti
	FROM Ndeshja
	WHERE Buxheti < 50000;

	


---------------------------------------[Proceduara të ruajtura]--------------------------------------------

	---------------Procedure e definuar nga perdoruesi --------------------
	CREATE PROCEDURE GetShikuesin
	AS
	BEGIN
	SET NOCOUNT ON
	SELECT Emri, Mbiemri, Mosha
	FROM Shikuesi
	END

	exec GetShikuesin
	
	---------------Procedura e ruajtur me parametra input dhe output : -------------------------------------

	CREATE PROCEDURE GetOrganizuesi (@Emri varchar(50), @IDOrganizuesi int OUTPUT)
	AS
	BEGIN
		SELECT @IDOrganizuesi = IDOrganizuesi
		FROM Organizuesi
		WHERE Emri = @Emri

		PRINT @IDOrganizuesi;
		RETURN @IDOrganizuesi;
	END

	DECLARE @IDOrganizuesi INT;
	EXEC GetOrganizuesi @Emri = 'FIFA', @IDOrganizuesi = @IDOrganizuesi OUTPUT

	Select * From Organizuesi
	
	
	-------------Procedure qe kalkulon qmimin total me parametra input dhe output-----------------
	
	CREATE PROCEDURE CalculateTotal (@Shikuesi INT, @Qmimi DECIMAL(18,2), @Total DECIMAL(18,2) OUTPUT)
	AS
	BEGIN
	SET NOCOUNT ON;
	SET @Total = @Shikuesi * @Qmimi;
	END;

	DECLARE @Total DECIMAL(18,2);
	EXEC CalculateTotal @Shikuesi = 5, @Qmimi = 20, @Total = @Total OUTPUT;
	PRINT @Total;


	------------Procedure me parametra input--------------
	create PROCEDURE spGetOrganizuesiSipasLojes_OSE_Buxhetit
	@Loja Varchar(20),
	@Bugjeti int
	AS
	BEGIN
	SET NOCOUNT ON
	SELECT Titulli,Loja, Buxheti
	FROM Ndeshja
	WHERE Loja=@Loja OR Buxheti=@Bugjeti
	END

	EXEC spGetOrganizuesiSipasLojes_OSE_Buxhetit 'Boks', 1900; 


--------------------------Procedure duke perdorur (if,else)----------------------

CREATE PROCEDURE spPagesa
  @IDPagesa VARCHAR(10),
  @Stafi INT,
  @SasiaPageses MONEY,
  @DEPData DATE,
  @DEPOra TIME(0)
AS
BEGIN
  SET NOCOUNT ON;

  IF @SasiaPageses > 1000
  BEGIN
    INSERT INTO Pagesa (IDPagesa, Stafi, SasiaPageses, DEPData, DEPOra)
    VALUES (@IDPagesa, @Stafi, @SasiaPageses, @DEPData, @DEPOra);
  END
  ELSE
  BEGIN
    PRINT 'Shuma e pagesës është e ulët';
  END;
END;

EXEC spPagesa 'MenagjeriRI', 44, 450, '2023-01-01', '10:00:00';

--------------------------Procedure duke perdorur (if,else,case)----------------------------------------

CREATE PROCEDURE spInsertOrariPunes
	@IDOrariPunes VARCHAR(20),
	@SllotiKohor CHAR(8),
	@Fillon TIME(0),
	@Mbaron TIME(0)
	AS
	BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM OrariPunes WHERE IDOrariPunes = @IDOrariPunes)
	BEGIN
	IF @SllotiKohor IN ('Paradite', 'Pasdite')
	BEGIN
	IF @Fillon < @Mbaron
	BEGIN
	INSERT INTO OrariPunes (IDOrariPunes, SllotiKohor, Fillon, Mbaron)
	VALUES (@IDOrariPunes, @SllotiKohor, @Fillon, @Mbaron);
		PRINT 'Orari i punes u krijua me sukses.';
	  END
	  ELSE
	  BEGIN
		PRINT 'Ora e nisjes eshte me e madhe ose e njejte me ore e perfundimit.';
	  END;
	END
	ELSE
	BEGIN
	  PRINT 'Slloti Kohor i jepet gabim.';
	END;
	END
	ELSE
	BEGIN
	PRINT 'Orari i punes me kete IDOrariPunes tashme ekziston.';
	END;

	DECLARE @Shift VARCHAR(20) = 'Unknown';

		SET @Shift = 
	CASE 
	WHEN @SllotiKohor = 'Paradite' THEN 'Morning'
	WHEN @SllotiKohor = 'Pasdite' THEN 'Afternoon'
	ELSE 'Unknown'
	END;

	PRINT 'Shift: ' + @Shift;
	END;

	EXEC spInsertOrariPunes 'TINI', 'Paradite', '20:00:00', '18:00:00';

	----------------------Procedure duke perdorur (if,else)----------------------------------


CREATE PROCEDURE spInsertShkallaPageses
	@IDShkalla CHAR(3),
	@Pozita VARCHAR(20),
	@PagaMin MONEY,
	@PagaMax MONEY
	AS
		BEGIN
		SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM shkallaPageses WHERE IDShkalla = @IDShkalla)
		BEGIN
	IF (@PagaMin < @PagaMax)
		BEGIN
		INSERT INTO shkallaPageses (IDShkalla, Pozita, PagaMin, PagaMax)
		VALUES (@IDShkalla, @Pozita, @PagaMin, @PagaMax);
			PRINT 'Shkalla e pageses u krijua me sukses.';
	END
	ELSE
		BEGIN
			PRINT 'Paga min eshte me e madhe ose e njejte me pagen max.';
		END;
		END
	ELSE
		BEGIN
			PRINT 'Shkalla e pageses me kete IDShkalla tashme ekziston.';
		END;
		END;

	EXEC spInsertShkallaPageses 'S2', 'Sigurimi', 450, 500; 

	Select * From shkallaPageses

	
	----------------------Procedure duke perdorur (while,if,else)----------------------------------


	CREATE PROCEDURE spInsertNumriTelefonitShikuesit
	@IDShikuesi INT,
	@NumriTelefonit CHAR(20)
	AS
	BEGIN
	SET NOCOUNT ON;
	DECLARE @count INT = 0;
	WHILE @count < 5
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM nrTelefonitShikuesit WHERE NumriTelefonit = @NumriTelefonit)
	BEGIN
	INSERT INTO nrTelefonitShikuesit (IDShikuesi, NumriTelefonit)
	VALUES (@IDShikuesi, @NumriTelefonit);
		PRINT 'Numri i telefonit u krijua me sukses per shikuesin me ID ';
		SET @count = 1;
	  END
	  ELSE
	  BEGIN
		PRINT 'Numri i telefonit ekziston në sistem. Provo të jepni një numër tjetër.';
		SET @count = @count + 1;
	  END;
	END;
	END;

	EXEC spInsertNumriTelefonitShikuesit 1, '+383 45 911 120';




	



	----ndeshjet qe organizojem nga organizuesei

	select org.IDOrganizuesi , Count(org.Emri)as NumriOrganizuesve 
	from Ndeshja n , Organizuesi org , Organizon o
	where n.IDNdeshja = o.IDNdeshja and org.IDOrganizuesi = o.IDOrganizuesi
	Group by org.IDOrganizuesi
	Having Count(Org.Emri)>1
	 


	


	


	
