-- ===================================================
-- Exercice 3 : Requêtes de jointure simples
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================

-- 1. [Streamers et leurs créneaux]
-- On lie Streamer et Creneau. On trie d'abord par ordre alphabétique du pseudo, 
-- puis par ordre chronologique de la date de début.
SELECT str.pseudo, c.date_debut_autorisee, c.date_fin_autorisee
FROM Streamer str
INNER JOIN Creneau c ON str.id_streamer = c.id_streamer
ORDER BY str.pseudo ASC, c.date_debut_autorisee ASC;


-- 2. [Streams avec informations du streamer et du créneau]
-- On lie 3 tables ensemble. On filtre sur deux dates spécifiques.
SELECT s.titre, str.pseudo, c.date_debut_autorisee
FROM Stream s
INNER JOIN Streamer str ON s.id_streamer = str.id_streamer
INNER JOIN Creneau c ON s.id_creneau = c.id_creneau
WHERE DATE(c.date_debut_autorisee) IN ('2026-05-19', '2026-05-20');


-- 3. [Défis et leurs participants]
-- On part de Defi, on passe par la table de liaison Participation_Defi, 
-- pour enfin récupérer le pseudo dans la table Streamer.
SELECT d.intitule, str.pseudo, d.montant_palier
FROM Defi d
INNER JOIN Participation_Defi pd ON d.id_defi = pd.id_defi
INNER JOIN Streamer str ON pd.id_streamer = str.id_streamer;