-- ===================================================
-- Exercice 7 : Gestion des validations avec CASE
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================

-- ===================================================
-- Partie A : Validation des streams contre les créneaux
-- ===================================================

-- 1. [Afficher le statut VALIDE ou INVALIDE de tous les streams]
SELECT 
    s.titre,
    str.pseudo,
    c.date_debut_autorisee,
    c.date_fin_autorisee,
    s.heure_debut,
    s.heure_fin,
    CASE 
        WHEN s.heure_debut >= c.date_debut_autorisee AND s.heure_fin <= c.date_fin_autorisee THEN 'VALIDE'
        ELSE 'INVALIDE'
    END AS validation
FROM Stream s
INNER JOIN Creneau c ON s.id_creneau = c.id_creneau
INNER JOIN Streamer str ON s.id_streamer = str.id_streamer;


-- 2. [Identifier uniquement les streams invalides]
SELECT 
    s.titre,
    str.pseudo,
    CASE 
        WHEN s.heure_debut >= c.date_debut_autorisee AND s.heure_fin <= c.date_fin_autorisee THEN 'VALIDE'
        ELSE 'INVALIDE'
    END AS validation
FROM Stream s
INNER JOIN Creneau c ON s.id_creneau = c.id_creneau
INNER JOIN Streamer str ON s.id_streamer = str.id_streamer
WHERE (s.heure_debut < c.date_debut_autorisee OR s.heure_fin > c.date_fin_autorisee);


-- ===================================================
-- Partie B : Détection des dépassements de fin
-- ===================================================

-- 3. [Détection des dépassements et calcul du retard en minutes]
SELECT 
    s.titre,
    str.pseudo,
    s.heure_fin,
    s.date_fin_effective,
    CASE 
        WHEN s.date_fin_effective > s.heure_fin THEN 'DEPASSEMENT'
        ELSE 'OK'
    END AS statut,
    CASE 
        WHEN s.date_fin_effective > s.heure_fin THEN EXTRACT(EPOCH FROM (s.date_fin_effective - s.heure_fin)) / 60
        ELSE 0
    END AS retard_minutes
FROM Stream s
INNER JOIN Streamer str ON s.id_streamer = str.id_streamer;


-- 4. [Résumé : Nombre de streams en retard et moyenne des retards]
SELECT 
    COUNT(id_stream) AS nb_streams_en_retard,
    ROUND(AVG(EXTRACT(EPOCH FROM (date_fin_effective - heure_fin)) / 60)::numeric, 2) AS duree_moyenne_retard_minutes
FROM Stream
WHERE date_fin_effective > heure_fin;


-- ===================================================
-- Conclusion : Vue combinée (Conformité Globale)
-- ===================================================

-- 5. [Aperçu complet combinant créneaux et dépassements]
SELECT 
    s.titre,
    str.pseudo,
    CASE 
        WHEN s.heure_debut >= c.date_debut_autorisee AND s.heure_fin <= c.date_fin_autorisee THEN 'VALIDE'
        ELSE 'INVALIDE'
    END AS respect_creneau,
    CASE 
        WHEN s.date_fin_effective > s.heure_fin THEN 'DEPASSEMENT'
        ELSE 'OK'
    END AS respect_horaire_fin,
    CASE 
        WHEN s.date_fin_effective > s.heure_fin THEN EXTRACT(EPOCH FROM (s.date_fin_effective - s.heure_fin)) / 60
        ELSE 0
    END AS retard_minutes
FROM Stream s
INNER JOIN Creneau c ON s.id_creneau = c.id_creneau
INNER JOIN Streamer str ON s.id_streamer = str.id_streamer;