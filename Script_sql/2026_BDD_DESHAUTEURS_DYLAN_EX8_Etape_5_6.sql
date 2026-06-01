-- ===================================================
-- Exercice 8 (étape 5 & 6): Analyse de performance et création d'index
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================

-- ===================================================
-- ÉTAPE 5 : CRÉATION DES INDEX D'OPTIMISATION
-- ===================================================

-- Index sur les clés étrangères (participation_defi)
CREATE INDEX idx_participation_defi_id_streamer ON participation_defi(id_streamer);
CREATE INDEX idx_participation_defi_id_defi ON participation_defi(id_defi);

-- Index sur les jointures (stream)
CREATE INDEX idx_stream_id_streamer ON stream(id_streamer);

-- Index sur les dates pour accélérer le CASE WHEN
CREATE INDEX idx_stream_date_fin_effective ON stream(date_fin_effective);

-- Index composé pour croiser rapidement les streamers et leurs dates
CREATE INDEX idx_stream_id_streamer_date_fin_effective ON stream(id_streamer, date_fin_effective);


-- ===================================================
-- ÉTAPE 6 : RÉEXÉCUTION DE LA REQUÊTE POUR COMPARAISON
-- ===================================================

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
WHERE (s.id_streamer + 0) < 5000 
GROUP BY s.id_streamer, s.pseudo, d.id_defi, d.intitule
ORDER BY s.pseudo, d.intitule;