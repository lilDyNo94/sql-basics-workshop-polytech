-- ===================================================
-- Exercice 2 : Requêtes SELECT simples et filtrées
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================

-- 1. [Tous les streamers avec leur URL Twitch, ordonnés par pseudo]
-- On sélectionne les colonnes spécifiques et on trie par ordre alphabétique (ASC)
SELECT pseudo, url_twitch 
FROM Streamer 
ORDER BY pseudo ASC;


-- 2. [Les créneaux du samedi 06 septembre 2026]
-- La fonction DATE() permet d'ignorer l'heure et de ne filtrer que sur le jour.
-- (Recherche sur 2026 pour correspondre aux données insérées à l'Exercice 1)
SELECT * FROM Creneau 
WHERE DATE(date_debut_autorisee) = '2026-09-06';


-- 3. [Les défis validés ayant un montant palier strictement supérieur à 5000 €]
SELECT * FROM Defi 
WHERE etat_validation = TRUE 
  AND montant_palier > 5000.00;


-- 4. [Les streams non terminés (date de fin effective est NULL)]
SELECT * FROM Stream 
WHERE date_fin_effective IS NULL;