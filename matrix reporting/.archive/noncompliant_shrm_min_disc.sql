SELECT SR_NC_GROUP.Branch_Num,
	SR_NC_GROUP.Branch_Name,
	--'N/A' AS PID,
	--'N/A' AS ALT,  
	SR_NC_GROUP.DG,
	SR_NC_GROUP.PC,
	SR_NC_GROUP.GBasis,
	SR_NC_GROUP.GOper,
	SR_NC_GROUP.GFactor,
	SR_NC_GROUP.GDisc,
	SR_NC_GROUP.SR_MING AS SRMIN,
	'SRMINGROUP' AS PSOURCE,
		  
	CASE
		WHEN SR_NC_GROUP.SR_MING > SR_NC_GROUP.GDisc  
		THEN 'Y'
		ELSE 'N'
	END
		AS POTENTIAL_MIN_DISCOUNT_ISSUE,
	CASE
		WHEN SR_NC_GROUP.SR_MING > SR_NC_GROUP.GDisc  
		THEN SR_NC_GROUP.TRICOMBO
		ELSE
	END
		AS Tri_Combo_Correction,
	CASE
		WHEN SR_NC_GROUP.SR_MING > SR_NC_GROUP.GDisc  
		WHEN 'L-' || SR_NC_GROUP.SR_MING
		ELSE 'N/A'
	END
		AS FORM_TO_LOAD,
	SR_NC_GROUP.RPC
FROM (
      SELECT 
        PRICE.BRANCH_NUMBER_NK Branch_Num,
        CONTACTS.ALIAS Branch_Name,  
        PRICE.PRICE_ID TRICOMBO,  
        PRICE.PRICE_TYPE,
        PRICE.DISC_GROUP DG,  
        PRICE.PRICE_COLUMN PC,  
        PRICE.BASIS GBasis,
        PRICE.OPERATOR_USED GOper,    
        ROUND(PRICE.MULTIPLIER, 4) GFactor,
        
        CASE      
          --L Based Group Matrix Modifications
            WHEN (PRICE.BASIS = 'L' AND PRICE.OPERATOR_USED = '-') 
              THEN ROUND((PRICE.MULTIPLIER),3)
            WHEN (PRICE.BASIS = 'L' AND PRICE.OPERATOR_USED = 'X') 
              THEN ROUND(1-PRICE.MULTIPLIER,3)
            WHEN (PRICE.BASIS = 'L' AND PRICE.OPERATOR_USED = '+') 
              THEN ROUND(1-(1+PRICE.MULTIPLIER),3)
            ELSE        
              ROUND(PRICE.MULTIPLIER-PRICE.MULTIPLIER)
        END
          AS GDisc,
        
        SR.SR_MING,  
        CONTACTS.RPC

        FROM DW_FEI.PRICE_DIMENSION PRICE,  
          AAF1046.BRANCH_CONTACTS CONTACTS,
          AAF1046.SHOWROOMMING SR
    
        WHERE PRICE.BRANCH_NUMBER_NK = CONTACTS.ACCOUNT_NK
          AND PRICE.DISC_GROUP = SR.SR_DG
          AND PRICE.DELETE_DATE IS NULL
          AND PRICE.PRICE_TYPE = 'G'
          AND CONTACTS.RPC = 'Midwest'
          --AND PRICE.BRANCH_NUMBER_NK = '13'   
          --AND PRICE.PRICE_COLUMN IN (24)
          AND PRICE.PRICE_COLUMN NOT IN (0,23)
          )SR_NC_GROUP;SELECT SR_NC_GROUP.Branch_Num,
          SR_NC_GROUP.Branch_Name,
          --'N/A' AS PID,
          --'N/A' AS ALT,  
          SR_NC_GROUP.DG,
          SR_NC_GROUP.PC,
          SR_NC_GROUP.GBasis,
          SR_NC_GROUP.GOper,
          SR_NC_GROUP.GFactor,
          SR_NC_GROUP.GDisc,
          /*NULL AS PBasis,
          NULL AS POper,
          NULL AS PFactor,
          NULL AS PDisc,*/
          SR_NC_GROUP.SR_MING AS SRMIN,
          'SRMINGROUP' AS PSOURCE,
          
          CASE
            WHEN SR_NC_GROUP.SR_MING > SR_NC_GROUP.GDisc  THEN 'Y'
            ELSE
            'N'
          END
            AS POTENTIAL_MIN_DISCOUNT_ISSUE,
          
          CASE
            WHEN SR_NC_GROUP.SR_MING > SR_NC_GROUP.GDisc  THEN SR_NC_GROUP.TRICOMBO
            ELSE
            'Compliant. No Load'
            END
            AS Tri_Combo_Correction,
            
          CASE
            WHEN SR_NC_GROUP.SR_MING > SR_NC_GROUP.GDisc  THEN 'L-' || SR_NC_GROUP.SR_MING
            ELSE
            'N/A'
            END
            AS FORM_TO_LOAD,
          
          SR_NC_GROUP.RPC
		  
		FROM (SELECT PRICE.BRANCH_NUMBER_NK Branch_Num,
		  CONTACTS.ALIAS Branch_Name,  
		  PRICE.PRICE_ID TRICOMBO,  
		  PRICE.PRICE_TYPE,
		  PRICE.DISC_GROUP DG,  
		  PRICE.PRICE_COLUMN PC,  
		  PRICE.BASIS GBasis,
		  PRICE.OPERATOR_USED GOper,    
		  ROUND(PRICE.MULTIPLIER, 4) GFactor,
		  
		  CASE  --L Based Group Matrix Modifications
					  WHEN (PRICE.BASIS = 'L' AND PRICE.OPERATOR_USED = '-') 
              THEN ROUND((PRICE.MULTIPLIER),3)
					  WHEN (PRICE.BASIS = 'L' AND PRICE.OPERATOR_USED = 'X') 
              THEN ROUND(1-PRICE.MULTIPLIER,3)
					  WHEN (PRICE.BASIS = 'L' AND PRICE.OPERATOR_USED = '+') 
              THEN ROUND(1-(1+PRICE.MULTIPLIER),3)
						ELSE ROUND(PRICE.MULTIPLIER-PRICE.MULTIPLIER)
        END
		  AS GDisc,
			
		  SR.SR_MING,  
		  CONTACTS.RPC

		FROM DW_FEI.PRICE_DIMENSION PRICE,  
		  AAF1046.BRANCH_CONTACTS CONTACTS,
		  AAF1046.SHOWROOMMING SR

		WHERE PRICE.BRANCH_NUMBER_NK = CONTACTS.ACCOUNT_NK
		  AND PRICE.DISC_GROUP = SR.SR_DG
		  AND PRICE.DELETE_DATE IS NULL
		  AND PRICE.PRICE_TYPE = 'G'
		  AND CONTACTS.RPC = 'Midwest'
		  --AND PRICE.BRANCH_NUMBER_NK = '13'
      --AND SR.SR_MING > SR_NC_GROUP.GDisc
		  --AND PRICE.PRICE_COLUMN IN (24)
		  AND PRICE.PRICE_COLUMN NOT IN (0,23)
		  )SR_NC_GROUP
	;