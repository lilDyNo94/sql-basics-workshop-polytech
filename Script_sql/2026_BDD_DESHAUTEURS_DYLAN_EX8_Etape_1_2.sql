-- ===================================================
-- Exercice 8 (étape 1 & 2): Analyse de performance et création d'index
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================

-- ===================================================
-- ÉTAPE 1 & 2 : CHARGEMENT DES DONNÉES MASSIVES (~700K lignes)
-- ===================================================

-- 1. Nettoyage complet et réinitialisation des compteurs d'ID
TRUNCATE TABLE stream, participation_defi, creneau, defi, streamer RESTART IDENTITY CASCADE;

-- 2. Insertion de 50 000 streamers
DO $$
BEGIN
    FOR i IN 1..50000 LOOP
        INSERT INTO streamer (pseudo, url_twitch)
        VALUES ('pseudo_' || i, 'https://twitch.tv/pseudo_' || i);
    END LOOP;
END $$;

-- 3. Insertion de 50 000 défis
DO $$
BEGIN
    FOR i IN 1..50000 LOOP
        INSERT INTO defi (intitule, montant_palier, etat_validation)
        VALUES (
            'defi_' || i,
            (random() * 50000)::DECIMAL(12,2) + 500,
            (random() < 0.5)
        );
    END LOOP;
END $$;

-- 4. Insertion de 250 000 participations (Relation M:N)
DO $$
BEGIN
    FOR i IN 1..250000 LOOP
        INSERT INTO participation_defi (id_streamer, id_defi)
        VALUES (
            FLOOR(random() * 50000 + 1)::INT,
            FLOOR(random() * 50000 + 1)::INT
        )
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- 5. Insertion de 100 000 créneaux
DO $$
DECLARE
    start_date TIMESTAMP;
    end_date TIMESTAMP;
BEGIN
    FOR i IN 1..100000 LOOP
        start_date := TIMESTAMP '2025-09-05 18:00:00' + (random() * 48)::INT * INTERVAL '1 hour';
        end_date := start_date + (random() * 4 + 1)::INT * INTERVAL '1 hour';
        INSERT INTO creneau (id_streamer, date_debut_autorisee, date_fin_autorisee)
        VALUES (
            FLOOR(random() * 50000 + 1)::INT,
            start_date,
            end_date
        );
    END LOOP;
END $$;

-- 6. Insertion de 100 000 streams
DO $$
DECLARE
    start_date TIMESTAMP;
    end_date TIMESTAMP;
    effective_end_date TIMESTAMP;
BEGIN
    FOR i IN 1..100000 LOOP
        start_date := TIMESTAMP '2025-09-05 18:00:00' + (random() * 48)::INT * INTERVAL '1 hour';
        end_date := start_date + (random() * 4 + 1)::INT * INTERVAL '1 hour';
        effective_end_date := CASE WHEN random() < 0.7 
                              THEN end_date 
                              ELSE end_date + (random() * 3)::INT * INTERVAL '1 hour'
                              END;
        INSERT INTO stream (id_streamer, id_creneau, titre, heure_debut, heure_fin, date_fin_effective)
        VALUES (
            FLOOR(random() * 50000 + 1)::INT,
            FLOOR(random() * 100000 + 1)::INT,
            'Stream caritatif ' || i,
            start_date,
            end_date,
            effective_end_date
        );
    END LOOP;
END $$;