SELECT dg.* 
  FROM dw_fei.branch_disc_group_dimension dg, aad9606.branch_contacts bc 
 WHERE     dg.ACCOUNT_NUMBER_NK = bc.ACCOUNT_NK 
       AND UPPER (bc.RPC) = 'MIDWEST' 
       AND DG.BRANCH_DISC_GROUP_NK = '&INPUT_DG'
