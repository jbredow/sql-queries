SELECT X.[ORDER_ACCT],
       X.AREA ORD_AREA,
       X.RPT_NAME ORD_AREA_NAME,
       X.SELL_WHSE_ID,
       X.[ORDER_ID],
       X.[ORDER_CUST],
       X.CUST_NAME,
       X.[ORDER_DATE],
       X.OML_INIT,
       X.OML_NAME,
       X.WRITER,
       X.WRITER_NAME,
       X.WRITER_LOGON,
       X.[SLSM_ID],
       X.[SALESMAN_NAME],
       X.[CORE_CNTRT_ID],
       X.[CORE_CNTRT_NAME],
       SUM (X.EXT_SLS) EXT_SLS,
       SUM (X.AVG_COGS) AVG_COGS,
       SUM (X.CNTRT_COGS) CNTRT_COGS,
       SUM (X.EXT_CLAIM_AMT) EXT_CLAIM_AMT,
       X.[VENDOR_ID],
       X.[VENDOR_NAME],
       X.[VENDOR_AGREEMENT],
       X.[CONTR_START],
       X.[REQRD_SHIP_DATE],
       X.INVOICE_DATE,
       X.CONTR_EXPIRE,
       X.SHIP_YN,
       X.SHIP_DATE,
       X.DAYS_LEFT
