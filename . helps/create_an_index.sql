--CREATE AN INDEX

CREATE INDEX index_name ON table_to_be_indexed
	(column_name)
	LOGGING
	NOPARALLEL
	;

/* ############################################################# */

CREATE INDEX AAD9606.HFM_BASELINE_CUST_INDEX ON AAD9606.HFM_BASELINE_CUST
(CUSTOMER_GK)
LOGGING
NOPARALLEL
;

/* ############################################################# */

CREATE INDEX AAA6863.OTHER_MISC_DG_INDEX ON AAA6863.OTHER_MISC_DG
	(DG_NK)
	LOGGING
	NOPARALLEL
	;
	
/* ############################################################# */	