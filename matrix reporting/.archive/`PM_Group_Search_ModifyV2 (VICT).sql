accept p_disc NUMBER prompt "Please enter mult change"

SELECT DISTINCT PRICE.BRANCH_NUMBER_NK,
    PRICE.PRICE_COLUMN AS PC,
    PRICE.DISC_GROUP AS DG_ALT,
    PRICE.PRICE_TYPE AS PTYPE,
    (SYSDATE+1) AS EFFECTIVE_DATE,
    PRICE.BASIS B,
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
    AND CONTACTS.ACCOUNT_NK IN(2000,61)
    
    --CHOOSE DGS
    AND PRICE.DISC_GROUP IN(1870, 6790, 6791, 6800, 6801, 6802, 6808, 6953, 6954, 
		6955, 6956, 6957, 6958, 6959, 6960, 6961, 6962, 6963, 6964, 6965, 6966, 6967, 
		6968, 6969, 6970, 6971, 6972, 6973, 6974, 6975, 6976, 6977, 6978, 6979, 8523, 
		8524, 8526, 8527, 8528, 8529, 8599, 8600, 8697, 8698, 8812, 8813, 8814, 8815, 
		8816, 8817, 8819, 8820, 8821, 8822, 8824, 8825, 8826, 8827, 8828, 8829, 8830, 
		8831, 8832, 8833, 8834, 8835, 8836, 8837, 8838, 8839, 8840, 8841, 8842, 8843, 
		8844, 8845, 8846, 8847, 8848, 8849, 8850, 8851, 8852, 8853, 8854, 8855, 8856, 
		8857, 8858, 8859, 8860, 8861, 8862, 8863, 8864, 8865, 8866, 8867, 8868, 8869, 
		8870, 8871, 8872, 8873, 8874, 8875, 8876, 8877, 8878, 8879, 8880, 8881, 8882, 
		8883, 8884, 8885, 8887, 8888, 8892, 8894, 8895, 8896, 8897, 8898, 8899, 8900, 
		8902, 8903, 8904, 8905, 8906, 8908, 8909, 8910, 8911, 8913, 8914, 8915, 8916, 
		8917, 8918, 8919, 8922, 8929, 8931, 8946)
	
ORDER BY PRICE.BRANCH_NUMBER_NK,
    PRICE.DISC_GROUP,
    PRICE.PRICE_COLUMN;