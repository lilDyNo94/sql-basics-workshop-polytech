-- ===================================================
-- EXERCICE 1 : Création et Population de la base
-- Réalisé par : Dylan Deshauteurs
-- Date : 18/05/2026
-- ===================================================

-- Nettoyage des anciennes tables si elles existent pour éviter les doublons
DROP TABLE IF EXISTS Participation_Defi CASCADE;
DROP TABLE IF EXISTS Stream CASCADE;
DROP TABLE IF EXISTS Creneau CASCADE;
DROP TABLE IF EXISTS Defi CASCADE;
DROP TABLE IF EXISTS Streamer CASCADE;

-- 1. Création de la table Streamer
CREATE TABLE Streamer (
    id_streamer SERIAL,
    pseudo VARCHAR(50) NOT NULL UNIQUE,
    url_twitch VARCHAR(150),
    PRIMARY KEY (id_streamer)
);

-- 2. Création de la table Creneau
CREATE TABLE Creneau (
    id_creneau SERIAL,
    date_debut_autorisee TIMESTAMP NOT NULL,
    date_fin_autorisee TIMESTAMP NOT NULL,
    id_streamer INT NOT NULL,
    PRIMARY KEY (id_creneau),
    FOREIGN KEY (id_streamer) REFERENCES Streamer(id_streamer) ON DELETE CASCADE
);

-- 3. Création de la table Stream
CREATE TABLE Stream (
    id_stream SERIAL,
    titre VARCHAR(100) NOT NULL,
    heure_debut TIMESTAMP NOT NULL,
    heure_fin TIMESTAMP NOT NULL,
    date_fin_effective TIMESTAMP, -- Reste NULL si le stream n'est pas terminé
    id_creneau INT NOT NULL,
    id_streamer INT NOT NULL,
    PRIMARY KEY (id_stream),
    FOREIGN KEY (id_creneau) REFERENCES Creneau(id_creneau) ON DELETE CASCADE,
    FOREIGN KEY (id_streamer) REFERENCES Streamer(id_streamer) ON DELETE CASCADE
);

-- 4. Création de la table Defi
CREATE TABLE Defi (
    id_defi SERIAL,
    intitule VARCHAR(150) NOT NULL,
    montant_palier DECIMAL(12,2) NOT NULL,
    etat_validation BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id_defi)
);

-- 5. Création de la table de liaison Participation_Defi
CREATE TABLE Participation_Defi (
    id_streamer INT NOT NULL,
    id_defi INT NOT NULL,
    PRIMARY KEY (id_streamer, id_defi),
    FOREIGN KEY (id_streamer) REFERENCES Streamer(id_streamer) ON DELETE CASCADE,
    FOREIGN KEY (id_defi) REFERENCES Defi(id_defi) ON DELETE CASCADE
);

-- ===================================================
-- POPULATION DES TABLES (Données de test)
-- ===================================================

-- Insérer les Streamers (10 lignes minimum)
INSERT INTO Streamer (pseudo, url_twitch) VALUES
('Zerator', 'https://twitch.tv/zerator'),
('MisterMV', 'https://twitch.tv/mistermv'),
('AntoineDaniel', 'https://twitch.tv/antoinedaniel'),
('Kameto', 'https://twitch.tv/kameto'),
('Etoiles', 'https://twitch.tv/etoiles'),
('Squeezie', 'https://twitch.tv/squeezie'),
('Gotaga', 'https://twitch.tv/gotaga'),
('Maghla', 'https://twitch.tv/maghla'),
('BagheraJones', 'https://twitch.tv/bagherajones'),
('Ponce', 'https://twitch.tv/ponce');

