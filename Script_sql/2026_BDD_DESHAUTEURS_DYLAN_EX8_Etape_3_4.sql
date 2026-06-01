-- ===================================================
-- Exercice 8 (étape 3 & 4): Analyse de performance et création d'index
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================

-- ===================================================
-- ÉTAPE 3 & 4 : EXÉCUTION D'UNE REQUÊTE COMPLEXE SANS INDEX
-- ===================================================

-- [Analyse du plan d'exécution sans indexation optimisée]
-- EXPLAIN ANALYZE force PostgreSQL à exécuter réellement la requête 
-- et à nous afficher le rapport détaillé des temps de calcul (en millisecondes).
EXPLAIN ANALYZE
SELECT 
    s.pseudo,
    d.intitule,
    COUNT(st.id_stream) as nb_streams,
    COUNT(CASE WHEN st.date_fin_effective > st.heure_fin THEN 1 END) as nb_depassements
FROM streamer s
JOIN participation_defi pd ON s.id_streamer = pd.id_streamer
JOIN defi d ON pd.id_defi = d.id_defi
LEFT JOIN stream st ON s.id_streamer = st.id_streamer
-- L'astuce du "+ 0" désactive volontairement l'index automatique de la clé primaire
WHERE (s.id_streamer + 0) < 5000 
GROUP BY s.id_streamer, s.pseudo, d.id_defi, d.intitule
ORDER BY s.pseudo, d.intitule;