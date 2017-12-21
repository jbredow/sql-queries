SELECT DISTINCT
       NVL (GM.DISTRICT, GMA.DISTRICT) DISTRICT,
       NVL (GM.ACCOUNT_NUMBER_NK, GMA.ACCOUNT_NUMBER_NK) ACCT_NK,
       NVL (GM.ACCOUNT_NAME, GMA.ACCOUNT_NAME) ACCOUNT_NAME,
       NVL (GM.GM_NAME, GMA.GM_NAME) AREA,
       PCCA.SLSM_CODE,
       PCCA.MAIN_WHSE CUST_WHSE,
       GM.WAREHOUSE_NAME WHSE_NAME,
       PCCA.MAIN_CUST_NK,
       NVL (PCCA.MSTR_CUST_NAME, PCCA.CUSTOMER_NAME) CUSTOMER_NAME,
       TO_CHAR (TRUNC (PCCA.SIGNUP_DATE), 'MM/DD/YYYY') SIGNUP,
       PCCA.MSTR_CUSTNO,
       PCCA.MSTR_CUST_NAME,
       CAT.CAT_NEW CATEGORY,
       Z.DISCOUNT_GROUP_NK DISC_GRP,
       Z.DISCOUNT_GROUP_NAME,
       Z.ALT1_CODE,
       Z.LAST_SALE,
       Z.PROGRAM_SALES,
       --Z.PROGRAM_COGS,
       Z.PROGRAM_GP_AMT,
       ROUND (CASE
                 WHEN Z.PROGRAM_SALES > 0
                 THEN
                    Z.PROGRAM_GP_AMT / Z.PROGRAM_SALES
                 ELSE
                    0
              END,
              3
       )
          "PROGRAM_GP%",
       Z.PROGRAM_SHIP_QTY,
       Z.OTHER_SALES,
       --Z.OTHER_COGS,
       Z.OTHER_GP_AMT,
       ROUND (CASE
                 WHEN Z.OTHER_SALES > 0 THEN Z.OTHER_GP_AMT / Z.OTHER_SALES
                 ELSE 0
              END,
              3
       )
          "OTHER_GP%",
       Z.OTHER_SHIP_QTY,
       Z.EXT_SALES,
       --Z.EXT_COGS,
       Z.EXT_GP_AMT,
       ROUND (CASE
                 WHEN Z.EXT_SALES > 0 THEN Z.EXT_GP_AMT / Z.EXT_SALES
                 ELSE 0
              END,
              3
       )
          "EXT_GP%",
       Z.EXT_SHIP_QTY,
       Z.MAIN_CUST_PROGRAM_SLS,
       Z.CONSOL_PROGRAM_SLS,
       Z.EST_REBATE,
       Z.REBATE_RATE,
       CASE
          WHEN PCCA.MSTR_CUSTNO IS NOT NULL THEN 'MSTR_' || PCCA.MSTR_CUSTNO
          ELSE PCCA.ACCOUNT_NUMBER_NK || '_' || PCCA.MAIN_CUST_NK
       END
          CUST_ROLLUP
  FROM             (SELECT PCCA.PROMO_NAME,
                           PCCA.ACCOUNT_NAME,
                           PCCA.ALIAS_NAME,
                           PCCA.ACCOUNT_NUMBER_NK,
                           MAX (PCCA.ACCT_TYPE) ACCT_TYPE,
                           PCCA.MAIN_CUST_NK,
                           MAX (PCCA.CUSTOMER_NAME) AS CUSTOMER_NAME,
                           MAX (PCCA.LAST_SALE) AS LAST_SALE,
                           MIN (PCCA.MAIN_WHSE) MAIN_WHSE,
                           PCCA.MSTR_CUSTNO,
                           PCCA.MSTR_CUST_NAME,
                           MIN (PCCA.SETUP_DATE) AS SETUP_DATE,
                           MAX(CASE
                                  WHEN NVL (PCCA.LAST_SALE, SYSDATE) >
                                          (SYSDATE - 365)
                                  THEN
                                     PCCA.SLSM_CODE
                                  ELSE
                                     NULL
                               END)
                              SLSM_CODE,
                           MAX(CASE
                                  WHEN NVL (PCCA.LAST_SALE, SYSDATE) >
                                          (SYSDATE - 180)
                                  THEN
                                     PCCA.SLSM_NAME
                                  ELSE
                                     NULL
                               END)
                              SLSM_NAME,
                           PCCA.FLYER_REGION,
                           MIN (PCCA.SIGNUP_DATE) AS SIGNUP_DATE
                      FROM AAA6863.PR_PROMO_REPORT_PCCA PCCA
                    GROUP BY PCCA.PROMO_NAME,
                             PCCA.ACCOUNT_NAME,
                             PCCA.ALIAS_NAME,
                             PCCA.ACCOUNT_NUMBER_NK,
                             --PCCA.ACCT_TYPE,
                             PCCA.MAIN_CUST_NK,
                             PCCA.MSTR_CUSTNO,
                             PCCA.MSTR_CUST_NAME,
                             --PCCA.SLSM_CODE,
                             --PCCA.SLSM_NAME,
                             PCCA.FLYER_REGION) PCCA
                LEFT OUTER JOIN
                   (SELECT Y.*,
                           CASE
                              WHEN CONSOL_PROGRAM_SLS BETWEEN 3000 AND 5999.99
                              THEN
                                 .03 * PROGRAM_SALES
                              WHEN CONSOL_PROGRAM_SLS BETWEEN 6000 AND 8999.99
                              THEN
                                 .04 * PROGRAM_SALES
                              WHEN CONSOL_PROGRAM_SLS BETWEEN 9000 AND 12000
                              THEN
                                 .05 * PROGRAM_SALES
                              WHEN CONSOL_PROGRAM_SLS > 12000
                              THEN
                                 .05 * PROGRAM_SALES
                              ELSE
                                 0
                           END
                              AS EST_REBATE,
                           CASE
                              WHEN CONSOL_PROGRAM_SLS BETWEEN 3000 AND 5999.99
                              THEN
                                 .03
                              WHEN CONSOL_PROGRAM_SLS BETWEEN 6000 AND 8999.99
                              THEN
                                 .04
                              WHEN CONSOL_PROGRAM_SLS BETWEEN 9000 AND 12000
                              THEN
                                 .05
                              WHEN CONSOL_PROGRAM_SLS > 12000
                              THEN
                                 .05
                              ELSE
                                 0
                           END
                              AS REBATE_RATE
                      FROM (SELECT X.*,
                                   SUM(PROGRAM_SALES)
                                      OVER
                                      (
                                         PARTITION BY ACCOUNT_NAME,
                                                      MAIN_CUSTOMER_NK
                                      )
                                      MAIN_CUST_PROGRAM_SLS,
                                   SUM (PROGRAM_SALES)
                                      OVER (PARTITION BY CUST_ROLLUP)
                                      CONSOL_PROGRAM_SLS
                              FROM (SELECT FLYER.CUST_ROLLUP,
                                              FLYER.ACCT_NK
                                           || '_'
                                           || FLYER.MAIN_CUSTOMER_NK
                                              MAIN_CUST_ROLLUP,
                                           FLYER.SIGNUP_DATE,
                                           FLYER.MSTR_CUSTNO,
                                           FLYER.MSTR_CUST_NAME,
                                           FLYER.MAIN_CUSTOMER_NK,
                                           FLYER.CUSTOMER_NAME,
                                           FLYER.ACCT_NK,
                                           FLYER.ACCOUNT_NAME,
                                           FLYER.ALIAS_NAME,
                                           FLYER.DISCOUNT_GROUP_NK,
                                           FLYER.DISCOUNT_GROUP_NAME,
                                           FLYER.ALT1_CODE,
                                           MAX (FLYER.LAST_SALE) LAST_SALE,
                                           SUM (FLYER.EXT_SALES) AS EXT_SALES,
                                           SUM (FLYER.EXT_COGS) AS EXT_COGS,
                                           SUM (FLYER.GP_AMT) AS EXT_GP_AMT,
                                           SUM (FLYER.SHIP_QTY) AS EXT_SHIP_QTY,
                                           SUM(CASE
                                                  WHEN PRICE_CATEGORY = 'FLYER'
                                                  THEN
                                                     EXT_SALES
                                                  ELSE
                                                     0
                                               END)
                                              PROGRAM_SALES,
                                           SUM(CASE
                                                  WHEN PRICE_CATEGORY = 'FLYER'
                                                  THEN
                                                     EXT_COGS
                                                  ELSE
                                                     0
                                               END)
                                              PROGRAM_COGS,
                                           SUM(CASE
                                                  WHEN PRICE_CATEGORY = 'FLYER'
                                                  THEN
                                                     GP_AMT
                                                  ELSE
                                                     0
                                               END)
                                              PROGRAM_GP_AMT,
                                           SUM(CASE
                                                  WHEN PRICE_CATEGORY = 'FLYER'
                                                  THEN
                                                     SHIP_QTY
                                                  ELSE
                                                     0
                                               END)
                                              PROGRAM_SHIP_QTY,
                                           SUM(CASE
                                                  WHEN PRICE_CATEGORY NOT IN
                                                             ('FLYER')
                                                  THEN
                                                     EXT_SALES
                                                  ELSE
                                                     0
                                               END)
                                              OTHER_SALES,
                                           SUM(CASE
                                                  WHEN PRICE_CATEGORY NOT IN
                                                             ('FLYER')
                                                  THEN
                                                     EXT_COGS
                                                  ELSE
                                                     0
                                               END)
                                              OTHER_COGS,
                                           SUM(CASE
                                                  WHEN PRICE_CATEGORY NOT IN
                                                             ('FLYER')
                                                  THEN
                                                     GP_AMT
                                                  ELSE
                                                     0
                                               END)
                                              OTHER_GP_AMT,
                                           SUM(CASE
                                                  WHEN PRICE_CATEGORY NOT IN
                                                             ('FLYER')
                                                  THEN
                                                     SHIP_QTY
                                                  ELSE
                                                     0
                                               END)
                                              OTHER_SHIP_QTY
                                      FROM AAA6863.PR_HVAC_FLYER_SLS_SUMS FLYER
                                    GROUP BY FLYER.CUST_ROLLUP,
                                             FLYER.SIGNUP_DATE,
                                             FLYER.MSTR_CUSTNO,
                                             FLYER.MSTR_CUST_NAME,
                                             FLYER.MAIN_CUSTOMER_NK,
                                             FLYER.CUSTOMER_NAME,
                                             FLYER.ACCT_NK,
                                             FLYER.ACCOUNT_NAME,
                                             FLYER.ALIAS_NAME,
                                             FLYER.DISCOUNT_GROUP_NK,
                                             FLYER.DISCOUNT_GROUP_NAME,
                                             FLYER.ALT1_CODE) X) Y) Z
                ON (PCCA.ACCOUNT_NUMBER_NK || '_' || PCCA.MAIN_CUST_NK) =
                      Z.MAIN_CUST_ROLLUP
             LEFT OUTER JOIN
                AAD9606.PR_HVAC_FLYER_CATEGORY CAT
             ON Z.ALT1_CODE = CAT.ALT_CODE
          LEFT OUTER JOIN
             AAD9606.PR_HVAC_FLYER_GM_BRANCH GM
          ON PCCA.MAIN_WHSE = GM.WAREHOUSE_NUMBER_NK
       LEFT OUTER JOIN
          (SELECT ACCOUNT_NUMBER_NK, ACCOUNT_NAME, GM_NAME, DISTRICT
             FROM AAD9606.PR_HVAC_FLYER_GM_BRANCH
            WHERE WAREHOUSE_NUMBER_NK IS NULL AND GM_NAME IS NOT NULL) GMA
       ON PCCA.ACCOUNT_NUMBER_NK = GMA.ACCOUNT_NUMBER_NK
	;