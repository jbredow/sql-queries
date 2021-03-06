SELECT  X_REF.DISCOUNT_GROUP_NK,
        --TO_NUMBER (X_REF.DISCOUNT_GROUP_NK) DG_NK,
        X_REF."DESCRIPTION",
        X_REF.BUSCAT2,
        X_REF.HILEV,
        X_REF.DET1,
        X_REF.DET2,
        X_REF.DET3,
        X_REF.DET4,
        X_REF.DET5,
        X_REF.DET6,
        X_REF.DET7,
        X_REF.ZBC,
        X_REF.ZHL,
        X_REF.ZD1,
        X_REF.ZD2,
        X_REF.ZD3,
        X_REF.ZD4,
        X_REF.ZD5,
        X_REF.ZD6,
        X_REF.ZD7,
        X_REF.CODE2,
        X_REF.FAB5_CAT,
        X_REF.COMMODITY_CAT,
        X_REF.PREFERRED
FROM USER_SHARED.BUSGRP_PROD_HIERARCHY X_REF
ORDER BY X_REF.DISCOUNT_GROUP_NK ASC
;
