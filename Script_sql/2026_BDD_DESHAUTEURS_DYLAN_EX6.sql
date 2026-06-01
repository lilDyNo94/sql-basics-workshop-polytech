-- ===================================================
-- Exercice 6 : Requêtes avancées sur les données existantes
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================

-- 1. [Streamers ayant au moins un défi]
-- On utilise un INNER JOIN pour exclure automatiquement ceux qui ont 0 défi.
SELECT 
    str.pseudo, 
    COUNT(pd.id_defi) AS nombre_defis
FROM Streamer str
INNER JOIN Participation_Defi pd ON str.id_streamer = pd.id_streamer
GROUP BY str.id_streamer, str.pseudo;


-- 2. [Défis n'ayant aucun participant]
-- On utilise LEFT JOIN et on cherche les correspondances "vides" (IS NULL)
SELECT 
    d.intitule,  
    d.montant_palier
FROM Defi d
LEFT JOIN Participation_Defi pd ON d.id_defi = pd.id_defi
WHERE pd.id_streamer IS NULL;


-- 3. [Défis ayant plus de 2 streamers participants]
-- Utilisation du COALESCE couplé à la clause HAVING
SELECT 
    d.intitule, 
    d.montant_palier, 
    COALESCE(COUNT(pd.id_streamer), 0) AS nombre_participants
FROM Defi d
LEFT JOIN Participation_Defi pd ON d.id_defi = pd.id_defi
GROUP BY d.id_defi, d.intitule, d.montant_palier
HAVING COUNT(pd.id_streamer) > 2;


-- 4. [Nombre de défis par streamer avec le montant total engagé]
-- On croise 3 tables pour lier le Streamer au montant de ses défis
SELECT 
    str.pseudo, 
    COUNT(pd.id_defi) AS nombre_defis, 
    SUM(d.montant_palier) AS montant_total_paliers
FROM Streamer str
INNER JOIN Participation_Defi pd ON str.id_streamer = pd.id_streamer
INNER JOIN Defi d ON pd.id_defi = d.id_defi
GROUP BY str.id_streamer, str.pseudo
ORDER BY montant_total_paliers DESC;


-- 5. [Streamers et créneaux avec nombre de streams effectués par créneau]
-- On part des Streamers et Créneaux (INNER JOIN), puis on compte les Streams (LEFT JOIN).
SELECT 
    str.pseudo, 
    c.date_debut_autorisee, 
    c.date_fin_autorisee,
    COUNT(s.id_stream) AS nombre_streams
FROM Streamer str
INNER JOIN Creneau c ON str.id_streamer = c.id_streamer
LEFT JOIN Stream s ON c.id_creneau = s.id_creneau
GROUP BY str.id_streamer, str.pseudo, c.id_creneau, c.date_debut_autorisee, c.date_fin_autorisee;