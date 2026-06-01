-- ===================================================
-- EXERCICE 0 : Création de la base de données (DDL)
-- Réalisé par : Dylan Deshauteurs
-- Date : 18/05/2026
-- ===================================================

-- 1. Création de la table Streamer
CREATE TABLE Streamer(
   Id_streamer SERIAL,
   pseudo VARCHAR(50),
   url_twitch VARCHAR(50), 
   PRIMARY KEY(Id_streamer),
   UNIQUE(pseudo)
);

-- 2. Création de la table Créneau 
CREATE TABLE Créneau(
   Id_creneau SERIAL,
   date_debut_autorisee TIMESTAMP,
   date_fin_autorisee TIMESTAMP,
   Id_streamer INT NOT NULL,
   PRIMARY KEY(Id_creneau),
   FOREIGN KEY(Id_streamer) REFERENCES Streamer(Id_streamer)
);

-- 3. Création de la table Stream 
CREATE TABLE Stream(
   Id_stream SERIAL,
   titre VARCHAR(50),
   heure_debut TIMESTAMP,
   heure_fin TIMESTAMP,
   -- Type TIME généré au lieu de TIMESTAMP, 
   -- Contrainte NOT NULL ajoutée par défaut par le logiciel
   date_fin_effective TIME NOT NULL, 
   Id_creneau INT NOT NULL,
   Id_streamer INT NOT NULL,
   PRIMARY KEY(Id_stream),
   FOREIGN KEY(Id_creneau) REFERENCES Créneau(Id_creneau),
   FOREIGN KEY(Id_streamer) REFERENCES Streamer(Id_streamer)
);

-- 4. Création de la table Défi 
CREATE TABLE Défi(
   Id_defi SERIAL,
   intitule VARCHAR(50),
   montant_palier DECIMAL(12,2),
   -- Type générique "LOGICAL" propre à Looping 
   etat_validation LOGICAL, 
   PRIMARY KEY(Id_defi)
);

-- 5. Création de la table de liaison Participation_Defi
CREATE TABLE Participation_Defi(
   Id_streamer INT,
   Id_defi INT,
   PRIMARY KEY(Id_streamer, Id_defi),
   FOREIGN KEY(Id_streamer) REFERENCES Streamer(Id_streamer),
   FOREIGN KEY(Id_defi) REFERENCES Défi(Id_defi)
);