SELECT kob.dg_nk,
      dg.discount_group_gk DG_GK,
      dg.discount_group_name DESCRIPTION,
      dg.product_cat CAT,
      dg.product_sub_cat SUB_CAT,
      dg.keyword_sort KW_SORT,
      '|' AS B,
      kob.bottom_30,
      kob.prod_cat,
      kob.comm_ovr_request,
      kob.h_fm_g,
      kob.managed_by_hq,
      kob.showroom

FROM AAA6863.dg_by_kob KOB,
  DW_FEI.discount_group_dimension DG

WHERE  dg.discount_group_nk = LPAD(kob.dg_nk,4,0)
      --AND kob.dg_nk IN (3799, 3918, 6242)
;