-- ===================================================
-- Exercice 5 : Mises à jour (UPDATE) et suppressions (DELETE)
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================



-- ===================================================
-- Partie A : UPDATE
-- ===================================================

-- 1. [Modifier un montant palier]
UPDATE Defi
SET montant_palier = montant_palier * 1.10
WHERE intitule = 'Saut en parachute';


-- 2. [Valider tous les défis non validés ayant au moins 3 participants]
UPDATE Defi
SET etat_validation = TRUE
WHERE etat_validation = FALSE
  AND id_defi IN (
      SELECT id_defi 
      FROM Participation_Defi 
      GROUP BY id_defi 
      HAVING COUNT(id_streamer) >= 3
  );


-- ===================================================
-- Partie B : DELETE
-- ===================================================

-- 3. [Supprimer les streams non terminés]

DELETE FROM Stream
WHERE date_fin_effective IS NULL;


-- 4. [Supprimer les créneaux passés]
DELETE FROM Creneau
WHERE date_fin_autorisee < CURRENT_DATE;