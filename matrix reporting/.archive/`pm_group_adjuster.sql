accept p_disc NUMBER prompt "Please enter mult change"

SELECT DISTINCT PRICE.BRANCH_NUMBER_NK,
    PRICE.PRICE_COLUMN AS PC,
    PRICE.DISC_GROUP AS DG_ALT,
    PRICE.PRICE_TYPE AS PTYPE,
    (SYSDATE+1) AS EFFECTIVE_DATE,
    PRICE.BASIS B,
    CASE
		WHEN &p_disc < 0
			CASE
				WHEN PRICE.OPERATOR_USED = '-'
				  AND (1 - PRICE.MULTIPLIER) / (1 - &p_disc) < 0
			THEN '+'
			WHEN PRICE.OPERATOR_USED = '-'
				  AND (1 - PRICE.MULTIPLIER) / (1 - &p_disc) > 0
			THEN  '-' 
			WHEN PRICE.OPERATOR_USED = '+'
				  AND (1 + PRICE.MULTIPLIER) / (1 - &p_disc) > 0
			THEN '+' 
			WHEN PRICE.OPERATOR_USED = '+'
				  AND (1 + PRICE.MULTIPLIER) / (1 - &p_disc) < 0
			THEN '-'
				  WHEN PRICE.OPERATOR_USED = 'X'
			THEN 'X'
				  ELSE 
				NULL
			END
				  AS OP,
			
			CASE
				WHEN PRICE.OPERATOR_USED = '-' 
				  AND (1 - PRICE.MULTIPLIER) / (1 - &p_disc) < 0
				THEN 
					  ROUND(1 - (1 - PRICE.MULTIPLIER) / (1 - &p_disc), 3)
				WHEN PRICE.OPERATOR_USED = '-' 
					  AND (1 - PRICE.MULTIPLIER) / (1 - &p_disc) > 0
				THEN 
					  ROUND(1 - (1 - PRICE.MULTIPLIER) / (1 - &p_disc), 3)		
				
				WHEN PRICE.OPERATOR_USED = '+'
					  AND (1 + PRICE.MULTIPLIER) / (1 - &p_disc) > 0
				THEN 
					  ROUND(((1 + PRICE.MULTIPLIER) / (1 - &p_disc))-1, 3)
					
				WHEN PRICE.OPERATOR_USED = '+'
					  AND (1 + PRICE.MULTIPLIER) / (1 - &p_disc) < 0
				THEN 
					  ROUND(((1 + PRICE.MULTIPLIER) / (1 - &p_disc)), 3)
				WHEN PRICE.OPERATOR_USED = 'X'
					THEN 
					  ROUND(PRICE.MULTIPLIER / (1 - &p_disc), 3)
				ELSE 
					NULL
			END                        
		
		WHEN &p_disc > 0
			CASE
				WHEN PRICE.OPERATOR_USED = '-'
				  AND (1 - PRICE.MULTIPLIER) / (1 - &p_disc) < 0
			THEN '+'
			WHEN PRICE.OPERATOR_USED = '-'
				  AND (1 - PRICE.MULTIPLIER) / (1 - &p_disc) > 0
			THEN  '-' 
			WHEN PRICE.OPERATOR_USED = '+'
				  AND (1 + PRICE.MULTIPLIER) / (1 - &p_disc) > 0
			THEN '+' 
			WHEN PRICE.OPERATOR_USED = '+'
				  AND (1 + PRICE.MULTIPLIER) / (1 - &p_disc) < 0
			THEN '-'
				  WHEN PRICE.OPERATOR_USED = 'X'
			THEN 'X'
				  ELSE 
				NULL
			END
				  AS OP,
			
			CASE
				WHEN PRICE.OPERATOR_USED = '-' 
				  AND (1 - PRICE.MULTIPLIER) / (1 - &p_disc) < 0
				THEN 
					  ROUND(1 - (1 - PRICE.MULTIPLIER) / (1 - &p_disc), 3)
				WHEN PRICE.OPERATOR_USED = '-' 
					  AND (1 - PRICE.MULTIPLIER) / (1 - &p_disc) > 0
				THEN 
					  ROUND(1 - (1 - PRICE.MULTIPLIER) / (1 - &p_disc), 3)		
				
				WHEN PRICE.OPERATOR_USED = '+'
					  AND (1 + PRICE.MULTIPLIER) / (1 - &p_disc) > 0
				THEN 
					  ROUND(((1 + PRICE.MULTIPLIER) / (1 - &p_disc))-1, 3)
					
				WHEN PRICE.OPERATOR_USED = '+'
					  AND (1 + PRICE.MULTIPLIER) / (1 - &p_disc) < 0
				THEN 
					  ROUND(((1 + PRICE.MULTIPLIER) / (1 - &p_disc)), 3)
				WHEN PRICE.OPERATOR_USED = 'X'
					THEN 
					  ROUND(PRICE.MULTIPLIER / (1 - &p_disc), 3)
				ELSE 
					NULL
			END                        
		ELSE PRICE.MULTIPLIER
	END	
		AS NEW_FACTOR,    
    
    --Extra Info
    ROUND(PRICE.MULTIPLIER, 4) EXISTING_FACTOR,
    'G#' || PRICE.DISC_GROUP || '*' || PRICE.PRICE_COLUMN AS TRICOMBO,
    PRICE.UPDATE_TIMESTAMP UPDATE_DATE,
    CONTACTS.RPC
    
FROM DW_FEI.PRICE_DIMENSION PRICE,
     AAF1046.BRANCH_CONTACTS CONTACTS

WHERE PRICE.BRANCH_NUMBER_NK = CONTACTS.ACCOUNT_NK
    AND PRICE.PRICE_TYPE = 'G'
    AND PRICE.DELETE_DATE IS NULL
    
    --CHOOSE RPC
    AND CONTACTS.RPC = 'Midwest'
    
    --CHOOSE BRANCH
    --AND CONTACTS.ACCOUNT_NK IN(2000,61)
    
    --CHOOSE DGS
    AND PRICE.DISC_GROUP IN(504, 505, 508, 511, 513, 517, 525, 528, 529, 533, 534)
	
ORDER BY PRICE.BRANCH_NUMBER_NK,
    PRICE.DISC_GROUP,
    PRICE.PRICE_COLUMN;