SELECT HIER.FAB5_CAT,
       HIER.DISCOUNT_GROUP_NK DISC_GRP,
       HIER.DESCRIPTION,
       HIER.DET6 VENDOR
FROM USER_SHARED.BUSGRP_PROD_HIERARCHY HIER
WHERE (HIER.FAB5_CAT IN ('FNW',
                         'LINCOLN',
                         'MIRABELLE',
                         'MONOGRAM',
                         'OTHER MANUFACTURERS', --imported
                         'PARK HARBOR',
                         'PROFLO',
                         'PROSELECT',
                         'RAPTOR',
                         'SIGNATURE HDWR'))
;