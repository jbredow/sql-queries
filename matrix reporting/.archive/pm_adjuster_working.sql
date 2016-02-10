
accept p_disc NUMBER prompt "Please enter mult change"

SELECT fin.BR,
	fin.PC,
	fin.DG_ALT,
	fin.PTYPE,
	fin.C_MULT,
	fin.NEW_DISC,
	fin.chg,
	fin.existing_factor,
	fin.tricombo,
	fin.b,
	CASE
		WHEN fin.NEW_DISC > 1 
		THEN '+'
		ELSE '-'
	END
		AS OP,
	fin.new_disc,
	fin.update_date upd
FROM(SELECT mtx.branch_number_nk BR,
		mtx.PC,
		mtx.DG_ALT,
		mtx.PTYPE,
		mtx.current_mult C_MULT,
		
		CASE
			WHEN	 ROUND (&p_disc, 3) > 0
				THEN	 ROUND (1 - (current_mult / (1 - &p_disc)), 3)
			WHEN	 ROUND (&p_disc, 3) < 0
				THEN	 ROUND (1 - (current_mult * (1 + &p_disc)), 3)
			ELSE current_mult
		END	
			AS NEW_DISC,
			
		&p_disc AS CHG,
		mtx.existing_factor,
		mtx.tricombo,
		mtx.b,
		
		mtx.update_date,
		mtx.rpc
		
	FROM (SELECT DISTINCT PRICE.BRANCH_NUMBER_NK,
			PRICE.PRICE_COLUMN AS PC,
			PRICE.DISC_GROUP AS DG_ALT,
			PRICE.PRICE_TYPE AS PTYPE,
			--'|' AS '|'
			CASE
				WHEN PRICE.OPERATOR_USED = '-'
				THEN ROUND (1 - PRICE.MULTIPLIER, 3)
				WHEN PRICE.OPERATOR_USED = '+'
				THEN ROUND (1 + PRICE.MULTIPLIER, 3)
				WHEN PRICE.OPERATOR_USED = 'X'
				THEN ROUND (PRICE.MULTIPLIER, 3)
				ELSE NULL
			END
				AS CURRENT_MULT,
			PRICE.BASIS B,
			ROUND(PRICE.MULTIPLIER, 4) EXISTING_FACTOR,
			'G#' || PRICE.DISC_GROUP || '*' || PRICE.PRICE_COLUMN AS TRICOMBO,
			PRICE.UPDATE_TIMESTAMP UPDATE_DATE,
			CONTACTS.RPC
			
		FROM DW_FEI.PRICE_DIMENSION PRICE,
			 AAA6863.BRANCH_CONTACTS CONTACTS

		WHERE PRICE.BRANCH_NUMBER_NK = CONTACTS.ACCOUNT_NK
			AND PRICE.PRICE_TYPE = 'G'
			AND PRICE.DELETE_DATE IS NULL
			
			--CHOOSE RPC
			AND CONTACTS.RPC = 'Midwest'
			
			--CHOOSE BRANCH(S)
			AND CONTACTS.ACCOUNT_NK IN(13)
			
			--CHOOSE DGS
			AND PRICE.DISC_GROUP IN(504, 505)
			
		ORDER BY PRICE.BRANCH_NUMBER_NK,
			PRICE.DISC_GROUP,
			PRICE.PRICE_COLUMN
			) mtx
		)fin
		;