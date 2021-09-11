SET search_path=VolDB;

CREATE SCHEMA IF NOT EXISTS VolDB;

CREATE TABLE IF NOT EXISTS VolDB.Client(
	NoClient NUMERIC NOT NULL,
	NomClient VARCHAR(20) NOT NULL, 
	PrenomClient VARCHAR(20) NOT NULL,
    PRIMARY KEY(NoClient)
);

CREATE TABLE IF NOT EXISTS VolDB.Avion(
    NoAppareil NUMERIC NOT NULL,
	Fabricant VARCHAR(20) NOT NULL,
	Modele VARCHAR(10) NOT NULL,
	DateAcquisition DATE NOT NULL,
	NombreDeSiege NUMERIC NOT NULL,
	PRIMARY KEY(NoAppareil)
);

CREATE TABLE IF NOT EXISTS VolDB.Aeroport(
   CodeAeroport VARCHAR(3) NOT NULL,
   Ville VARCHAR(20) NOT NULL,
   PRIMARY KEY(CodeAeroport)
);

CREATE TABLE IF NOT EXISTS VolDB.Vol(
   NoVol NUMERIC NOT NULL,
   DateDepart DATE NOT NULL,
   HeureDepart TIME NOT NULL,
   DateArrive DATE NOT NULL,
   HeureArrive TIME NOT NULL,
   NoAvion NUMERIC NOT NULL,
   AeroportDepart VARCHAR(3) NOT NULL,
   AeroportArrive VARCHAR(3) NOT NULL,
   PRIMARY KEY(NoVol),
   FOREIGN KEY(NoAvion) REFERENCES Avion(NoAppareil),
   FOREIGN KEY(AeroportDepart) REFERENCES Aeroport(CodeAeroport),
   FOREIGN KEY(AeroportArrive) REFERENCES Aeroport(CodeAeroport),
   CHECK(DateDepart=DateArrive OR DateDepart<DateArrive)
);

CREATE TABLE IF NOT EXISTS VolDB.Annulation(
    NoAnnulation NUMERIC NOT NULL,
    Raison VARCHAR(20),
	NoVol NUMERIC NOT NULL,
	PRIMARY KEY(NoAnnulation),
	FOREIGN KEY(NoVol) REFERENCES Vol(NoVol)
);

CREATE TABLE IF NOT EXISTS VolDB.Retard(
    NoRetard NUMERIC NOT NULL,
	MinuteDepart NUMERIC NOT NULL,
	MinuteArrive NUMERIC NOT NULL,
	Raison VARCHAR(20) NOT NULL,
	NoVol NUMERIC NOT NULL,
	PRIMARY KEY(NoRetard),
	FOREIGN KEY(NoVol) REFERENCES Vol(NoVol)
);


CREATE TABLE IF NOT EXISTS VolDB.Passager(
   NoPassager NUMERIC NOT NULL,
   NomPassager VARCHAR(20) NOT NULL,
   PrenomPassager VARCHAR(20) NOT NULL,
   Sexe CHAR(1) NOT NULL,
   PRIMARY KEY(NoPassager),
   CHECK (Sexe IN ('M','F'))
);

CREATE TABLE IF NOT EXISTS VolDB.Bagage(
   NoBagage NUMERIC NOT NULL,
   PRIMARY KEY(NoBagage)
);


CREATE TABLE IF NOT EXISTS VolDB.Employe(
   NoEmploye NUMERIC NOT NULL,
   NomEmploye VARCHAR(20) NOT NULL,
   PrenomEmploye VARCHAR(20) NOT NULL,
   DateEmbauche DATE NOT NULL,
   PRIMARY KEY(NoEmploye)
);

CREATE TABLE IF NOT EXISTS VolDB.Pilote(
   NoEmploye NUMERIC NOT NULL,
   NoLicense VARCHAR(3) NOT NULL,
   DateObtention DATE NOT NULL,
   PRIMARY KEY(NoEmploye),
   FOREIGN KEY(NoEmploye) REFERENCES Employe(NoEmploye)
);

