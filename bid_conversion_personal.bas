Attribute VB_Name = "bid_conversion"

Sub BidConversionMacro()

'  BidConversionMacro Macro
    Dim number As Integer, rowmove As Integer
    Dim lastrow As Integer, wk As Workbook
    Dim FileToOpen As Variant
    Dim templateWB As Variant, biaiWB As Variant
    Dim dateformat As Date, dateformat2 As Date

    Application.ScreenUpdating = False
    
    'create upload form
    If FileFolderExists("C:\DL") Then
        ChDrive "C:\"
        ChDir "C:\DL\"
    Else
        ChDrive "C:\"
        ChDir "C:\"
    End If
    
    If FileFolderExists("C:\DL\ContractUploadTemplate.xlsx") Then
        On Error Resume Next
        Kill "C:\DL\ContractUploadTemplate.xlsx"
        On Error GoTo 0
    Else
        On Error Resume Next
        Kill "C:\ContractUploadTemplate.xlsx"
        On Error GoTo 0
    End If

    Set wk = Workbooks.Add
    Application.DisplayAlerts = False
    wk.Saveas Filename:="ContractUploadTemplate.xlsx"
    Application.DisplayAlerts = True
    
    ' make form
    Call generateForm
    templateWB = ActiveWorkbook.Name

    'get biai download
    FileToOpen = Application.GetOpenFilename _
        (Title:="Please select the BIAI.xls file", _
        fileFilter:="All Files *.* (*.*),") 'Filter
    If FileToOpen = False Then
        MsgBox "No file specified - A blank upload file will be created.", vbExclamation, _
            "Choose your BIAI file!!!"
    Exit Sub
    Else
        Workbooks.Open Filename:=FileToOpen
    End If
    biaiWB = ActiveWorkbook.Name
    
    Rows("1:1").AutoFilter
    lastrow = range("A" & Rows.Count).End(xlUp).Row
    range("A2:AA" & lastrow).sort Key1:=range("G1"), Order1:=xlAscending
    Columns("R:S").Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Columns("Q:Q").TextToColumns Destination:=range("Q1"), DataType:=xlFixedWidth, _
        OtherChar:="*", FieldInfo:=Array(Array(0, 1), Array(1, 1), Array(2, 1)), _
        TrailingMinusNumbers:=True
    number = 0
    rowmove = 2

    On Error Resume Next     ' In case there are no blanks
    Columns("L:L").SpecialCells(xlCellTypeBlanks).EntireRow.Delete
    ActiveSheet.UsedRange 'Resets UsedRange for Excel 97
    
    lastrow = range("A" & Rows.Count).End(xlUp).Row 'reset lastrow
    Do While number < lastrow - 1
        If range("Q" & rowmove) = blank Then
            range("N" & rowmove).Copy range("S" & rowmove)
            range("Q" & rowmove & ":R" & rowmove).value = "$"
        End If
        rowmove = rowmove + 1
        number = number + 1
    Loop
    
    'remove SPEC pricing
    lastrow = Cells(Rows.Count, 1).End(xlUp).Row
    For y = lastrow To 2 Step -1
        If Cells(y, "Q").value = "s" Then
            Rows(y).EntireRow.Delete
        End If
    Next y
    
    'copy BIAI info into template
    Workbooks(biaiWB).Activate
    range("C2:C751").Copy
    Workbooks(templateWB).Activate
    range("C21").PasteSpecial Paste:=xlPasteValues
    
    Workbooks(biaiWB).Activate
    range("G2:G751").Copy
    Workbooks(templateWB).Activate
    range("G21").PasteSpecial Paste:=xlPasteValues
    
    Workbooks(biaiWB).Activate
    range("Q2:S751").Copy
    Workbooks(templateWB).Activate
    range("I21").PasteSpecial Paste:=xlPasteValues
    
    Workbooks(biaiWB).Activate
    range("N2:N751").Copy
    Workbooks(templateWB).Activate
    range("N21").PasteSpecial Paste:=xlPasteValues
    
    Workbooks(templateWB).Activate
    lastrow = Cells(Rows.Count, 3).End(xlUp).Row
    With ActiveSheet
        With .range("E21:E" & lastrow)
            .Formula = "=TODAY() + 1"
            .value = .value
        End With
        range("F21:F" & lastrow).Select
        dateformat = DateAdd("d", 180, Now())
        dateformat2 = DateAdd("m", 1, dateformat)
        range(Cells(21, 6), Cells(lastrow, 6)).value = _
            Month(dateformat2) & "/05/" & Year(dateformat2)
    End With
    range("H21:H" & lastrow).value = "P"
    Application.DisplayAlerts = False
    Workbooks(biaiWB).Close
    Application.DisplayAlerts = True
    GetBranchNumber.Show
    Application.ScreenUpdating = True
    
    End Sub
    
