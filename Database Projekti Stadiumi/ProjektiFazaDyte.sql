create database Stadiumi

use Stadiumi

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
	Loja char(8),
	Buxheti money,

	constraint PKNdeshja primary key (IDNdeshja),
	constraint checkLLojiLojes check (Loja in ('Futboll','Voleyboll','Boks','Ping-pong','Shah'))

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
	NumriTelefonit char(20) unique, --funksionon per numra nga kosova

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
	Mbaron time(0) not null

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
	Mosha as convert(int, datediff(hour, Ditëlindja, getDate()))/8760, -- wip
	Orari varchar(20) not null,
	ShkallaPageses char(3),

	constraint StafiGjinia check (Gjinia in ('M','F','N')),
	constraint FKStafi1 foreign key (Orari) references OrariPunes (IDOrariPunes),
	constraint FKStafi2 foreign key (ShkallaPageses) references ShkallaPageses (IDShkalla),
	constraint PKStafi primary key (IDStafi)

)

create table nrTelefonitStafi (

	IDStafi int,
	NumriTelefonit char(20) unique,

	constraint FKStafiTelefoni foreign key (IDStafi) references Stafi (IDStafi),
	constraint PKnrTelefonitStafi primary key (IDStafi, NumriTelefonit)

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

----------------INSERTIMET NE TABLEA---------------------------


insert into Organizuesi values ('Santiago Bernabeu','Lagjja Kalabria', 10000, 'Kosova', 'Prishtinë')
insert into Organizuesi values ('Universiteti AAB', 'Lagjja Kalabria', 10000, 'Kosova', 'Prishtinë')
insert into Organizuesi values ('Interscope Records','2220 Colorado Ave, Santa Monica, CA', 14112, 'USA','California')
insert into Organizuesi values ('NFL','345 Park Avenue New York',10154,'USA','New York City')
insert into Organizuesi values ('Ultra Music Records','08005, Carrer de Pujades', 113,'Spanjë','Barcelona')
insert into Organizuesi values ('Universal Music Group','Hammersmith Rd, Hammersmith', 200,'UK','Londra')
insert into Organizuesi values ('Komuna e Prishtinës','UÇK-2',10000,'Kosova','Prishtinë')
insert into Organizuesi values ('Gjirafa','Magjistralja Prishtine - Ferizaj', 10000 ,'Kosova','Prishtinë')
insert into Organizuesi values ('Komuna e Kamenicës','Filizat ',60000,'Kosova','Kamenicë')
insert into Organizuesi values ('Komuna e Tetovës','Isa Mustafa, 12',50000,'Kosova','Gjakovë')
insert into Organizuesi values ('Komuna e Istogut','Hava e madhe, 34',33000,'Kosova','Istog')
insert into Organizuesi values ('Komuna e Gjilanit','Adem Jashari, 12 115',60000,'Kosova','Gjilan')
insert into Organizuesi values ('Devolli','Zahir Pajaziti, M9', 30000,'Kosova','Pejë')
insert into Organizuesi values ('Cineplexx','Albi Mall, Zona e re Industriale', 10000,'Kosova','Prishtinë')

insert into Ndeshja values ('Barcelona - Real Madrid', 'Futboll', 100000)
insert into Ndeshja values ('Chelsea - Aresnal','Futboll', 80000)
insert into Ndeshja values ('MC Gregor vs Khabibi', 'Boks', 750000)
insert into Ndeshja values ('KV-Kamenica vs KV-Gjilani','VoleyBoll', 3000)
insert into Ndeshja values ('Chicago Bulls - Boston Celtic ', 'Basketball', 50000)
insert into Ndeshja values ('Anglia - Spanja', 'Futboll', 80000)
insert into Ndeshja values ('Kosova - Shqiperia', 'Futboll', 2500)
insert into Ndeshja values ('Brazil - Argentina', 'Futboll', 3000000)
insert into Ndeshja values ('Golden State Warriors - Los Angeles Lakers', 'Basketball', 50000)
insert into Ndeshja values ('Ernesto Hoost - Ernesto Hoost','KickBox', 1500000)
insert into Ndeshja values ('''Talent Show'' 2021', 'Tjetër', 2500)

insert into OrariNdeshjes values (1,1,'2020-1-24','15:00','16:30')
insert into OrariNdeshjes values (2,1,'2021-5-12','20:00', '23:00')
insert into OrariNdeshjes values (2,2,'2021-5-13','21:00','00:00')
insert into OrariNdeshjes values (3,1,'2021-4-12','21:00','23:00')
insert into OrariNdeshjes values (3,2,'2021-4-15','21:00', '23:00')
insert into OrariNdeshjes values (3,3,'2021-4-22','21:00','23:00')
insert into OrariNdeshjes values (4,1,'2021-5-5','15:00','18:00')
insert into OrariNdeshjes values (5,1,'2021-2-13','21:00','23:00')
insert into OrariNdeshjes values (6,1,'2021-7-7','15:00','18:00')
insert into OrariNdeshjes values (6,2,'2021-7-9','07:00','10:00')
insert into OrariNdeshjes values (6,3,'2021-7-11','10:00','13:00')
insert into OrariNdeshjes values (6,4,'2021-7-13','21:00','23:00')
insert into OrariNdeshjes values (6,5,'2021-7-15','15:00','18:00')
insert into OrariNdeshjes values (6,6,'2021-7-17','15:00','18:00')
insert into OrariNdeshjes values (6,7,'2021-7-19','21:00','23:00')
insert into OrariNdeshjes values (6,8,'2021-7-21','12:00','15:00')
insert into OrariNdeshjes values (7,1,'2021-5-7','07:00','10:00')
insert into OrariNdeshjes values (8,1,'2021-11-15','15:00','18:00')
insert into OrariNdeshjes values (8,2,'2021-11-22','15:00','18:00')
insert into OrariNdeshjes values (9,1,'2021-9-12','12:00','15:00')
insert into OrariNdeshjes values (10,1,'2021-3-12','12:00','15:00')
insert into OrariNdeshjes values (10,2,'2021-3-13','12:00','15:00')
insert into OrariNdeshjes values (11,1,'2021-3-1','15:00','18:00')
insert into OrariNdeshjes values (11,2,'2021-6-1','15:00','18:00')
insert into OrariNdeshjes values (11,3,'2021-9-1','12:00','15:00')

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
insert into ShikuesiShikonNdeshjen values (9,3)
insert into ShikuesiShikonNdeshjen values (10,8)


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


	
	
	Rruga varchar(50),
	ZIPCode int,
	Shteti varchar(50) not null,
	Vendbanimi varchar(50),
	Mosha as convert(int, datediff(hour, Ditëlindja, getDate()))/8760, -- wip
	Orari varchar(20) not null,
	ShkallaPageses char(3),

insert into Stafi values ('Afrim', 'Dervishi', 'M', '1980-12-10','Rruga Bugaqaj',62000,'Kosove','Koretin','Menaxhues 1' , 'MP1')
insert into Stafi values ('Avdi', 'Sylejmani', 'M', '1979-12-10','Kosova /Prishtinë',62000,'Kosove','Koretin', 'Menaxhues 2' , 'MP2')
insert into Stafi values ('Feime', 'Syla', 'F', '1989-12-10','Kosova /Gjilan',62000,'Kosove','Koretin','Menaxhues 3' , 'MP3')
insert into Stafi values ('Sahadet', 'Sherifi', 'F', '1989-12-10','Kosova /Gjilan',62000,'Kosove','Koretin','Menaxhues 4' , 'MP4')
insert into Stafi values ('Blend', 'Canaj', 'M', '1999-12-10','Kosova /Gjilan',62000,'Kosove','Koretin','Sigurimi 1' , 'S1')
insert into Stafi values ('Erina', 'Haxhiu', 'F', '2000-12-10','Kosova /Gjakova',62000,'Kosove','Koretin','Ndihmës 1' , 'N1')
insert into Stafi values ('Olta', 'Dervishi', 'F', '2001-12-10','Kosova /Gjakova',62000,'Kosove','Koretin','Ndihmës 2' , 'N2')
insert into Stafi values ('Fatlum', 'Korqa', 'M', '1997-12-10','Kosova /Prizren',62000,'Kosove','Koretin','Mirëmbajtës 1' , 'MM1')
insert into Stafi values ('Flatron', 'Halimi', 'M', '1994-12-10','Kosova /Prishtine',62000,'Kosove','Koretin','Mirëmbajtës 2' , 'MM2')
insert into Stafi values ('Genc', 'Sadiku', 'M', '1991-12-10','Kosova /Prizren',62000,'Kosove','Koretin','Mirëmbajtës 3' , 'MM3')

insert into nrTelefonitStafi values (1,'+383 44 123 145')
insert into nrTelefonitStafi values (2,'+383 44 613 124')
insert into nrTelefonitStafi values (3,'+383 44 153 167')
insert into nrTelefonitStafi values (4,'+383 44 623 613')
insert into nrTelefonitStafi values (5,'+383 45 989 566')
insert into nrTelefonitStafi values (6,'+383 45 201 112')
insert into nrTelefonitStafi values (7,'+383 45 451 567')
insert into nrTelefonitStafi values (8,'+383 45 441 900')
insert into nrTelefonitStafi values (9,'+383 45 222 901')
insert into nrTelefonitStafi values (10,'+383 45 111 990')

insert into Menaxhues values (1,'CEO')
insert into Menaxhues values (2,'Shitje')
insert into Menaxhues values (3,'HR')
insert into Menaxhues values (4,'Marketing')

insert into Udhëzues values (5,'Shërbyes',5)
insert into Udhëzues values (6,'Recepsionist',5)


insert into Sigurimi values (7,4,7)

insert into Mirëmbajtës values (8,'IT',8)
insert into Mirëmbajtës values (9,'Pastrues',8)
insert into Mirëmbajtës values (10,'Inxhinier',8)

delete from MenaxheriRishikonOrganizimin

insert into MenaxheriRishikonOrganizimin values (1,1,1)
insert into MenaxheriRishikonOrganizimin values (1,1,2)

insert into MenaxheriRishikonOrganizimin values (1,2,3)
insert into MenaxheriRishikonOrganizimin values (1,2,7)

insert into MenaxheriRishikonOrganizimin values (1,3,3)

insert into MenaxheriRishikonOrganizimin values (1,4,8)
insert into MenaxheriRishikonOrganizimin values (1,4,11)
insert into MenaxheriRishikonOrganizimin values (1,4,12)
insert into MenaxheriRishikonOrganizimin values (1,4,13)
insert into MenaxheriRishikonOrganizimin values (1,4,14)

insert into MenaxheriRishikonOrganizimin values (2,1,1)
insert into MenaxheriRishikonOrganizimin values (2,1,2)

insert into MenaxheriRishikonOrganizimin values (2,2,3)
insert into MenaxheriRishikonOrganizimin values (2,2,4)

insert into MenaxheriRishikonOrganizimin values (2,3,3)

insert into MenaxheriRishikonOrganizimin values (2,4,8)
insert into MenaxheriRishikonOrganizimin values (2,4,11)
insert into MenaxheriRishikonOrganizimin values (2,4,12)
insert into MenaxheriRishikonOrganizimin values (2,4,13)
insert into MenaxheriRishikonOrganizimin values (2,4,14)

insert into MenaxheriRishikonOrganizimin values (2,9,2)

insert into MenaxheriRishikonOrganizimin values (2,10,4)
insert into MenaxheriRishikonOrganizimin values (2,10,8)

insert into MenaxheriRishikonOrganizimin values (3,1,1)
insert into MenaxheriRishikonOrganizimin values (3,1,2)

insert into MenaxheriRishikonOrganizimin values (3,11,8)
insert into MenaxheriRishikonOrganizimin values (3,11,9)
insert into MenaxheriRishikonOrganizimin values (3,11,11)
insert into MenaxheriRishikonOrganizimin values (3,11,12)
insert into MenaxheriRishikonOrganizimin values (3,11,13)

insert into MenaxheriRishikonOrganizimin values (4,11,8)
insert into MenaxheriRishikonOrganizimin values (4,11,9)
insert into MenaxheriRishikonOrganizimin values (4,11,11)
insert into MenaxheriRishikonOrganizimin values (4,11,12)
insert into MenaxheriRishikonOrganizimin values (4,11,13)

insert into Pagesa values ('PgM-1',1,4500,'2021-01-05','12:20:43')
insert into Pagesa values ('PgM-2',1,10000,'2020-12-05','16:51:05')
insert into Pagesa values ('PgM-3',2,6600,'2021-01-05','11:13:48')
insert into Pagesa values ('PgM-4',3,5100,'2021-01-05','19:13:57')
insert into Pagesa values ('PgM-5',4,5000,'2021-01-05','20:14:05')
insert into Pagesa values ('PgN-1',5,750,'2021-01-08','19:12:11')
insert into Pagesa values ('PgN-2',6,500,'2021-01-09','08:01:02')
insert into Pagesa values ('PgS-1',7,450,'2021-01-06','07:04:56')
insert into Pagesa values ('PgMM1',8,1200,'2021-01-04','14:05:44')
insert into Pagesa values ('PgMM2',9,400,'2021-01-04','15:55:32')
insert into Pagesa values ('PgMM3',10,1660,'2021-01-05','10:01:04')

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

------------------ Updates ------------------------

update Bileta
set Çmimi *= 1.10
where mënyraBlerjes = 1

update Bileta
set Çmimi = 5
where Bileta.Çmimi = 0

update Ndeshja
set Buxheti +=500

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
set IDNdeshja = 'Tjetër'
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
where IDStafi = 4


-------------------------------------------------[ DELETES ]-------------------------------------------------

delete from Bileta
where len(Bileta.Ulësja) is null --11 te dhena

delete from Bileta
where IDBileta = 1

delete from Ndeshja
where Titulli = 'Talent Show 2021'

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







