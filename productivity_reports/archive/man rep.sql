--single month set at March 13
SELECT  vict2."Acct",
		vict2."Branch",
		vict2."Sale_Type",
		vict2."OML_INI",
		vict2."OML_Name",
		vict2."Writer_Init",
		vict2."Writer_Name",
		vict2."Assoc_Name",
		vict2."Whse",
		vict2."Inv_#",
		vict2."Inv_Ln",
		vict2."Ship_Via",
		vict2."Cust_#",
		vict2."Cust_Name",
		vict2."Main_Cust",
		vict2."PC",
		vict2."Cont_Desc",
		vict2."Cont_#",
		vict2."Cust_Type",
		vict2."Job_Y/N",
		vict2."Job_Name",
		vict2."PID",
		vict2."Alt1_Code",
		vict2."Product_Name",
		vict2."ST",
		vict2."MFGR",
		vict2."Shpd",
		vict2."Unit_Net",
		vict2."Price_Code",
		vict2."Price_Cat",
		vict2."Cat_Ovr",
		vict2."Form",
		vict2."Ext_Sales",
		vict2."Ext_AC",
		vict2."Rep_Cost",
		vict2."Inv_Cost",
		vict2."Matrix",
		vict2."List",
		vict2."PO_Cost",
		vict2."DG",
		vict2."DG_Name",
		vict2."Consign_Type",
		vict2."Cr_Code",
		vict2."Cr_Memo_Type",
		vict2."Process",
		vict2."PO_Nk",
		vict2."PO_#",
		vict2."Pr_Ovr",
		vict2."Pr_Ovr_Bas",
		vict2."Grp_Ovr",
		vict2."Trim_Form",
		vict2."Ord_Cd",
		vict2."Source_System",
		vict2."Bid_#",
		vict2."Source",
		vict2."Matrix" - "Unit Net" AS "Var",
		vict2."Ext AC" / "Shpd" AS "Unit_AC"
		
FROM PR_VICT2_CUST_12MO vict2
  
WHERE 	vict2."Acct" = '56'
	
	AND vict2."Process" = (SELECT MAX(process) FROM aaa6863.pr_vict2_12mo)
		--TO_DATE('201303','yyyy/mm')
 
GROUP BY vict2."Acct",
		vict2."Branch",
		vict2."Writer_Init",
		vict2."Writer_Name",
		vict2."Assoc_Name",
		vict2."OML_INI",
		vict2."OML_Name",
		vict2."PC",
		vict2."Whse",
		vict2."Inv_#",
		vict2."Inv_Ln",
		vict2."Ship_Via",
		vict2."Cust_#",
		vict2."Cust_Name",
		vict2."Main_Cust",
		vict2."PID",
		vict2."Alt1_Code",
		vict2."Product_Name",
		vict2."ST",
		vict2."Shpd",
		vict2."Unit_Net",
		vict2."Matrix",
		vict2."Ext_Sales",
		vict2."Ext_AC",
		vict2."Rep_Cost",
		vict2."Inv_Cost",
		vict2."List",
		vict2."PO_Cost",
		vict2."DG",
		vict2."DG_Name",
		vict2."Form",
		vict2."Price_Code",
		vict2."Price_Cat",
		vict2."Cat_Ovr",
		vict2."Bid_#",
		vict2."Source",
		vict2."Sale_Type",
		vict2."Ord_Cd",
		vict2."Consign_Type",
		vict2."Cont_Desc",
		vict2."Cont_#",
		vict2."Cust_Type",
		vict2."Job_Y/N",
		vict2."Job_Name",
		vict2."MFGR",
		vict2."Cr_Code",
		vict2."Cr_Memo_Type",
		vict2."Process",
		vict2."PO_Nk",
		vict2."PO_#",
		vict2."Pr_Ovr",
		vict2."Pr_Ovr_Bas",
		vict2."Grp_Ovr",
		vict2."Trim_Form",
		vict2."Source_System"
	

ORDER BY vict2."Branch",
		vict2."Writer_Init",
		vict2."Cust_Name",
		vict2."Cust_#",
		vict2."DG",
		vict2."Alt1_Code"
		;