	SELECT 
  sp.BRANCH,
  sp."ALIAS",
  sp.WRITER,
  sp.SP_TYPE,
  sp.yearmonth,
  sum (sp.EXT_SLS) EXT_SALES,
  sum (sp.GP) EXT_GP,
  sum (sp.SP_EXT_SLS) SP_SLS,
  sum (sp.SP_GP) SP_GP,
  sum (sp."SP- EXT_SLS") "SP-SLS",
  sum (sp."SP- GP") "SP-GP"
  
FROM aaa6863.specials_12mo_0314 sp

--WHERE sp.BRANCH = '13'

GROUP BY 
  sp.BRANCH, 
  sp."ALIAS", 
  sp.WRITER, 
  sp.SP_TYPE, 
  sp.yearmonth

ORDER BY 
  sp.BRANCH,
  sp."ALIAS",
  sp.WRITER,
  sp.SP_TYPE,
  sp.yearmonth;