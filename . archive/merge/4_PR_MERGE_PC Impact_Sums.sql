DROP TABLE AAA6863.PR_MERGE_IMPACT_SUMS_JACKSON;

CREATE TABLE AAA6863.PR_MERGE_IMPACT_SUMS_JACKSON

AS

SELECT ACCOUNT_NAME,
       COLUMN_CATEGORY,
       MAIN_CUSTOMER_GK,
       LTRIM(PRICE_COLUMN) SRC_PRICE_COLUMN,
       LTRIM(DEST_PC) DEST_PC,
       LTRIM (PRICE_COLUMN || '_' || DEST_PC) IMPACT_KEY,
       SUM (IMPACT_AMT) IMPACT_AMT
  FROM (SELECT X.ACCOUNT_NAME,
               X.MAIN_CUSTOMER_GK,
               X.DISC_GRP_NK_NAME,
               --/*X.CHANNEL_TYPE,
              /* SUM (X.SLS_SUBTOTAL)
                  OVER (PARTITION BY X.ACCOUNT_NAME, X.DISC_GRP)
                  ACCT_DG_SALES_TOTAL,
               SUM (X.SLS_SUBTOTAL) OVER (PARTITION BY X.ACCOUNT_NAME)
                  ACCT_SALES_TOTAL,*/
               TO_CHAR (X.PRICE_COLUMN, '000') PRICE_COLUMN,
               X.SLS_SUBTOTAL,
               X.PBO_SLS PBO_SALES,
               X.TOTAL_SALES,
               X.MATRIX_SALES,
               X.MATRIX_COST,
               X.CONTRACT_SALES,
              -- X.ACTIVE_MAIN_CUST_COUNT,
               --X.MAIN_CUST_COUNT,
               DECODE (X.PRICE_COLUMN,
                       '001', '01 - REPAIR   REMODEL PLUMBERS',
                       '002', '01 - REPAIR   REMODEL PLUMBERS',
                       '003', '01 - REPAIR   REMODEL PLUMBERS',
                       '004', '01 - REPAIR   REMODEL PLUMBERS',
                       '005', '02 - OPEN',
                       '006', '03 - NEW WORK PLUMBERS',
                       '007', '03 - NEW WORK PLUMBERS',
                       '008', '03 - NEW WORK PLUMBERS',
                       '009', '03 - NEW WORK PLUMBERS',
                       '011', '04 - PLBG/HVAC hybrid PCs',
                       '012', '04 - PLBG/HVAC hybrid PCs',
                       '013', '04 - PLBG/HVAC hybrid PCs',
                       '020', '05 - RETAIL CPU',
                       '021', '06 - ASSOCIATED TRADE 1',
                       '022', '07 - ASSOCIATED TRADE 2',
                       '023', '08 - LIST',
                       '024', '09 - SHOWROOM',
                       '025', '09 - SHOWROOM',
                       '026', '09 - SHOWROOM ARCH',
                       '027', '09 - SHOWROOM BUILDER',
                       '028', '09 - SHOWROOM BUILDER',
                       '029', '09 - SHOWROOM PLUMBER',
                       '030', '09 - SHOWROOM PLUMBER',
                       '050', '10 - BUILDERS- REMODEL',
                       '051', '10 - BUILDERS- REMODEL',
                       '053', '11 - BUILDERS, NEW WORK',
                       '054', '11 - BUILDERS, NEW WORK',
                       '057', '12 - K   B DEALERS',
                       '058', '12 - K   B DEALERS',
                       '065', '13 - COMMERCIAL PLUMBERS',
                       '066', '13 - COMMERCIAL PLUMBERS',
                       '067', '13 - COMMERCIAL PLUMBERS',
                       '068', '13 - COMMERCIAL PLUMBERS',
                       '070', '14 - MECHANICALS',
                       '071', '14 - MECHANICALS',
                       '072', '14 - MECHANICALS',
                       '073', '14 - MECHANICALS',
                       '078', '15 - Proc Piping MECHs',
                       '082', '16 - Manufacturing Plants',
                       '083', '16 - Manufacturing Plants',
                       '084', '16 - Manufacturing Plants',
                       '097', '17 - Industrial Piping',
                       '099', '18 - Nat Acct Mfg Plants',
                       '103', '19 - FIRE PROT',
                       '104', '19 - FIRE PROT',
                       '106', '19 - FIRE PROT',
                       '107', '19 - FIRE PROT',
                       '112', '21 - HVAC R R DEALERS',
                       '113', '21 - HVAC R R DEALERS',
                       '114', '21 - HVAC R R DEALERS',
                       '115', '22 - HVAC R R NON-DEALERS',
                       '116', '22 - HVAC R R NON-DEALERS',
                       '117', '22 - HVAC R R NON-DEALERS',
                       '120', '23 - HVAC NEW WORK DEALERS',
                       '121', '23 - HVAC NEW WORK DEALERS',
                       '132', '24 - MUNICIPALITIES',
                       '133', '24 - MUNICIPALITIES',
                       '136', '25 - P/W CONTR',
                       '137', '25 - P/W CONTR',
                       '140', '26 - WW CONTR',
                       '141', '26 - WW CONTR',
                       '142', '26 - WW CONTR',
                       '143', '26 - WW CONTR',
                       '150', '27 - MISC CONTR, GCs',
                       '153', '28 - ELEC',
                       '154', '28 - ELEC',
                       '155', '28 - ELEC',
                       '157', '29 - IRRIG',
                       '158', '29 - IRRIG',
                       '163', '30 - WELL/SEPTIC',
                       '164', '30 - WELL/SEPTIC',
                       '165', '31 - WHOLESALER',
                       '166', '31 - WHOLESALER',
                       '167', '31 - WHOLESALER',
                       '170', '32 - HOSPITALITY',
                       '171', '32 - HOSPITALITY',
                       '172', '32 - HOSPITALITY',
                       '173', '32 - HOSPITALITY',
                       '180', '33 - PROP MGMT',
                       '181', '33 - PROP MGMT',
                       '182', '33 - PROP MGMT',
                       '183', '33 - PROP MGMT',
                       '190', '34 - GOVERNMENT',
                       '191', '34 - GOVERNMENT',
                       '192', '34 - GOVERNMENT',
                       '193', '34 - GOVERNMENT',
                       '195', '34 - GOVERNMENT',
                       '205', '35 - FED GOVT',
                       '301', '36 - REPAIR   REMODEL PLUMBERS',
                       '302', '36 - REPAIR   REMODEL PLUMBERS',
                       '303', '36 - REPAIR   REMODEL PLUMBERS',
                       '304', '36 - REPAIR   REMODEL PLUMBERS',
                       '306', '37 - NEW WORK PLUMBERS',
                       '307', '37 - NEW WORK PLUMBERS',
                       '308', '37 - NEW WORK PLUMBERS',
                       '309', '37 - NEW WORK PLUMBERS',
                       '324', '38 - KARLS APPLIANCES',
                       '370', '39 - MECHANICALS',
                       '371', '39 - MECHANICALS',
                       '372', '39 - MECHANICALS',
                       '373', '39 - MECHANICALS',
                       'UNDEFINED')
                  COLUMN_CATEGORY,
               X.SRC_MULT,
               X.SRC_DISC,
               X.DISC_GRP,
               X.DISCOUNT_GROUP_NAME,
               X.DEST_PC,
               X.DEST_MULT,
               X.FORM_COMPARE,
               X.FORM_COMPARE * X.MATRIX_SALES AS IMPACT_AMT
          FROM (SELECT GP_DATA.ACCOUNT_NAME,
                       GP_DATA.PRICE_COLUMN,
                       GP_DATA.MAIN_CUSTOMER_GK,
                       GP_DATA.DISC_GRP,
                       GP_DATA.DISCOUNT_GROUP_NAME,
                          GP_DATA.DISC_GRP
                       || ' - ' || GP_DATA.DISCOUNT_GROUP_NAME
                          DISC_GRP_NK_NAME,
                       --GP_DATA.PROD_OVR_COUNT,
                       GP_DATA.BASIS,
                       GP_DATA.OPER,
                       GP_DATA.SRC_DISC,
                       GP_DATA.SRC_MULT,
                       GP_DATA.DEST_MULT,
                       GP_DATA.DEST_PC,
                       MAX (
                          CASE
                             WHEN GP_DATA.ACCOUNT_NAME  IN ('JACKSON')
                             THEN
                                GP_DATA.FORM_COMPARE
                             ELSE
                                0
                          END)
                          FORM_COMPARE,
                       --COUNT (DISTINCT GP_DATA.MAIN_CUSTOMER_GK)
                         -- ACTIVE_MAIN_CUST_COUNT,
                       SUM (GP_DATA.EXT_SALES) SLS_SUBTOTAL,
                       SUM (GP_DATA.PBO_SLS) PBO_SLS,
                       SUM (GP_DATA.TOTAL_SALES) TOTAL_SALES,
                       SUM (GP_DATA.AVG_COGS) TOTAL_COST,
                       SUM (GP_DATA.AVG_COGS) COST_SUBTOTAL,
                       SUM (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS) TOTAL_GP,
                       SUM (GP_DATA.INVOICE_LINES) TOTAL_LINES,
                       SUM (
                          CASE
                             WHEN GP_DATA.PRICE_CATEGORY IN
                                     ('MATRIX', 'MATRIX_BID')
                             THEN
                                (GP_DATA.EXT_SALES)
                             ELSE
                                0
                          END)
                          MATRIX_SALES,
                       SUM (
                          CASE
                             WHEN GP_DATA.PRICE_CATEGORY IN
                                     ('MATRIX', 'MATRIX_BID')
                             THEN
                                (GP_DATA.AVG_COGS)
                             ELSE
                                0
                          END)
                          MATRIX_COST,
                       SUM (
                          CASE
                             WHEN GP_DATA.PRICE_CATEGORY IN
                                     ('MATRIX', 'MATRIX_BID')
                             THEN
                                (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                             ELSE
                                0
                          END)
                          MATRIX_GP,
                       SUM (
                          CASE
                             WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                             THEN
                                (GP_DATA.EXT_SALES)
                             ELSE
                                0
                          END)
                          CONTRACT_SALES,
                       SUM (
                          CASE
                             WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                             THEN
                                (GP_DATA.AVG_COGS)
                             ELSE
                                0
                          END)
                          CONTRACT_COST,
                       SUM (
                          CASE
                             WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                             THEN
                                (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                             ELSE
                                0
                          END)
                          CONTRACT_GP
                  FROM (SELECT MATR.ACCOUNT_NAME,
                               MATR.PRICE_COLUMN,
                               MATR.DISC_GRP,
                               MATR.DISCOUNT_GROUP_NAME,
                               MATR.PROD_OVR_COUNT,
                               MATR.BASIS,
                               MATR.OPER,
                               MATR.DISCOUNT SRC_DISC,
                               MATR.MULTIPLIER SRC_MULT,
                               --MATR.LAST_UPDATE,
                               --MATR.DELETE_DATE,
                               SALES.PRICE_CATEGORY,
                               SALES.AVG_COGS,
                               SALES.TOTAL_SALES,
                               SALES.PBO_SLS,
                               SALES.EXT_SALES,
                               SALES.MAIN_CUSTOMER_GK,
                               --CUST.MAIN_CUST_COUNT,
                               SALES.INVOICE_LINES,
                               COMP.DEST_PC,
                               COMP.DEST_MULT DEST_MULT,
                               COMP.FORM_COMPARE
                          FROM AAA6863.PR_MERGE_MATRIX_2 MATR
                              /* LEFT OUTER JOIN
                               AAK9658.PR_MERGE_CUST_2 CUST
                                  ON (    MATR.ACCOUNT_NAME =
                                             CUST.ACCOUNT_NAME
                                      AND MATR.PRICE_COLUMN =
                                             CUST.PRICE_COLUMN)*/
                               LEFT OUTER JOIN
                               AAA6863.PBO_SLS SALES
                                  ON (    MATR.ACCOUNT_NAME =
                                             SALES.ACCOUNT_NAME
                                      AND MATR.PRICE_COLUMN =
                                             SALES.PRICE_COLUMN
                                      AND MATR.DISC_GRP =
                                             SALES.DISCOUNT_GROUP_NK)
                               LEFT OUTER JOIN
                               (SELECT COMP.PC_GRP,
                                       SRC.ACCOUNT_NAME SRC_ACCT,
                                       SRC.DISC_GRP,
                                       SRC.DISCOUNT_GROUP_NAME,
                                       SRC.BASIS,
                                       SRC.OPER,
                                       COMP.SRC_PC,
                                       COMP.SRC_PC_SUBGRP,
                                       SRC.DISCOUNT SRC_DISC,
                                       SRC.MULTIPLIER SRC_MULT,
                                       SRC.PROD_OVR_COUNT SRC_OVR_COUNT,
                                       DEST.ACCOUNT_NAME DEST_ACCT,
                                       COMP.DEST_PC,
                                       COMP.DEST_PC_SUBGRP,
                                       DEST.DISCOUNT DEST_DISC,
                                       DEST.MULTIPLIER DEST_MULT,
                                       --DEST.PROD_OVR_COUNT DEST_OVR_COUNT,
                                      CASE 
                                        WHEN 
                                          SRC.MULTIPLIER > 0
                                            THEN ((DEST.MULTIPLIER/SRC.MULTIPLIER)-1)
                                             ELSE 
                                              0
                                            END AS FORM_COMPARE
                                  FROM AAA6863.PR_MERGE_MATRIX_2 SRC
                                       INNER JOIN
                                       AAA6863.PR_MERGE_MATRIX_2 DEST
                                          ON (    SRC.DISC_GRP =
                                                     DEST.DISC_GRP
                                              AND SRC.BASIS = DEST.BASIS
                                              AND SRC.OPER = DEST.OPER)
                                       INNER JOIN
                                       AAA6863.PR_MERGE_PC_COMPARE COMP
                                          ON (    COMP.DEST_PC =
                                                     DEST.PRICE_COLUMN
                                              AND SRC.PRICE_COLUMN =
                                                     COMP.SRC_PC)
                                 WHERE     SRC.ACCOUNT_NAME = 'JACKSON'
                                 AND        DEST.ACCOUNT_NAME = 'NASH'
                                 ) COMP
                                  ON     (    MATR.PRICE_COLUMN = COMP.SRC_PC
                                          AND MATR.DISC_GRP = COMP.DISC_GRP)
                                     AND MATR.ACCOUNT_NAME = COMP.SRC_ACCT) GP_DATA
                 WHERE DECODE (PRICE_COLUMN,
                               '000', 1,
                               'C', 1,
                               'N/A', 1,
                               'NA', 1,
                               0) <> 1
                --AND DELETE_DATE IS NULL
                GROUP BY GP_DATA.ACCOUNT_NAME,
                         GP_DATA.PRICE_COLUMN,
                         GP_DATA.MAIN_CUSTOMER_GK,
                         GP_DATA.DISC_GRP,
                         GP_DATA.DISCOUNT_GROUP_NAME,
                         --GP_DATA.PROD_OVR_COUNT,
                         GP_DATA.BASIS,
                         GP_DATA.OPER,
                         GP_DATA.SRC_DISC,
                         GP_DATA.SRC_MULT,
                         GP_DATA.DEST_MULT,
                         GP_DATA.DEST_PC) X) FINAL
WHERE NVL (IMPACT_AMT, 0) <> 0
GROUP BY ACCOUNT_NAME,
         COLUMN_CATEGORY,
         MAIN_CUSTOMER_GK,
         PRICE_COLUMN,
         DEST_PC;
         
--GRANT SELECT ON AAA6863.PR_MERGE_IMPACT_SUMS_JACKSON TO PUBLIC;
