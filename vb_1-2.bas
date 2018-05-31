Option Explicit

Sub complete()

    Dim FormatCell As Integer
    
    FormatCell = ActiveCell.Value
    
    If FormatCell < 20 Then
    
        With ActiveCell.Font
            .Bold = True
            .Name = "Arial"
            .Size = "16"
        End With
    
    End If

End Sub

Sub FirstCode()

Dim FormatCell As Integer
    
    FormatCell = ActiveCell.Value
    
    If FormatCell < 20 Then
    
        SecondCode
    
    End If

End Sub

Sub SecondCode()

    With ActiveCell.Font
        .Bold = True
        .Name = "Arial"
        .Size = "16"
    End With
    
End Sub

'==============================================