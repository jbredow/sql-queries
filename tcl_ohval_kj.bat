SELECT PO.HEADER WITH TTOT.AMT >= "5000" AND WITH PODATE >= "04/30/18" AND WITH PO.TYPE = "S"

SL BIGPOS.SL

GL BIGPOS.SL

SEND PO.HEADER TO "C:\DL\BIGPOS.CSV" WHSE PO.TYPE VENDOR.NAME ENTEREDBY SPC SHIP.VIA PODATE ARV.DATE REC.DATE TTOT.AMT IC.STAT.FLG TAG.ORDERS CUSTNAME
