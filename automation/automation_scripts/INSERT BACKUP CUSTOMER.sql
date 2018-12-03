INSERT INTO PRICE_MGMT.BACKUP_CUST                               --CHANGE YYMM
   SELECT CUST.ACCOUNT_NUMBER_NK,
          CUST.ACCOUNT_NAME,
          CUST.CUSTOMER_NK,
          CUST.MAIN_CUSTOMER_NK,
          CUST.CUSTOMER_NAME,
          CUST.CUSTOMER_TYPE,
          --  CUST.BMI_BUDGET_CUST_TYPE, -- NEW
          --  CUST.BMI_REPORT_CUST_TYPE, -- NEW
          CUST.PRICE_COLUMN,
          CUST.JOB_YN,
          CUST.SALESMAN_CODE,
          CUST.CROSS_ACCT,
          CUST.CROSS_CUSTOMER_NK,
          CUST.BRANCH_WAREHOUSE_NUMBER CUST_WHSE,
          CUST.ACCOUNT_SETUP_DATE,
          CUST.UPDATE_TIMESTAMP LAST_UPDATE,
          CUST.CUSTOMER_GK,
          TO_CHAR (SYSDATE, 'YYYYMM') YEARMONTH,
          TRUNC (SYSDATE) BACKUP_DATE,
          CUST.GSA_LINK,                                                -- NEW
          CUST.SEC_SLSM
   FROM DW_FEI.CUSTOMER_DIMENSION CUST
        -- JOIN TO CURRENT WHSE, ACCT XREF TO ONLY PULL CUSTOMERS FROM ACTIVE LOCATIONS
        INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
           ON     CUST.BRANCH_WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
              AND CUST.ACCOUNT_NAME = SWD.ACCOUNT_NAME
   WHERE     CUST.DELETE_DATE IS NULL
         AND SUBSTR (SWD.REGION_NAME, 0, 3) IN ('D01',
                                                'D02',
                                                'D03',
                                                'D04',
                                                'D05',
                                                'D10',
                                                'D11',
                                                'D12',
                                                'D14',
                                                'D20',
                                                'D21',
                                                'D22',
                                                'D23',
                                                'D24',
                                                'D25',
                                                'D26',
                                                'D30',
                                                'D31',
                                                'D32',
                                                'D40',
                                                'D41',
                                                'D42',
                                                'D50',
                                                'D51',
                                                'D52',
                                                'D53',
                                                'D54',
                                                'D59',
                                                'D60',
                                                'D61')