-- Insérer les Créneaux (2 à 3 par streamer)
INSERT INTO Creneau (date_debut_autorisee, date_fin_autorisee, id_streamer) VALUES
('2026-05-18 14:00:00', '2026-05-18 17:00:00', 1),
('2026-05-19 20:00:00', '2026-05-20 00:00:00', 1),
('2026-05-18 17:00:00', '2026-05-18 20:00:00', 2),
('2026-05-19 14:00:00', '2026-05-19 17:00:00', 2),
('2026-05-18 20:00:00', '2026-05-18 23:00:00', 3),
('2026-05-20 10:00:00', '2026-05-20 14:00:00', 3),
('2026-05-18 23:00:00', '2026-05-19 02:00:00', 4),
('2026-05-19 17:00:00', '2026-05-19 20:00:00', 5),
('2026-05-19 10:00:00', '2026-05-19 13:00:00', 6),
('2026-05-19 13:00:00', '2026-05-19 16:00:00', 7),
('2026-05-20 14:00:00', '2026-05-20 17:00:00', 8),
('2026-05-20 17:00:00', '2026-05-20 20:00:00', 9),
('2026-05-20 20:00:00', '2026-05-20 23:00:00', 10);

-- Insérer les Streams (10-15 lignes avec certains date_fin_effective à NULL)
INSERT INTO Stream (titre, heure_debut, heure_fin, date_fin_effective, id_creneau, id_streamer) VALUES
('Lancement du ZEvent !', '2026-05-18 14:05:00', '2026-05-18 16:55:00', '2026-05-18 16:55:00', 1, 1),
('Session Quiz Culture', '2026-05-19 20:00:00', '2026-05-20 00:00:00', NULL, 2, 1),
('Discussion et developpement', '2026-05-18 17:00:00', '2026-05-18 19:50:00', '2026-05-18 19:50:00', 3, 2),
('Slay the Spire tryhard', '2026-05-19 14:10:00', '2026-05-19 16:45:00', '2026-05-19 16:45:00', 4, 2),
('Geoguessr World Cup', '2026-05-18 20:00:00', '2026-05-18 22:55:00', '2026-05-18 22:55:00', 5, 3),
('Chrono Trigger randomizer', '2026-05-20 10:05:00', '2026-05-20 13:50:00', '2026-05-20 13:50:00', 6, 3),
('Debrief de la Kameto Corp', '2026-05-18 23:00:00', '2026-05-19 01:45:00', '2026-05-19 01:45:00', 7, 4),
('Questions pour un Streamer', '2026-05-19 17:00:00', '2026-05-19 20:00:00', NULL, 8, 5),
('On teste des jeux d horreur', '2026-05-19 10:15:00', '2026-05-19 12:45:00', '2026-05-19 12:45:00', 9, 6),
('Masterclass Shootem up', '2026-05-19 13:00:00', '2026-05-19 15:50:00', '2026-05-19 15:50:00', 10, 7),
('Sims 4 challenge', '2026-05-20 14:00:00', '2026-05-20 16:55:00', '2026-05-20 16:55:00', 11, 8),
('Multi Gaming fun', '2026-05-20 17:05:00', '2026-05-20 19:45:00', '2026-05-20 19:45:00', 12, 9);

-- Insérer les Défis (10 minimum, paliers variés)
INSERT INTO Defi (intitule, montant_palier, etat_validation) VALUES
('Teinture des cheveux en rouge', 500.00, true),
('Saut en parachute', 5000.00, false),
('Marathon 24h non-stop', 2000.00, true),
('Karaoké en direct', 750.00, true),
('Cuisiner un plat au piment fort', 300.00, true),
('Créer un mini-jeu en 48h', 10000.00, false),
('Cosplay improvisé', 1200.00, true),
('Faire un stream ASMR', 400.00, false),
('Inviter un viewer en duo', 1500.00, true),
('Raser la barbe en live', 3000.00, true);

-- Insérer les participations (15 lignes minimum, solo et groupe)
INSERT INTO Participation_Defi (id_streamer, id_defi) VALUES
(1, 1), (1, 2), 
(2, 2),          
(2, 3), (3, 3),  
(3, 4), (4, 4), 
(5, 5), (6, 6), 
(7, 7), (8, 7),  
(9, 8), (10, 9), 
(4, 10), (5, 10), (1, 10);