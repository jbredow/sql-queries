-- delete branches from full data.

CREATE TABLE PRICE_MGMT.PR_PRICE_CAT_HIST
AS
   (SELECT P_CAT.*
    FROM PRICE_MGMT.PR_PRICE_CAT_HIST_ALLLOG P_CAT
         INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
            ON (P_CAT.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK)
    WHERE     (IHF.ACCOUNT_NAME NOT LIKE ('INT%'))
          AND (P_CAT.YEARMONTH = '201810')
          AND (IHF.ACCOUNT_NAME NOT IN ('TRINIDAD',
                                        'BARBADOS',
                                        'PANAMA',
                                        'CARIBBEAN')));