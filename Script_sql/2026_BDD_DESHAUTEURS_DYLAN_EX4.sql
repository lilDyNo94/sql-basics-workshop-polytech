-- ===================================================
-- Exercice 4 : Agrégations et statistiques
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================

-- 1. [Nombre total de streams par streamer]
SELECT 
    str.pseudo, 
    COALESCE(COUNT(s.id_stream), 0) AS total_streams
FROM Streamer str
LEFT JOIN Stream s ON str.id_streamer = s.id_streamer
GROUP BY str.id_streamer, str.pseudo
ORDER BY total_streams DESC;


-- 2. [Montant total des paliers de défis par état de validation]
SELECT 
    etat_validation, 
    SUM(montant_palier) AS montant_total_paliers
FROM Defi
GROUP BY etat_validation;


-- 3. [Nombre de streamers ayant au moins 2 défis]
SELECT 
    str.pseudo, 
    COUNT(pd.id_defi) AS nombre_defis
FROM Streamer str
INNER JOIN Participation_Defi pd ON str.id_streamer = pd.id_streamer
GROUP BY str.id_streamer, str.pseudo
HAVING COUNT(pd.id_defi) >= 2;


-- 4. [Durée moyenne des streams (en heures)]
SELECT 
    titre,
    EXTRACT(EPOCH FROM (heure_fin - heure_debut)) / 3600 AS duree_stream_heures,
    AVG(EXTRACT(EPOCH FROM (heure_fin - heure_debut)) / 3600) OVER() AS duree_moyenne_globale
FROM Stream
WHERE heure_fin IS NOT NULL; 


-- 5. [Afficher uniquement les streamers qui ont effectivement lancé au moins un stream]
SELECT 
    str.pseudo, 
    s.titre, 
    s.heure_debut
FROM Streamer str
INNER JOIN Stream s ON str.id_streamer = s.id_streamer;