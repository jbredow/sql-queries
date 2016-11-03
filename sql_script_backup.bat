:Windows Batch File

:define source locations
SET srca="C:\Users\AAA6863\Documents\sql\sql queries"

:define destination locations
SET desta="\\fei0337354\share\BI\sql_queries"

SET log="c:\logs\robocopy.log"

:run robocopy script
robocopy %srca% %desta% /E /Z /R:1 /LOG+:%log%