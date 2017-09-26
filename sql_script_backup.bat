:Windows Batch File
:  copies from share to myDocs

:define source locations
SET srca="\\fei1018911\share\BI\sql queries"

:define destination locations
SET desta="C:\Users\AAA6863\Documents\sql\sql queries"

SET log="c:\logs\robocopy.log"

:run robocopy script   
robocopy %srca% %desta% /E /Z /R:1 /LOG:%log%