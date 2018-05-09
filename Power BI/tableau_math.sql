CASE [TPD]
    WHEN 'LAST TWELVE MONTHS'
        THEN
        CASE [Price Category (group)]
            WHEN    'MATRIX' 
            THEN [Ext Sales]
            ELSE    0
        END
    ELSE 0
END

CASE [TPD]
    WHEN 'LAST TWELVE MONTHS'
        THEN
        CASE [Price Category (group)]
            WHEN    'MATRIX' 
            THEN [Ext Avg Cogs]
            ELSE    0
        END
    ELSE 0
END

(SUM([Matrix Sales])-SUM([Matrix Avg COGS]))/SUM([Matrix Sales])

-- outbound sales
CASE [TPD]
    WHEN 'LAST TWELVE MONTHS' 
    THEN [Ext Sales]
    ELSE 0
END
+ CASE [TPD]
    WHEN 'LAST TWELVE MONTHS' THEN 
        CASE [Price Category (group)]
            WHEN    'CREDITS' THEN [Ext Sales]
            ELSE    0
        END
    ELSE 0
END