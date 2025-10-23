/* 

N'ayant pas fini le tp2, je soumets ce que j'ai fait jusqu'à présent.

* question 1
Augmenter de 10 % le salaire de tous les pilotes dont la commission est nulle
*/
UPDATE pilote SET sal = sal * 1.1 WHERE comm = 0;

/*
 * question 2
 * Attribuer à chaque pilote une nouvelle commission (en remplacement de leur comm existante)
 * égale à 5 € par passager transporté en 2004. Les pilotes n'ayant pas transportés de passager n'ont
 * droit à aucune commission
 */
UPDATE pilote
SET
    comm = COALESCE(
        (
            SELECT SUM(nbpass) * 5
            FROM affectation a
            WHERE
                a.nopilot = pilote.nopilot
                AND YEAR (date_vol) = 2004
            GROUP BY
                a.nopilot
        ),
        0
    );

/* question 3*/
INSERT INTO
    affectation (
        novol,
        date_vol,
        nbpass,
        nopilot,
        nuavion
    )
VALUES (
        'IW433',
        '2006-03-11',
        0,
        '3452',
        '8467'
    );

/* question 3*/