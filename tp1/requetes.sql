/*
 * 1) Afficher le nom et le salaire des pilotes dont le salaire est compris entre 19000 et 23000.
 */
SELECT sal
FROM pilote
WHERE
    sal BETWEEN '19000' AND '23000'
    /*
    * 2) Liste des vols qui arrivent à LONDRES avant 12 H 00. Affichez le numéro de vol, la ville de départ, la
    ville d’arrivée, l’heure de départ et l’heure d’arrivée. Le résultat sera trié par ordre alphabétique des
    villes de départ.
    */
SELECT novol, vildep, vilar, dep_h, ar_h
FROM vol
WHERE
    vilar = 'LONDRES'
    AND ar_h < 12
ORDER BY vildep ASC;

/*
3) Numéros et type des avions qui appartiennent à un type d’appareil dont le premier caractère est ‘7’
*/
SELECT `nuavion`, `type` FROM avion WHERE `type` >= 7

/*
* 4) Liste alphabétique des pilotes (nom, date d’embauche, adresse) qui habitent PARIS et qui ont été
embauchés entre le 1 Janvier 2011 et le 1 Janvier 2018.
*/
SELECT nom, embauche, adresse
FROM pilote
WHERE
    adresse = 'PARIS'
    AND embauche BETWEEN '2011-01-01-' AND '2018-01-01'
ORDER BY embauche ASC

/*
* 5) Liste alphabétique des pilotes qui ont effectués un vol le 2 Mars 2014. (nom du pilote, n° du vol, ville
de départ et ville d’arrivée)
*/
SELECT nom, novol, vildep, vilar
FROM pilote p
    natural join affectation a
    natural join vol v
where
    date_vol = '2014-03-02'
order by nom

/*
 * 6) Donnez la liste des pilotes qui ont été embauchés après le pilote n° 3452. (n° et nom des pilotes)
 */
SELECT nopilot, nom, embauche
FROM pilote
WHERE
    embauche > (
        SELECT embauche
        FROM pilote
        WHERE
            nopilot = 3452
    );
/*
 * 7) N° et nom du pilote qui a le salaire le plus élevé
 */
SELECT nopilot, nom, sal
FROM pilote
ORDER BY sal DESC
LIMIT 1
    /*
    * 8) Donnez le numéro, le nom et le montant de la commission du pilote qui a la plus faible commission non
    nulle
    */
SELECT nopilot, nom, comm
FROM pilote
WHERE
    comm = (
        SELECT MIN(comm)
        FROM pilote
        WHERE
            comm > 0
    );
/*
 *9) Donnez le nombre d’avions par type d’avion pour les avions de la base de données
 */
SELECT type, COUNT(nuavion) AS nombre_avions
FROM avion
GROUP BY
    type;
/*
*10 ) Donnez les noms des pilotes qui ont piloté tous les avions
(Aucune ligne sélectionnée)
*/
SELECT nopilot, nom
FROM affectation
    NATURAL JOIN pilote
GROUP BY
    nopilot,
    nom
HAVING
    COUNT(nuavion) = (
        SELECT COUNT(*)
        FROM avion
    );

/*
 *11 ) Donnez les noms des pilotes qui n’ont pas piloté tous les avions
 */
SELECT pilote.nopilot, pilote.nom
FROM pilote
WHERE
    EXISTS (
        SELECT 1
        FROM avion
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM affectation
                WHERE
                    affectation.nopilot = pilote.nopilot
                    AND affectation.nuavion = avion.nuavion
            )
    );
/*
 * 12 ) Donnez les noms des pilotes qui n’ont piloté aucun avion
 */
SELECT pilote.nopilot, pilote.nom
FROM pilote
WHERE
    NOT EXISTS (
        SELECT 1
        FROM avion
        WHERE
            EXISTS (
                SELECT 1
                FROM affectation
                WHERE
                    affectation.nopilot = pilote.nopilot
                    AND affectation.nuavion = avion.nuavion
            )
    );

/*
* 13) Donnez pour chaque pilote qui est passé par PARIS, le numéro de vol et la date correspondante. (n° et nom du
pilote, n° et date du vol)
*/
SELECT nopilot, nom, novol, date_vol
FROM affectation
    NATURAL JOIN vol
    NATURAL JOIN pilote
WHERE (
        vildep = 'PARIS'
        OR vilar = 'PARIS'
    )
    /*
     * 14 )Donnez le taux moyen de remplissage des avions de type 734 pour les vols enregistrés dans la base de données
     */
SELECT AVG(nbpass / nbplace)
FROM affectation
    NATURAL JOIN avion
    JOIN appareil ON (
        avion.type = appareil.code_type
    )
WHERE
    TYPE = '734'
    /*
     * 15 ) Donnez la liste des avions qui ont été pilotés par plus de 2 pilotes.
     */
SELECT nuavion
FROM affectation
GROUP BY
    nuavion
HAVING
    COUNT(DISTINCT nopilot) > 2;
/*
 * 16 ) Donnez la liste des pilotes qui ont le même nom mais une adresse différente. (nom et adresse du pilote)
 */
SELECT nopilot, nom, adresse
FROM pilote
WHERE
    nom IN (
        SELECT nom
        FROM pilote
        GROUP BY
            nom
        HAVING
            COUNT(DISTINCT adresse) > 1
    )
ORDER BY nom;
/*
* 17 ) Donnez la liste des vols qui correspondent à des allers-retours entre 2 villes (n° du vol, ville de départ, ville
d’arrivée)
*/
SELECT v1.novol, v1.vildep, v1.vilar
FROM vol v1, vol v2
WHERE
    v1.vildep = v2.vilar
    AND v1.vilar = v2.vildep
    AND v1.novol <> v2.novol;