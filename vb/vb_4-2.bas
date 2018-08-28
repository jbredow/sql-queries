Function CheckCell(cellValue) As Boolean

    If IsNumeric(cellValue) Then
        CheckCell = True
    Else
        CheckCell = False
    End If
    
End Function

Sub errorCheckTest()
    Dim returnValue As Boolean
    
    returnValue = CheckCell(ActiveCell.Value)
    
    If returnValue = False Then
        msgBox ("Not a Number - Exiting Sub")
        Exit Sub
    End If
    
End Sub

' === worksheet functions ==

Sub worksheet_functions()
    Dim SumTotal As Long
    
    SumTotal = WorksheetFunction.Sum(Range("B1:B5"))
    
    Range("C1").Value = "Total Sales:"
    Range("D1").Value = SumTotal
    
End Sub

'MAX, MIN AVG

