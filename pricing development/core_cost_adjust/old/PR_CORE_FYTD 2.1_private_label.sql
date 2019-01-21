/*
      private label only report
*/

DROP TABLE AAA6863.PR_CORE_YOY2_PL;

CREATE TABLE AAA6863.PR_CORE_YOY2_PL

AS 

   SELECT TPD.FISCAL_YEAR_TO_DATE TPD,
          SWD.DIVISION_NAME REGION,
          SWD.REGION_NAME DISTRICT,
          IHF.ACCOUNT_NUMBER,
          SWD.ACCOUNT_NAME,
          IHF.YEARMONTH,
					
          DECODE (ihf.SALE_TYPE,
                  '1', 'Our Truck',
                  '2', 'Counter',
                  '3', 'Direct',
                  '4', 'Counter',
                  '5', 'Credit Memo',
                  '6', 'Showroom',
                  '7', 'Showroom Direct',
                  '8', 'eBusiness')
             TYPE_OF_SALE,
          
					EMP.TITLE_DESC,
					REPS.SALESREP_NK,
					REPS.SALESREP_NAME,
					
					CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NULL
             THEN
                'H/U'
             WHEN (   EMP.TITLE_DESC LIKE '%O/S%'
                   OR EMP.TITLE_DESC LIKE 'Out Sales%'
                   OR EMP.TITLE_DESC LIKE 'Sales Rep%')
             THEN
                'O/S'
             ELSE
                'H/A'
          END
             AS HOUSE_FLAG,
          NVL (PROD.DISCOUNT_GROUP_NK, 'SP-') DISCOUNT_GROUP_NK,
          COUNT (ILF.INVOICE_LINE_NUMBER) LINES,
          
					SUM (ILF.EXT_AVG_COGS_AMOUNT) AVG_COGS,
          SUM (ILF.EXT_ACTUAL_COGS_AMOUNT) INVOICE_COGS,
          SUM (ILF.EXT_SALES_AMOUNT) SALES,
          SUM (ILF.CORE_ADJ_AVG_COST) CORE_ADJ_AVG_COGS,
          SUM (
             CASE
                WHEN ILF.SUM_MV_CLAIM_AMOUNT > 0
                THEN
                   ILF.CORE_ADJ_AVG_COST
                WHEN     CORE.SUBLINE_COST IS NOT NULL
                     AND CORE.SUBLINE_QTY IS NULL
                THEN
                     CORE.SUBLINE_COST
                   * ILF.SHIPPED_QTY
                   / NVL (PROD.SELL_PACKAGE_QTY, 1)
                ELSE
                   ILF.EXT_AVG_COGS_AMOUNT
             END)
             CORE_COST_SUBTOTAL
     FROM DW_FEI.INVOICE_HEADER_FACT IHF,
          DW_FEI.INVOICE_LINE_FACT ILF,
          DW_FEI.INVOICE_LINE_CORE_FACT CORE,
          DW_FEI.PRODUCT_DIMENSION PROD,
          DW_FEI.CUSTOMER_DIMENSION CUST,
          DW_FEI.SALESREP_DIMENSION REPS,
          DW_FEI.EMPLOYEE_DIMENSION EMP,
          SALES_MART.SALES_WAREHOUSE_DIM SWD,
          SALES_MART.TIME_PERIOD_DIMENSION TPD
    --DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD
    WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK 
          --AND ILF.PRODUCT_STATUS = 'SP'
          --AND IHF.INVOICE_NUMBER_GK = CORE.INVOICE_NUMBER_GK(+)
          AND ILF.INVOICE_NUMBER_GK = CORE.INVOICE_NUMBER_GK(+)
          AND ILF.INVOICE_LINE_NUMBER = CORE.INVOICE_LINE_NUMBER(+)
          AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
          --AND IHF.ACCOUNT_NUMBER = '52'
          AND IHF.YEARMONTH = TPD.YEARMONTH
          AND CUST.ACCOUNT_NUMBER_NK = REPS.ACCOUNT_NUMBER_NK
          AND CUST.SALESMAN_CODE = REPS.SALESREP_NK
          AND REPS.EMPLOYEE_NUMBER_NK = EMP.EMPLOYEE_TRILOGIE_NK(+)
          AND PROD.DISCOUNT_GROUP_NK IN ( '1318',
                                          '1396',
                                          '1781',
                                          '1789',
                                          '2647',
                                          '3111',
                                          '3112',
                                          '3115',
                                          '3117',
                                          '3119',
                                          '3122',
                                          '3123',
                                          '3127',
                                          '3129',
                                          '3137',
                                          '3138',
                                          '3145',
                                          '3373',
                                          '3376',
                                          '3385',
                                          '3386',
                                          '3390',
                                          '3397',
                                          '4011',
                                          '4013',
                                          '4023',
                                          '4027',
                                          '4028',
                                          '4029',
                                          '4030',
                                          '4032',
                                          '4033',
                                          '4035',
                                          '4037',
                                          '4040',
                                          '4041',
                                          '4042',
                                          '4047',
                                          '4048',
                                          '4049',
                                          '4053',
                                          '4078',
                                          '4086',
                                          '4091',
                                          '4092',
                                          '4093',
                                          '4094',
                                          '4111',
                                          '4118',
                                          '4119',
                                          '4128',
                                          '4129',
                                          '4130',
                                          '4131',
                                          '4132',
                                          '4137',
                                          '4138',
                                          '4139',
                                          '4140',
                                          '4141',
                                          '4142',
                                          '4143',
                                          '4144',
                                          '4147',
                                          '4148',
                                          '4149',
                                          '4150',
                                          '4151',
                                          '4152',
                                          '4153',
                                          '4155',
                                          '4156',
                                          '4157',
                                          '4158',
                                          '4161',
                                          '4162',
                                          '4164',
                                          '4165',
                                          '4166',
                                          '4167',
                                          '4168',
                                          '4171',
                                          '4173',
                                          '4177',
                                          '4179',
                                          '4180',
                                          '4181',
                                          '4182',
                                          '4183',
                                          '4184',
                                          '4185',
                                          '4187',
                                          '4188',
                                          '4189',
                                          '4192',
                                          '4194',
                                          '4198',
                                          '4207',
                                          '4208',
                                          '4210',
                                          '4211',
                                          '4213',
                                          '4214',
                                          '4216',
                                          '4217',
                                          '4218',
                                          '4219',
                                          '4220',
                                          '4227',
                                          '4228',
                                          '4229',
                                          '4230',
                                          '4231',
                                          '4233',
                                          '4234',
                                          '4235',
                                          '4237',
                                          '4248',
                                          '4249',
                                          '4251',
                                          '4254',
                                          '4256',
                                          '4259',
                                          '4260',
                                          '4265',
                                          '4269',
                                          '4272',
                                          '4274',
                                          '4291',
                                          '4292',
                                          '4293',
                                          '4294',
                                          '4297',
                                          '4302',
                                          '4303',
                                          '4304',
                                          '4306',
                                          '4307',
                                          '4309',
                                          '4311',
                                          '4316',
                                          '4318',
                                          '4338',
                                          '4348',
                                          '4356',
                                          '4357',
                                          '4422',
                                          '4423',
                                          '4424',
                                          '4427',
                                          '4428',
                                          '6879',
                                          '6880',
                                          '6884',
                                          '6885',
                                          '6889',
                                          '6892',
                                          '6893',
                                          '6894',
                                          '6895',
                                          '6899',
                                          '6904',
                                          '6938',
                                          '6948',
                                          '6999',
                                          '9271',
                                          '9273',
                                          '9274',
                                          '3166',
                                          '3179',
                                          '3184',
                                          '3185',
                                          '3186',
                                          '3187',
                                          '3188',
                                          '3189',
                                          '3195',
                                          '3203',
                                          '3774',
                                          '3966',
                                          '4258',
                                          '4278',
                                          '6883',
                                          '8504',
                                          '9318',
                                          '9321',
                                          '9385',
                                          '4039',
                                          '4126',
                                          '4176',
                                          '4190',
                                          '4221',
                                          '4222',
                                          '4223',
                                          '4261',
                                          '4276',
                                          '4299',
                                          '4334',
                                          '4345',
                                          '4349',
                                          '4350',
                                          '4351',
                                          '4352',
                                          '4353',
                                          '4354',
                                          '4358',
                                          '4359',
                                          '4366',
                                          '6578',
                                          '6581',
                                          '6886',
                                          '6900',
                                          '6909',
                                          '6941',
                                          '6949',
                                          '2733',
                                          '3374',
                                          '3381',
                                          '3382',
                                          '3383',
                                          '3387',
                                          '3388',
                                          '3391',
                                          '3423',
                                          '3480',
                                          '3481',
                                          '745',
                                          '786',
                                          '846',
                                          '847',
                                          '848',
                                          '849',
                                          '850',
                                          '851',
                                          '852',
                                          '853',
                                          '862',
                                          '865',
                                          '867',
                                          '868',
                                          '983',
                                          '1002',
                                          '1021',
                                          '1069',
                                          '1263',
                                          '1264',
                                          '1267',
                                          '1268',
                                          '1270',
                                          '1271',
                                          '1273',
                                          '1274',
                                          '1277',
                                          '1278',
                                          '1279',
                                          '1280',
                                          '1281',
                                          '1282',
                                          '1283',
                                          '1284',
                                          '1285',
                                          '1286',
                                          '1287',
                                          '1288',
                                          '1289',
                                          '1291',
                                          '1292',
                                          '1293',
                                          '1294',
                                          '1295',
                                          '1296',
                                          '1297',
                                          '1299',
                                          '1300',
                                          '1301',
                                          '1302',
                                          '1303',
                                          '1304',
                                          '1308',
                                          '1309',
                                          '1311',
                                          '1312',
                                          '1313',
                                          '1314',
                                          '1315',
                                          '1316',
                                          '1317',
                                          '1833',
                                          '2012',
                                          '2031',
                                          '2040',
                                          '2051',
                                          '2057',
                                          '2058',
                                          '2075',
                                          '2117',
                                          '2654',
                                          '2655',
                                          '2679',
                                          '3396',
                                          '3467',
                                          '3468',
                                          '4160',
                                          '4225',
                                          '4250',
                                          '4271',
                                          '4295',
                                          '5129',
                                          '5130',
                                          '6632',
                                          '6633',
                                          '6902',
                                          '6917',
                                          '6939',
                                          '6942',
                                          '6943',
                                          '6945',
                                          '8357',
                                          '8358',
                                          '8359',
                                          '8361',
                                          '8362',
                                          '8363',
                                          '8364',
                                          '8365',
                                          '8366',
                                          '8367',
                                          '8368',
                                          '8369',
                                          '9975',
                                          '1819',
                                          '1834',
                                          '1836',
                                          '1837',
                                          '3169',
                                          '3170',
                                          '3173',
                                          '3176',
                                          '6580',
                                          '6582'
                                          )
          /*AND EMP.TITLE_CODE IN ('1152',
                                 '1172',
                                 '1180',
                                 '1182',
                                 '1190',
                                 '1402',
                                 '1735',
                                 '2228',
                                 '2231',
                                 '3074',
                                 '4369',
                                 '4447',
                                 '4465',
                                 '4662',
                                 '7396',
                                 '7397',
                                 '7398',
                                 '7399',
                                 '7399',
                                 '7400',
                                 '7403',
                                 '7404',
                                 '7405',
                                 '7406',
                                 '7407',
                                 '7408',
                                 '7409',
                                 '7410',
                                 '7411')*/
          AND TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
          AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
          AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
          AND IHF.IC_FLAG = 0
          AND ILF.SHIPPED_QTY <> 0
          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
          AND IHF.YEARMONTH = ILF.YEARMONTH
          --AND IHF.YEARMONTH = CORE.YEARMONTH
          --AND ILF.YEARMONTH = CORE.YEARMONTH
          --AND IHF.YEARMONTH = 201708
          --AND ILF.YEARMONTH = 201708
          --AND REPS.OUTSIDE_SALES_FLAG = 'Y'
          AND IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
          AND SWD.DIVISION_NAME IN ('EAST REGION',
                                    'HVAC REGION',
                                    'NORTH CENTRAL REGION',
                                    'SOUTH CENTRAL REGION',
                                    --'WATERWORKS REGION',
                                    'WEST REGION')
					
					
					
   GROUP BY TPD.FISCAL_YEAR_TO_DATE ,
          SWD.DIVISION_NAME ,
          SWD.REGION_NAME ,
          IHF.ACCOUNT_NUMBER,
          SWD.ACCOUNT_NAME,
          IHF.YEARMONTH,
          DECODE (ihf.SALE_TYPE,
                  '1', 'Our Truck',
                  '2', 'Counter',
                  '3', 'Direct',
                  '4', 'Counter',
                  '5', 'Credit Memo',
                  '6', 'Showroom',
                  '7', 'Showroom Direct',
                  '8', 'eBusiness')
             ,
          
					EMP.TITLE_DESC,
					REPS.SALESREP_NK,
					REPS.SALESREP_NAME,
					
					CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NULL
             THEN
                'H/U'
             WHEN (   EMP.TITLE_DESC LIKE '%O/S%'
                   OR EMP.TITLE_DESC LIKE 'Out Sales%'
                   OR EMP.TITLE_DESC LIKE 'Sales Rep%')
             THEN
                'O/S'
             ELSE
                'H/A'
          END,
          NVL (PROD.DISCOUNT_GROUP_NK, 'SP-')
          /*COUNT (ILF.INVOICE_LINE_NUMBER) LINES,
          
					SUM (ILF.EXT_AVG_COGS_AMOUNT) AVG_COGS,
          SUM (ILF.EXT_ACTUAL_COGS_AMOUNT) INVOICE_COGS,
          SUM (ILF.EXT_SALES_AMOUNT) SALES,
          SUM (ILF.CORE_ADJ_AVG_COST) CORE_ADJ_AVG_COGS,
          SUM (
             CASE
                WHEN ILF.SUM_MV_CLAIM_AMOUNT > 0
                THEN
                   ILF.CORE_ADJ_AVG_COST
                WHEN     CORE.SUBLINE_COST IS NOT NULL
                     AND CORE.SUBLINE_QTY IS NULL
                THEN
                     CORE.SUBLINE_COST
                   * ILF.SHIPPED_QTY
                   / NVL (PROD.SELL_PACKAGE_QTY, 1)
                ELSE
                   ILF.EXT_AVG_COGS_AMOUNT
             END)
             CORE_COST_SUBTOTAL*/
		;