Sub endIt()
    Application.ScreenUpdating = False
    lastrow = Cells(Rows.Count, 3).End(xlUp).Row
    range("B21").Copy
    range("B22:B" & lastrow).PasteSpecial Paste:=xlPasteValues
    ActiveWorkbook.Save
    Application.ScreenUpdating = True
    
End Sub

Sub netsOnly()
    Application.ScreenUpdating = False
    lastrow = Cells(Rows.Count, 3).End(xlUp).Row
    range("N21:N" & lastrow).Copy
    range("K21").PasteSpecial Paste:=xlPasteValues
    range("I21:J" & lastrow).value = "$"
    Application.ScreenUpdating = True
End Sub

Private Sub generateForm()
    'create the upload form mimicing the download from Advanous
    Dim myBorders() As Variant, item As Variant '
    Dim cmt As Comment, MyComments As Comment
    Dim lArea As Long

    Application.ScreenUpdating = False
    Columns("A:A").ColumnWidth = 1.29
    Columns("B:B").ColumnWidth = 16.71
    Columns("C:C").ColumnWidth = 14.14
    Columns("D:D").ColumnWidth = 13.57
    Columns("E:E").ColumnWidth = 12.29
    Columns("F:F").ColumnWidth = 12.43
    Columns("G:G").ColumnWidth = 17.71
    Columns("H:H").ColumnWidth = 15.29
    Columns("I:I").ColumnWidth = 7.57
    Columns("J:J").ColumnWidth = 9.29
    Columns("K:K").ColumnWidth = 12
    Columns("L:L").ColumnWidth = 28.43
    
    range("B1").value = "FEI Proposal Engine CCOR Upload Template"
    range("B4").value = "Instructions:"
    range("B5").value = "-  All yellow highlighted fields are required for form " _
        & "to be processed.  Grey fields are optional."
    range("B6").value = "-  You may upload up to 750 records at a time"
    range("B7").value = "-  Do not change the file extension for this template.  " _
        & "It must remain a .xlsx file for the upload process to work."
    range("B8").value = "-  You must use Internet Explorer for upload process to work."
    range("B9").value = "-  To enter a divide operator for a cost formula, you must " _
        & "enter an apostrophe before the divide symbol as follows:  '/"
    range("B10").value = "-  To enter a net formula, enter a $ in both the Basis " _
        & "and Operator fields."
    Rows("11:18").EntireRow.Hidden = True
    
    range("B1,B4").Select
    With Selection.Font
        .Name = "Calibri"
        .FontStyle = "Bold"
        .Size = 12
    End With
    range("B1,B4").Font.Bold = True
    With range("A10:A12")
        .HorizontalAlignment = xlRight
        .VerticalAlignment = xlBottom
        .IndentLevel = 1
    End With
    
    range("B20").value = "Main Branch ID:"
    range("C20").value = "Customer ID:"
    range("D20").value = "Contract" & Chr(10) & "Name:"
    range("E20").value = "Effective" & Chr(10) & "Date:"
    range("F20").value = "Expiration" & Chr(10) & "Date:"
    range("G20").value = "ALT CODE or" & Chr(10) & "Disc Group#"
    range("H20").value = "P=Product" & Chr(10) & "G=Disc Group"
    range("I20").value = "Basis "
    range("J20").value = "Operator"
    range("K20").value = "Multiplier"
    range("L20").value = "Notes:"
    range("B20:L20").HorizontalAlignment = xlCenter
    range("B20:L770").Select
    myBorders = Array(xlEdgeLeft, _
        xlEdgeTop, _
        xlEdgeBottom, _
        xlEdgeRight, _
        xlInsideVertical, _
        xlInsideHorizontal)
    For Each item In myBorders
        With Selection.borders(item)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .ColorIndex = xlAutomatic
        End With
    Next item
    
    range("B21:C770, G21:K770").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 10092543
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    With range("D21:F770, L21:L770").Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorDark1
        .TintAndShade = -0.14996795556505
        .PatternTintAndShade = 0
    End With

    range("B21:L770").Locked = False
    
    range("B20:L20").Font.Bold = True
    With range("B20:L20").Font
        .Name = "Calibri"
        .FontStyle = "Bold"
        .Size = 11
    End With
    
    'add comments
    range("D21").Select 'D comment
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.addComment Text:="Optional" & Chr(10) & _
            Chr(10) & "If left blank, will default to 'BASE'. "
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
          .Name = "Times New Roman"
          .Size = 11
          .Bold = False
          .ColorIndex = 0
        End With
    End If
    range("E21").Select 'E comment
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.addComment Text:="Optional." & Chr(10) & _
            Chr(10) & "If left blank, will default to next day."
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
            .Name = "Times New Roman"
            .Size = 11
            .Bold = False
            .ColorIndex = 0
        End With
    End If
    range("F21").Select 'F comment
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.addComment Text:="Optional." & Chr(10) & Chr(10) & _
            "If left blank, will default to the 5th of the month " & _
            "at least 6 months in the future." & Chr(10) & Chr(10) & _
            "Expiration Date must be at least one day past the " & _
            "Effective Date and at least one day past today."
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
            .Name = "Times New Roman"
            .Size = 11
            .Bold = False
            .ColorIndex = 0
        End With
    End If
    range("H21").Select 'H comment
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.addComment Text:="VALID ENTRIES:" & Chr(10) _
        & "P" & Chr(10) & "G"
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
            .Name = "Times New Roman"
            .Size = 11
            .Bold = False
            .ColorIndex = 0
        End With
    End If
    range("I21").Select 'I comment
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.addComment Text:="Valid Entries:" & Chr(10) & _
            "l" & Chr(10) & "2" & Chr(10) & "3" & Chr(10) & "4" & _
            Chr(10) & "5" & Chr(10) & "6" & Chr(10) & "7" & Chr(10) _
            & "8" & Chr(10) & "9" & Chr(10) & "C" & Chr(10) & "$"
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
            .Name = "Times New Roman"
            .Size = 11
            .Bold = False
            .ColorIndex = 0
        End With
    End If
    range("J21").Select 'J comment
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.addComment Text:="Valid Entries:" & Chr(10) & _
            "For basis L and 2-9" & Chr(10) & "-" & Chr(10) & "X" & Chr(10) & _
            Chr(10) & "For basis C" & Chr(10) & "+" & Chr(10) & "'/  (see instructions)" _
            & Chr(10) & Chr(10) & "For basis $" & Chr(10) & "$  (see instructions)"
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
            .Name = "Times New Roman"
            .Size = 11
            .Bold = False
            .ColorIndex = 0
        End With
    End If
    range("K21").Select 'K comment
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.addComment Text:="VALID ENTRIES:" & Chr(10) & Chr(10) & _
            "For basis L, 2-9, and C: Number between 0 and 1" & Chr(10) & Chr(10) & _
            "For Net Formula ($): Any Number up to 1,000,000"
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
            .Name = "Times New Roman"
            .Size = 11
            .Bold = False
            .ColorIndex = 0
        End With
    End If

  ' resize comments
    For Each MyComments In ActiveSheet.Comments
        With MyComments
            .Shape.TextFrame.AutoSize = True
            If .Shape.Width > 300 Then
                lArea = .Shape.Width * .Shape.Height
                .Shape.Width = 200
                .Shape.Height = (lArea / 200) * 1.1
            End If
        End With
    Next
    'finish
    ActiveWindow.DisplayGridlines = False
    range("B21").Select
    Application.ScreenUpdating = True
End Sub

Public Function FileFolderExists(strFullPath As String) As Boolean
    On Error GoTo EarlyExit
    If Not Dir(strFullPath, vbDirectory) = vbNullString Then FileFolderExists = True
EarlyExit:
    On Error GoTo 0
End Function