CREATE TABLE IF NOT EXISTS VolDB.Siege(   /* composition de l'avion */
   NoSiege NUMERIC NOT NULL,
   Classe VARCHAR(10) NOT NULL,
   NoAvion NUMERIC,
   PRIMARY KEY(NoSiege),
   FOREIGN KEY(NoAvion) REFERENCES Avion(NoAppareil) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS VolDB.Tarif(
   CodeTarif VARCHAR(10) NOT NULL,
   Cond VARCHAR(15) NOT NULL,
   PRIMARY KEY(CodeTarif)
);

CREATE TABLE IF NOT EXISTS VolDB.CarteDeCredit(
   NoCarte NUMERIC NOT NULL,
   Expiration DATE NOT NULL,
   NomDuTitulaire VARCHAR(20) NOT NULL,
   PRIMARY KEY(NoCarte)
);

CREATE TABLE IF NOT EXISTS VolDB.Reservation(
    NoReservation NUMERIC NOT NULL,
    DateReservation DATE NOT NULL,
	PrixTotal NUMERIC NOT NULL,
	PaiementEffectue BIT NOT NULL,
	NoClient NUMERIC NOT NULL,
	PRIMARY KEY(NoReservation),
	FOREIGN KEY(NoClient) REFERENCES Client(NoClient)
);

CREATE TABLE IF NOT EXISTS VolDB.ReservationVol(
    NoReservation NUMERIC NOT NULL,
	NoVol NUMERIC NOT NULL,
	CodeTarif VARCHAR(10) NOT NULL,
	PRIMARY KEY(NoReservation,NoVol,CodeTarif),
	FOREIGN KEY(NoReservation) REFERENCES Reservation(NoReservation),
	FOREIGN KEY(NoVol) REFERENCES Vol(NoVol),
	FOREIGN KEY(CodeTarif) REFERENCES Tarif(CodeTarif)
);

CREATE TABLE IF NOT EXISTS VolDB.Billet(
   NoBillet NUMERIC NOT NULL,
   NoPassager NUMERIC NOT NULL,
   NoReservation NUMERIC NOT NULL,
   PRIMARY KEY(NoBillet),
   FOREIGN KEY(NoPassager) REFERENCES Passager(NoPassager),
   FOREIGN KEY(NoReservation) REFERENCES Reservation(NoReservation)
);

CREATE TABLE IF NOT EXISTS VolDB.Paiement(
   NoPaiement NUMERIC NOT NULL,
   DatePaiement DATE NOT NULL,
   MontantPaiement NUMERIC NOT NULL,
   ModeDePaiement VARCHAR(20) NOT NULL,
   NoCarte NUMERIC,
   PRIMARY KEY(NoPaiement),
   FOREIGN KEY(NoPaiement) REFERENCES Reservation(NoReservation),
   FOREIGN KEY(NoCarte) REFERENCES CarteDeCredit(NoCarte)
);

CREATE TABLE IF NOT EXISTS VolDB.EnregistrementBagage(
    NoEnregistrement NUMERIC NOT NULL,
	DateEnregistrement DATE NOT NULL,
	Heure TIME NOT NULL,
	PRIMARY KEY(NoEnregistrement),
	FOREIGN KEY(NoEnregistrement) REFERENCES Bagage(NoBagage)
);

CREATE TABLE IF NOT EXISTS VolDB.Responsabilite(
    NoVol NUMERIC NOT NULL,
	NoEmploye NUMERIC NOT NULL,
	TypeResponsabilite VARCHAR(20) NOT NULL,
	PRIMARY KEY(NoVol,NoEmploye),
	FOREIGN KEY(NoVol) REFERENCES Vol(NoVol),
	FOREIGN KEY(NoEmploye) REFERENCES Employe(NoEmploye)
);

CREATE TABLE IF NOT EXISTS VolDB.BagageVol(
   NoPassager NUMERIC NOT NULL,
   NoVol NUMERIC NOT NULL,
   NoEnregistrement NUMERIC NOT NULL,
   PRIMARY KEY(NoPassager,NoVol,NoEnregistrement),
   FOREIGN KEY(NoPassager) REFERENCES Passager(NoPassager),
   FOREIGN KEY(NoVol) REFERENCES Vol(NoVol),
   FOREIGN KEY(NoEnregistrement) REFERENCES EnregistrementBagage(NoEnregistrement)
);






