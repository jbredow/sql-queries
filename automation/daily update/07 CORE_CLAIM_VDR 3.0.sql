TRUNCATE TABLE PRICE_MGMT.CORE_CLAIM_VDR;
--DROP TABLE PRICE_MGMT.CORE_CLAIM_VDR;

INSERT INTO PRICE_MGMT.CORE_CLAIM_VDR
   SELECT ILCF.INVOICE_NUMBER_GK,
          ILCF.INVOICE_LINE_NUMBER,
          ILCF.COST_CODE_IND,
          ILCF.VENDOR_NAME,
          ILCF.VENDOR_AGREEMENT,
          ILCF.CONTRACT_NAME,
          ILCF.SUBLINE_QTY,
          ILCF.SUBLINE_COST,
          ILCF.CLAIM_AMOUNT,
          ILCF.INVOICE_DATE,
          ILCF.PROCESS_DATE
   FROM PRICE_MGMT.PR_VICT2_SLS PR_VICT2_SLS
        INNER JOIN DW_FEI.INVOICE_LINE_CORE_FACT ILCF
           ON (    PR_VICT2_SLS.INVOICE_NUMBER_GK = ILCF.INVOICE_NUMBER_GK
               AND PR_VICT2_SLS.INVOICE_LINE_NUMBER =
                   ILCF.INVOICE_LINE_NUMBER)
   WHERE ILCF.COST_CODE_IND = 'C';

COMMIT;