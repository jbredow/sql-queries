'=========== pass values to sub ================

Sub FirstCode2()

    Dim FormatCell As Integer
    
    FormatCell = ActiveCell.Value
    
    'If IsNumeric(FormatCell) = False Then
    '    MsgBox ("This is not a number - Exiting Now")
    'Exit Sub
    
    If FormatCell < 20 Then
    
        Call SecondCode2(True, "Arial", 22)
    
    'Else
        'Call SecondCode2(False, "Times", 26)
    
    End If

End Sub

Sub SecondCode2(BoldValue As Boolean, NameValue As String, SizeValue)

    With ActiveCell.Font
        .Bold = BoldValue
        .Name = NameValue
        .Size = SizeValue
    End With
    
End Sub
