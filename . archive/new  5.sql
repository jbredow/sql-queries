SELECT unique 
    WAREHOUSE_NUMBER_NK "Whse #",
    WAREHOUSE_NAME "Whse Name",
    REGIONAL_DC "Reg DC",
    ACCOUNT_NUMBER_NK "Acct #",
    ACCOUNT_NAME "Acct Name"
    
FROM AAA6863.br_reg_dc
  order by 
    ACCOUNT_NAME,
    WAREHOUSE_NUMBER_NK;