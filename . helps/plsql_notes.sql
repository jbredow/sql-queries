/*	PLSQL NOTES */

--  join to select cent business units.

SUBSTR ( string, start_position [ , length ] ) [ optional ]

-- BRANCH SELECT





SELECT t.chargeId,
       t.chargeType,
       t.serviceMonth
  FROM     ( SELECT chargeId,
                    MAX ( serviceMonth ) AS serviceMonth
               FROM invoice
             GROUP BY chargeId ) x
       JOIN
           invoice t
       ON x.chargeId = t.chargeId
          AND x.serviceMonth = t.serviceMonth


