-- Sale Type
CASE 
  WHEN ([Presentation View].[Price Management Data].[Sales Type] IN (#promptmany('st', 'Varchar')#) )
  THEN 
  CASE
    WHEN [Presentation View].[Price Management Data].[Sales Type] IN ('COUNTER CASH','COUNTER CASH PICK UP')
    THEN 'COUNTER'
    WHEN [Presentation View].[Price Management Data].[Sales Type] IN ('SHOWROOM','SHOWROOM DIRECT')
    THEN 'SHOWROOM'
    ELSE [Presentation View].[Price Management Data].[Sales Type]
  END
  ELSE ('dummy')
END



-- Order Code
CASE 
    WHEN ([Presentation View].[Price Management Data].[Order Code] IN (#promptmany('oc', 'Varchar')#) )
	THEN
        (CASE WHEN [Presentation View].[Price Management Data].[Order Code] = 'CS'
        THEN 'CS - CASH SALE'
        WHEN [Presentation View].[Price Management Data].[Order Code] = 'IC'
        THEN 'IC - INVOICED CREDIT'
        WHEN [Presentation View].[Price Management Data].[Order Code] = 'ID'
        THEN 'ID - INVOICED DIRECT'
        WHEN [Presentation View].[Price Management Data].[Order Code] = 'IO'
        THEN 'IO - INVOICED ORDER'
        ELSE [Presentation View].[Price Management Data].[Order Code]
    END)
    ELSE (' ')
END


-- Source System
CASE 
    WHEN ([Presentation View].[Price Management Data].[Price Column] IN (#promptmany('pc', 'Varchar')#) )
    THEN [Presentation View].[Source System Lookup].[Source System] 
    ELSE ('NULL')
END




-- sum based on condition
IF( [Price Category]='SPECIAL' OR [Price Category] is null) then (COALESCE([Ext Sales Amount],0))
else 
(0)

IF( [Price Category]='CREDITS') then (COALESCE([Ext Sales Amount],0))
else 
(0)

COALESCE([SPECIAL_GP$]/[SPECIAL_SALES],0)
	
-- only show column if selected:
CASE 
	WHEN ([Presentation View].[Combined Warehouse Dimension].[Alias Name]
	 	IN (#promptmany('acc', 'Varchar')#) )
	THEN [Presentation View].[Combined Warehouse Dimension].[Alias Name]
	ELSE ('dummy')
END

-- clears column when not selected in set-up page
CASE 
       WHEN ([Presentation View].[Combined Warehouse Dimension].[Warehouse Number].[Price Column] IN (#promptmany('whse', 'Varchar')#) )
	   THEN to_number([Presentation View].[Combined Warehouse Dimension].[Warehouse Number])
       ELSE (' ')
END


-- price type cleanup
CASE 
       WHEN ([Presentation View].[Price Management Data].[Sales Type] IN (#promptmany('st', 'Varchar')#) )
       THEN 
       CASE
            WHEN [Presentation View].[Price Management Data].[Sales Type] IN ('COUNTER CASH','COUNTER CASH PICK UP')
            THEN 'COUNTER'
            WHEN [Presentation View].[Price Management Data].[Sales Type] IN ('SHOWROOM','SHOWROOM DIRECT')
            THEN 'SHOWROOM'
            ELSE [Presentation View].[Price Management Data].[Sales Type]
       END
       ELSE ('dummy')
END

-- ####################

CASE
    WHEN ([Presentation View].[Price Management Data].[Product Type] IN (#promptmany('pt', 'Varchar')#) )
    THEN   [Presentation View].[Price Management Data].[Product Type]
    ELSE ('dummy')
END

-- ####################

CASE 
  WHEN ([Presentation View].[Price Management Data].[Sales Type] 
      IN (#promptmany('st', 'Varchar')#) )
  THEN 
      CASE
        WHEN [Presentation View].[Price Management Data].[Sales Type] 
            IN ('COUNTER CASH','COUNTER CASH PICK UP')
        THEN 'COUNTER'
        WHEN [Presentation View].[Price Management Data].[Sales Type] 
            IN ('SHOWROOM','SHOWROOM DIRECT')
        THEN 'SHOWROOM'
        ELSE [Presentation View].[Price Management Data].[Sales Type]
      END
  ELSE ('dummy')
END


CASE 
     WHEN ([Presentation View].[Price Management Data].[Order Code] IN (#promptmany('oc', 'Varchar')#) ) 
     THEN (
          CASE 
               WHEN  [Presentation View].[Price Management Data].[Order Code] = 'CS' 
               THEN    'CS - CASH SALE'
               WHEN  [Presentation View].[Price Management Data].[Order Code] = 'IC' 
               THEN    'IC - INVOICED CREDIT'
               WHEN  [Presentation View].[Price Management Data].[Order Code] = 'ID' 
               THEN   'ID - INVOICED DIRECT'
               WHEN [Presentation View].[Price Management Data].[Order Code] = 'IO' 
               THEN 'IO - INVOICED ORDER'
               ELSE [Presentation View].[Price Management Data].[Order Code]
          END)
     ELSE (' ')
END
