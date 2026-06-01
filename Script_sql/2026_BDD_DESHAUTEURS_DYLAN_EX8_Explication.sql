-- ===================================================
-- Exercice 8 : Explication 
-- Réalisé par : Dylan Deshauteurs
-- Date : 01/06/2026
-- ===================================================



/*
OBSERVATIONS TEXTUELLES DU PLAN (SANS INDEX) :

1. Temps de traitement globaux :
   - Planning Time  : 0.940 ms
   - Execution Time : 246.572 ms
   - Temps total    : ~247.51 ms (C'est le point de départ avant optimisation).

2. Identification des Scans Séquentiels (Seq Scan = Full Table Scan) :
   Le moteur de PostgreSQL a été forcé de lire l'intégralité des tables ligne par ligne :
   - Seq Scan sur 'participation_defi' (pd) : 249 988 lignes lues.
   - Seq Scan sur 'stream' (st)             : 100 000 lignes lues.
   - Seq Scan sur 'defi' (d)                 : 50 000 lignes lues.
   - Seq Scan sur 'streamer' (s)             : 50 000 lignes lues.

3. Opérations coûteuses et filtres :
   - À la ligne 19, l'opération "Filter: ((id_streamer + 0) < 5000)" montre que le moteur
     a dû évaluer mathématiquement les 50 000 lignes de streamers pour n'en garder que 4 999 
     (Rows Removed by Filter: 45001). Le "+ 0" a neutralisé l'index de clé primaire.
   - Les jointures se font via des "Hash Join" lourds en mémoire car aucune table enfant 
     ne possède d'index sur ses clés étrangères.
   - L'étape finale (Sort) doit trier 24 861 lignes en mémoire via un algorithme Quicksort (2322kB).

CONCLUSION : La base de données souffre d'un manque cruel d'index, ce qui la pousse à scanner 
plus de 400 000 lignes au total pour afficher un résultat qui n'en contient que 24 861.
*/


-- ===================================================
-- ÉTAPE 6 : RAPPORT COMPARATIF ET GAIN DE PERFORMANCE
-- ===================================================
/*
COMPARAISON AVANT / APRÈS INDEXATION :

1. Évolution des temps d'exécution :
   - Temps SANS index : 246.572 ms
   - Temps AVEC index : 177.269 ms
   - Gain net de temps : 69.303 ms

2. Changement de stratégie du moteur (Scans) :
   - Sur la table 'stream' : Le 'Seq Scan' (100K lignes lues) a disparu au profit 
     d'un 'Index Scan' ultra-rapide utilisant 'idx_stream_id_streamer'.
   - Sur la table 'participation_defi' : Le moteur utilise désormais un 
     'Parallel Seq Scan' optimisé avec l'aide de Workers en arrière-plan pour paralléliser le traitement.

3. Calcul du gain de performance global :
   - Amélioration de : ((246.572 - 177.269) / 246.572) * 100 = 28.11 %

CONCLUSION : L'indexation est un succès. Malgré la contrainte du "(id_streamer + 0)" 
qui bloque toujours l'index de la clé primaire sur les streamers, la création de l'index 
sur la table enfant 'stream' a permis de soulager les jointures et de faire chuter 
le temps de calcul global de près de 30%.
*/

-- ===================================================
-- ANALYSE DES PERFORMANCES (RÉSUMÉ)
-- ===================================================
/*
1. Quels index ont eu le plus d'impact ?
   L'index sur la table "stream" (idx_stream_id_streamer). 
   Il a permis à la base de passer d'une lecture totale très lente (Seq Scan) 
   à une recherche ciblée ultra-rapide (Index Scan).

2. Pourquoi les jointures sur participation_defi étaient lentes sans index ?
   Car c'est une énorme table (250 000 lignes). Sans index (sans point de repère), 
   le moteur devait charger toutes ces lignes en mémoire pour essayer de faire les 
   liens avec les streamers, ce qui sature la machine.

3. Quel est le gain de performance global (en %) ?
   - Temps AVANT les index : 246 ms
   - Temps APRÈS les index : 177 ms
   Le temps de traitement a été réduit, offrant un gain de performance d'environ 28 %.
*/