FROM (SELECT DISTINCT
             H.[ORDER_ACCT],
             W.AREA,
             W.RPT_NAME,
             H.[SELL_WHSE_ID],
             H.[SLSM_ID],
             S.[SALESMAN_NAME],
             H.[ORDER_ID],
             H.[ORDER_CUST],
             CU.[CUST_NAME],
             H.[ORDER_DATE],
             CONVERT (VARCHAR (10), H.[REQRD_SHIP_DATE], 101)
                REQRD_SHIP_DATE,
             E.[EMP_INITIALS]
                OML_INIT,
             E.[EMP_NAME]
                OML_NAME,
             H.[WRITER_INITIALS]
                WRITER,
             EW.[EMP_NAME]
                WRITER_NAME,
             EW.[TRIL_LOGON_ID]
                WRITER_LOGON,
             LDMS.[CORE_CNTRT_ID],
             LDMS.[CORE_CNTRT_NAME],
             (LD.NET_PRICE * LD.[RSRV_QTY] / LD.PER_QTY)
                EXT_SLS,
             (LD.ORDER_AVG_COST_AMT * LD.[RSRV_QTY] / LD.PER_QTY)
                AVG_COGS,
             (LDMS.CNTRT_COST_AMT * LD.[RSRV_QTY] / LD.PER_QTY)
                CNTRT_COGS,
             (  LDMS.[CNTRT_CLAIM_AMT]
              * LD.[RSRV_QTY]
              / ISNULL (LD.[PER_QTY], 1))
                EXT_CLAIM_AMT,
             CASE WHEN H.SHIP_DATE IS NOT NULL THEN 'Y' ELSE 'N' END
                SHIP_YN,
             C.[VENDOR_ID],
             V.[VENDOR_NAME],
             C.[VENDOR_AGREEMENT],
             CONVERT (VARCHAR (10), C.[START_DATE], 101)
                CONTR_START,
             CONVERT (VARCHAR (10), C.[END_DATE], 101)
                CONTR_EXPIRE,
             CONVERT (VARCHAR (10), H.[INVOICE_DATE], 101)
                INVOICE_DATE,
             CONVERT (VARCHAR (10), H.[SHIP_DATE], 101)
                SHIP_DATE,
             DATEDIFF (Day, H.[REQRD_SHIP_DATE], C.[END_DATE])
                DAYS_LEFT
      FROM [ODS_STG].[ORDER_HDR] H
           INNER JOIN [ODS_STG].[ORDER_LINES_DTL] LD
              ON (H.ORDER_KEY = LD.ORDER_KEY)
           INNER JOIN [ODS_STG].[ORDER_LINES_DTL_MS] LDMS
              ON     H.ORDER_KEY = LDMS.ORDER_KEY
                 AND LD.ORDER_LINES_DTL_POS = LDMS.ORDER_LINES_DTL_POS
           INNER JOIN [SEC_CORE_STG].[CONTRACT] C
              ON (LDMS.[CORE_CNTRT_ID] = C.[CONTRACT_PK])
           LEFT OUTER JOIN [SEC_CORE_STG].[MASTER_VENDOR] V
              ON C.VENDOR_ID = V.VENDOR_ID
           INNER JOIN [ODS_STG].[SALESMAN] S
              ON     H.[SLSM_ID] = S.[SALESMAN_ID]
                 AND H.[ORDER_ACCT] = S.[SALESMAN_ACCT]
           INNER JOIN [ODS_STG].[CUSTOMER] CU
              ON     H.ORDER_ACCT = CU.CUSTOMER_ACCT
                 AND H.ORDER_CUST = CU.CUSTOMER_ID
           LEFT OUTER JOIN [ODS_STG].[EMPLOYEE] E
              ON H.[OML_EMP_ID] = E.[EMPLOYEE_ID]
           LEFT OUTER JOIN [DWFEI_STG].[RPT_AREA_VW] W
              ON H.SELL_WHSE_ID = W.WHSE
           LEFT OUTER JOIN (SELECT [PAYROLL_BRANCH_ID],
                                   [HOME_BRANCH],
                                   [PAYROLL_WHSE_ID],
                                   [EMP_INITIALS],
                                   [EMP_NAME],
                                   [TRIL_LOGON_ID]
                            FROM [ODS_STG].[EMPLOYEE]
                            WHERE     [TITLE_CODE] IN ('6185', '6186', '6495', '7115', '7243', '7244', '7245', '7246', '7247', '7248', '7249', '7250', '7251', '7255', '7256', '7257', '7259', '7260', '7261', '7262', '7263', '7264', '7266', '7267', '7268', '7269', '7270', '7271', '7272', '7273', '7274', '7280', '7281', '7282', '7353', '7383', '7384', '7385', '7386', '7387', '7388', '7389', '7390', '7391', '7392', '7393', '7394', '7395', '7396', '7397', '7398', '7399', '7400', '7403', '7404', '7405', '7406', '7407', '7408', '7409', '7410', '7411', '7412', '7413', '7414', '7417', '7420', '7421', '7422', '7424', '7425', '7426', '7427', '7428', '7429', '7430', '7431', '7432', '7433', '7434', '7435', '7436', '7437', '7438', '7439', '7440', '7441', '7443', '7444', '7534', '7535', '7536', '7537', '7539', '7542', '7546', '7547', '7548', '7549', '7550', '7551', '7553', '7556', '7558', '7559', '7560', '7562', '7564', '7575', '7576', '7577', '7578', '7579', '7615', '7667', '7668', '7677', '7678', '7687', '7688', '7689', '7690', '7691', '7692', '7696', '7697', '7698', '7700', '7701', '7702', '7703', '7704', '7707', '7708', '7724', '7725', '7726', '7727', '7729', '7730', '7731', '7754', '7755', '7759', '7762', '7771', '7772', '7799', '7805', '7817', '7818', '7819', '7820', '7821', '7823', '7824', '7825', '7826', '7827', '7828', '7829', '7831', '7832', '7834', '7882', '7885', '8073', '8202', '8203', '8204', '8205')
			                                    AND DELETED_ON_DATE IS NULL) EW
              ON     H.[ORDER_ACCT] = EW.[HOME_BRANCH]
                 AND H.WRITER_INITIALS = EW.EMP_INITIALS
      WHERE H.ORDER_CODE = 'O' AND LDMS.[CNTRT_CLAIM_AMT] > 0) X
GROUP BY X.[ORDER_ACCT],
         X.AREA,
         X.RPT_NAME,
         X.SELL_WHSE_ID,
         X.[ORDER_ID],
         X.[ORDER_CUST],
         X.CUST_NAME,
         X.[ORDER_DATE],
         X.OML_INIT,
         X.OML_NAME,
         X.WRITER,
         X.WRITER_NAME,
         X.WRITER_LOGON,
         X.[SLSM_ID],
         X.[SALESMAN_NAME],
         X.[CORE_CNTRT_ID],
         X.[CORE_CNTRT_NAME],
         X.[VENDOR_ID],
         X.[VENDOR_NAME],
         X.[VENDOR_AGREEMENT],
         X.[CONTR_START],
         X.[REQRD_SHIP_DATE],
         X.INVOICE_DATE,
         X.SHIP_DATE,
         X.CONTR_EXPIRE,
         X.SHIP_YN,
         X.DAYS_LEFT