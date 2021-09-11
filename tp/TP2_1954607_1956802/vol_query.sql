SET search_path=VolDB;

/* 4.a */
SELECT * FROM aeroport;

/* 4.b */
SELECT * FROM Vol WHERE NoVol=121;

/* 4.c */
SELECT noVol,raison FROM Annulation;

/* 4.d */
SELECT * FROM Passager p1 WHERE
p1.NoPassager=(SELECT r.NoClient FROM Reservation r WHERE
r.NoReservation=(SELECT rv.NoReservation FROM ReservationVol rv WHERE 
rv.NoVol=(SELECT v.NoVol FROM Vol v WHERE 
v.DateDepart='2020-01-03'
AND
v.DateArrive='2020-01-03'
AND
v.AeroportDepart=(SELECT CodeAeroport FROM Aeroport WHERE Ville='Montreal')
AND
v.AeroportArrive=(SELECT CodeAeroport FROM Aeroport WHERE Ville='Rabat'))));

/* 4.e */
SELECT COUNT(*) AS nbAvionBoeing FROM Avion a1 WHERE 
a1.Fabricant='Boeing' AND a1.Modele='737';

/* 4.f */
SELECT AVG(t1.nbPassager) FROM 
(SELECT COUNT(b.NoPassager) AS nbPassager FROM Billet b GROUP BY b.NoReservation) t1;

/* 4.g */
SELECT COUNT(r1.NoVol) FROM Responsabilite r1 WHERE
r1.NoEmploye=(SELECT r.NoEmploye FROM Responsabilite r WHERE 
r.NoEmploye=(SELECT p1.NoEmploye FROM Pilote p1 WHERE p1.NoLicense='FSU' ));

/* 4.h */
SELECT NoVol,Raison FROM Retard;

/* 4.i */
SELECT en.DateEnregistrement,en.Heure FROM EnregistrementBagage en WHERE
en.NoEnregistrement=(SELECT bv.NoEnregistrement FROM BagageVol bv WHERE
bv.NoVol=123 AND bv.NoPassager=15);

/* 4.j */
SELECT COUNT(*) FROM Vol v WHERE 
v.AeroportDepart=(SELECT CodeAeroport FROM Aeroport WHERE Ville='Montreal')
OR 
v.AeroportArrive=(SELECT CodeAeroport FROM Aeroport WHERE Ville='Montreal');
