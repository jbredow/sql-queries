Attribute VB_Name = "c1_bidConversion"
Option Explicit
Private module

Sub BidConversionMacro()

    Dim number As Integer, rowmove As Integer
    Dim lastrow As Integer, Wk As Workbook
    Dim FileToOpen As Variant, blank As Variant
    Dim templateWB As Variant, biaiWB As Variant
    Dim dateformat As Date, dateformat2 As Date
    Dim Y                   As Long
    Dim dlPath              As String
    Dim drivePath           As String
    
    Application.ScreenUpdating = False
    
    drivePath = Workbooks("ToolBox.xlsm").Worksheets("Settings").Range("B2").Value
    dlPath = Workbooks("ToolBox.xlsm").Worksheets("Settings").Range("B3").Value
    
    'create upload form
    If FileFolderExists(dlPath) Then
        chDrive drivePath
        chDir dlPath & "\"
    Else
        chDrive drivePath & "\"
        chDir drivePath & "\"
    End If
    
    If FileFolderExists(dlPath & "\ContractUploadTemplate.xlsx") Then
        On Error Resume Next
        Kill dlPath & "\ContractUploadTemplate.xlsx"
        On Error GoTo 0
    Else
        On Error Resume Next
        Kill drivePath & "\ContractUploadTemplate.xlsx"
        On Error GoTo 0
    End If
    
    Set Wk = Workbooks.Add
    Application.DisplayAlerts = False
    Wk.Saveas fileName:="ContractUploadTemplate.xlsx"
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
        Workbooks.Open fileName:=FileToOpen
    End If
    biaiWB = ActiveWorkbook.Name
    
    Rows("1:1").AutoFilter
    lastrow = Range("A" & Rows.Count).End(xlUp).row
    Range("A2:AA" & lastrow).Sort Key1:=Range("G1"), order1:=xlAscending
    Columns("R:S").Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Columns("Q:Q").TextToColumns Destination:=Range("Q1"), DataType:=xlFixedWidth, _
        OtherChar:="*", FieldInfo:=Array(Array(0, 1), Array(1, 1), Array(2, 1)), _
        TrailingMinusNumbers:=True
    number = 0
    rowmove = 2

    On Error Resume Next     ' In case there are no blanks
    Columns("L:L").SpecialCells(xlCellTypeBlanks).EntireRow.Delete
    ActiveSheet.UsedRange 'Resets UsedRange for Excel 97
    
    lastrow = Range("A" & Rows.Count).End(xlUp).row 'reset lastrow
    Do While number < lastrow - 1
        If Range("Q" & rowmove) = blank Then
            Range("N" & rowmove).Copy Range("S" & rowmove)
            Range("Q" & rowmove & ":R" & rowmove).Value = "$"
        End If
        rowmove = rowmove + 1
        number = number + 1
    Loop
    
    'remove SPEC pricing
    lastrow = Cells(Rows.Count, 1).End(xlUp).row
    For Y = lastrow To 2 Step -1
        If Cells(Y, "Q").Value = "S" Then
            Rows(Y).EntireRow.Delete
        End If
    Next Y
    
    lastrow = Cells(Rows.Count, 1).End(xlUp).row
    
    If Not Range("B" & lastrow) > 0 Then
        Rows(lastrow & ":" & lastrow).EntireRow.Delete
    End If
    
    'copy BIAI info into template
    Workbooks(biaiWB).Activate
    Range("C2:C751").Copy
    Workbooks(templateWB).Activate
    Range("C21").PasteSpecial Paste:=xlPasteValues
    
    Workbooks(biaiWB).Activate
    Range("G2:G751").Copy
    Workbooks(templateWB).Activate
    Range("G21").PasteSpecial Paste:=xlPasteValues
    
    Workbooks(biaiWB).Activate
    Range("Q2:S751").Copy
    Workbooks(templateWB).Activate
    Range("I21").PasteSpecial Paste:=xlPasteValues
    
    Workbooks(biaiWB).Activate
    Range("N2:N751").Copy
    Workbooks(templateWB).Activate
    Range("Q21").PasteSpecial Paste:=xlPasteValues
    
    Workbooks(templateWB).Activate
    lastrow = Cells(Rows.Count, 3).End(xlUp).row
    With ActiveSheet
        With .Range("E21:E" & lastrow)
            .Formula = "=TODAY() + 1"
            .Value = .Value
        End With
        Range("F21:F" & lastrow).Select
        dateformat = DateAdd("d", 180, Now())
        dateformat2 = DateAdd("m", 1, dateformat)
        Range(Cells(21, 6), Cells(lastrow, 6)).Value = _
            Month(dateformat2) & "/05/" & Year(dateformat2)
    End With
    Range("H21:H" & lastrow).Value = "P"
    Application.DisplayAlerts = False
    Workbooks(biaiWB).Close
    Application.DisplayAlerts = True
    GetBranchNumber.Show
    Application.ScreenUpdating = True
    
    End Sub
    
Sub endIt()
    Dim lastrow As Long
    
    Application.ScreenUpdating = False
    lastrow = Cells(Rows.Count, 3).End(xlUp).row
    Range("B21").Copy
    Range("B22:B" & lastrow).PasteSpecial Paste:=xlPasteValues
    ActiveWorkbook.Save
    Application.ScreenUpdating = True
    
End Sub

Sub netsOnly()
    Dim lastrow As Long
    Application.ScreenUpdating = False
    lastrow = Cells(Rows.Count, 3).End(xlUp).row
    Range("Q21:Q" & lastrow).Copy
    Range("K21").PasteSpecial Paste:=xlPasteValues
    Range("I21:J" & lastrow).Value = "$"
    Application.ScreenUpdating = True
End Sub

Sub generateForm()
    'create the upload form mimicing the download from Advanous
    Dim myBorders() As Variant, item As Variant '
    Dim cmt As Comment, MyComments As Comment
    Dim lArea As Long

    Application.ScreenUpdating = False
    Columns("A:A").ColumnWidth = 1.29
    Columns("B:B").ColumnWidth = 16.71
    Columns("C:C").ColumnWidth = 14.14
    Columns("D:D").ColumnWidth = 17.5
    Columns("E:E").ColumnWidth = 12.29
    Columns("F:F").ColumnWidth = 12.29
    Columns("G:G").ColumnWidth = 29.43
    Columns("H:H").ColumnWidth = 14.86
    Columns("I:I").ColumnWidth = 8.57
    Columns("J:J").ColumnWidth = 9.14
    Columns("K:K").ColumnWidth = 9.86
    Columns("L:L").ColumnWidth = 8.57
    Columns("M:M").ColumnWidth = 9.14
    Columns("N:N").ColumnWidth = 9.86
    Columns("O:O").ColumnWidth = 19.71
    Columns("P:P").ColumnWidth = 34.31

    'add directions
    Range("B1").Value = "FEI Proposal Engine CCOR Upload Template"
    Range("B4").Value = "Instructions:"
    Range("B5").Value = "-  All yellow highlighted fields are required for form " _
        & "to be processed.  Grey fields are optional."
    Range("B6").Value = "-  You may upload up to 750 records at a time"
    Range("B7").Value = "-  Do not change the file extension for this template.  " _
        & "It must remain a .xlsx file for the upload process to work."
    Range("B8").Value = "-  You must use Internet Explorer for upload process to work."
    Range("B9").Value = "-  To enter a divide operator for a cost formula, you must " _
        & "enter an apostrophe before the divide symbol as follows:  '/"
    Range("B10").Value = "-  To enter a net formula, enter a $ in both the Basis " _
        & "and Operator fields."
    Rows("11:18").EntireRow.Hidden = True
    
    Range("B1,B4").Select
    With Selection.Font
        .Name = "Calibri"
        .FontStyle = "Bold"
        .Size = 11
    End With
    Range("B1,B4").Font.Bold = True
    With Range("B5:B10")
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlBottom
        .IndentLevel = 1
    End With
    
    Range("B19:H19").Value = Array("Main Branch ID", "Customer ID", _
        "Contract Name", "Effective" & Chr(10) & "Date", "Expiration" _
        & Chr(10) & "Date", "ALT CODE or Disc Group#", "P=Product" & _
        Chr(10) & "G=Disc Group")
    Range("B19:B20").Merge
    Range("C19:C20").Merge
    Range("D19:D20").Merge
    Range("E19:E20").Merge
    Range("F19:F20").Merge
    Range("G19:G20").Merge
    Range("H19:H20").Merge
    Range("I19").Value = "Sell CCOR"
    Range("L19").Value = "Cost CCOR"
    Range("I20:N20").Value = Array("Basis", "Operator", "Multiplier", _
        "Basis", "Operator", "Multiplier")
    Range("O20:P20").Value = Array("Max Purchase" & Chr(10) & _
        "Quantity", "Notes")
    Range("O19:O20").Merge
    Range("P19:P20").Merge
    
    Rows("19:20").RowHeight = 16.5
    Rows("21:770").RowHeight = 14.25
    
    Range("I19:K19").HorizontalAlignment = xlCenterAcrossSelection
    Range("L19:N19").HorizontalAlignment = xlCenterAcrossSelection
    
    Range("B19:P770").Select
    myBorders = Array(xlEdgeLeft, _
        xlEdgeTop, _
        xlEdgeBottom, _
        xlEdgeRight, _
        xlInsideVertical, _
        xlInsideHorizontal)
    For Each item In myBorders
        With Selection.Borders(item)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .ColorIndex = xlAutomatic
        End With
    Next item
    Range("L21:N770").Select
    myBorders = Array(xlEdgeLeft, _
        xlEdgeTop, _
        xlEdgeBottom, _
        xlEdgeRight, _
        xlInsideVertical, _
        xlInsideHorizontal)
    For Each item In myBorders
        With Selection.Borders(item)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .ColorIndex = xlAutomatic
        End With
    Next item
    Range("I19:K770").Select
    myBorders = Array(xlEdgeLeft, _
        xlEdgeTop, _
        xlEdgeBottom, _
        xlEdgeRight)
    For Each item In myBorders
        With Selection.Borders(item)
            .LineStyle = xlContinuous
            .Weight = xlThick
            .ColorIndex = xlAutomatic
        End With
    Next item
    
    Range("L19:N770").Select
    myBorders = Array(xlEdgeLeft, _
        xlEdgeTop, _
        xlEdgeBottom, _
        xlEdgeRight)
    For Each item In myBorders
        With Selection.Borders(item)
            .LineStyle = xlContinuous
            .Weight = xlThick
            .ColorIndex = xlAutomatic
        End With
    Next item
    
    Range("B21:C770, G21:N770").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .color = 10092543
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    With Range("D21:F770, O21:P770").Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorDark1
        .TintAndShade = -0.14996795556505
        .PatternTintAndShade = 0
    End With

    Range("B21:K770").Locked = False
    Range("P21:P770").Locked = False
    
    Range("B19:P20").Font.Bold = True
    With Range("B20:L20").Font
        .Name = "Calibri"
        .FontStyle = "Bold"
        .Size = 11
    End With
    
    'add comments
    Range("D21").Select 'D comment Contract Name
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.AddComment Text:="Optional" & Chr(10) & _
            Chr(10) & "If left blank, will default to 'BASE'. "
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
          .Name = "Times New Roman"
          .Size = 11
          .Bold = False
          .ColorIndex = 0
        End With
    End If
    Range("E21").Select 'E comment Effective Date
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.AddComment Text:="Optional." & Chr(10) & _
            Chr(10) & "If left blank, will default to next day."
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
            .Name = "Times New Roman"
            .Size = 11
            .Bold = False
            .ColorIndex = 0
        End With
    End If
    Range("F21").Select 'F comment Expiration Date
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.AddComment Text:="Optional." & Chr(10) & Chr(10) & _
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
    Range("H21").Select 'H comment P or G
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.AddComment Text:="VALID ENTRIES:" & Chr(10) _
        & "P" & Chr(10) & "G"
        Set cmt = ActiveCell.Comment
        With cmt.Shape.TextFrame.Characters.Font
            .Name = "Times New Roman"
            .Size = 11
            .Bold = False
            .ColorIndex = 0
        End With
    End If
    Range("I21").Select 'I comment Basis Options
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.AddComment Text:="Valid Entries:" & Chr(10) & _
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
    Range("J21").Select 'J comment Operator Options
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.AddComment Text:="Valid Entries:" & Chr(10) & _
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
    Range("K21").Select 'K comment Discount/Multiplier/Net options
    Set cmt = ActiveCell.Comment
    If cmt Is Nothing Then
        ActiveCell.AddComment Text:="VALID ENTRIES:" & Chr(10) & Chr(10) & _
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
    Range("B21").Select
    Application.ScreenUpdating = True
End Sub

Function FileFolderExists(strFullPath As String) As Boolean
    On Error GoTo EarlyExit
    If Not Dir(strFullPath, vbDirectory) = vbNullString Then FileFolderExists = True
EarlyExit:
    On Error GoTo 0
End Function

Sub trilogyFile()
    Dim FileToOpen As Variant
    Dim biaiWB As Variant
    Dim lastrow As Long
    Dim num As Long, rMove As Long, Y As Long
    Dim blank As Variant  'blank cell?
    Dim iCurrent As Long, iSkip As Long
    Dim dlPath              As String
    Dim drivePath           As String
    
    Application.ScreenUpdating = False
    
    drivePath = Workbooks("ToolBox.xlsm").Worksheets("Settings").Range("B2").Value
    dlPath = Workbooks("ToolBox.xlsm").Worksheets("Settings").Range("B3").Value
    
    If FileFolderExists(dlPath) Then
        chDrive drivePath & "\"
        chDir dlPath & "\"
    Else
        MkDir dlPath & "\"
        chDrive drivePath & "\"
        chDir dlPath & "\"
    End If

    'open BIAI file for processing
    FileToOpen = Application.GetOpenFilename _
        (Title:="Please select BIAI file for processing", _
        fileFilter:="All Files(*.csv; *.xls), *.csv; *.xls")
    If FileToOpen = False Then
        MsgBox "No file specified - A file must be selected to use this tool.", vbExclamation, _
            "Choose your BIAI file!!!"
    Exit Sub
    Else
        Workbooks.Open fileName:=FileToOpen
    End If
    biaiWB = ActiveWorkbook.Name
    
    Rows("1:1").AutoFilter
    lastrow = Range("A" & Rows.Count).End(xlUp).row
    
    Columns("R:S").Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Columns("Q:Q").TextToColumns Destination:=Range("Q1"), DataType:=xlFixedWidth, _
        OtherChar:="*", FieldInfo:=Array(Array(0, 1), Array(1, 1), Array(2, 1)), _
        TrailingMinusNumbers:=True
    
    On Error Resume Next     ' In case there are no blanks
    Columns("L:L").SpecialCells(xlCellTypeBlanks).EntireRow.Delete
    ActiveSheet.UsedRange 'Resets UsedRange for Excel 97
    
    num = 0
    rMove = 2
    
    lastrow = Range("A" & Rows.Count).End(xlUp).row 'reset lastrow
    Do While num < lastrow - 1
        If Range("Q" & rMove) = blank Then
            Range("N" & rMove).Copy Range("S" & rMove)
            Range("Q" & rMove & ":R" & rMove).Value = "$"
        End If
        rMove = rMove + 1
        num = num + 1
    Loop
    
    'remove SPEC pricing
    lastrow = Cells(Rows.Count, 1).End(xlUp).row
    For Y = lastrow To 2 Step -1
        If Cells(Y, "Q").Value = "S" Then
            Rows(Y).EntireRow.Delete
        End If
    Next Y
    
    lastrow = Cells(Rows.Count, 1).End(xlUp).row
    
    If Not Range("B" & lastrow) > 0 Then
        Rows(lastrow & ":" & lastrow).EntireRow.Delete
    End If
    'determine what needs to be done with the data
    Range("B:B,H:H,K:K,M:M,U:U,W:AB").Delete Shift:=xlToLeft
    Columns("D:E").ColumnWidth = 12.33
    Columns("D:E").Columns.Group
    Columns("C:C").ColumnWidth = 30.67
    Columns("F:F").ColumnWidth = 13
    Columns("H:H").ColumnWidth = 32.83
    Columns("G:H").Columns.Group
    Range("I1:P1").Value = Array("DG", "Net", "Cost", "List", "Bas", _
        "Op", "Mult", "G/P")
    With ActiveSheet
        lastrow = .Range("A" & Rows.Count).End(xlUp).row
        With .Range("P2:P" & lastrow)
            .Formula = "=IFERROR(IF(ISEVEN(RC[-10]*2),""G"",""P""),""P"")"
            .Value = .Value
        End With
    End With
    ActiveSheet.Outline.ShowLevels ColumnLevels:=1
    Cells.Select
    With Cells.Font
        .Name = "Calibri"
        .Size = 10
    End With
    Range("A1:R1").Font.Bold = True
    Range("A2").Select
    ActiveWindow.FreezePanes = True
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Clear
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Add _
        Key:=Range("B2:B" & lastrow), _
        SortOn:=xlSortOnValues, _
        Order:=xlAscending, DataOption:=xlSortNormal
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Add _
        Key:=Range("I2:I" & lastrow), _
        SortOn:=xlSortOnValues, _
        Order:=xlAscending, DataOption:=xlSortNormal
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Add _
        Key:=Range("F2:F" & lastrow), _
        SortOn:=xlSortOnValues, _
        Order:=xlAscending, DataOption:=xlSortNormal
    With ActiveWorkbook.ActiveSheet.Sort
        .SetRange Range("A1:R" & lastrow)
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    Range("S1:V1").Value = Array("Cust", "DG", "Avg", "Var?")
    With ActiveSheet
        lastrow = .Range("A" & Rows.Count).End(xlUp).row
        With .Range("S2:S" & lastrow)
            .Formula = "=IF(RC[-17]<>R[-1]C[-17],RC[-17],"""")"
            .Value = .Value
        End With
        With .Range("T2:T" & lastrow)
            .Formula = _
                "=IF(RC[-1]<>"""",RC[-11],IF(RC[-11]<>R[-1]C[-11],RC[-11],""""))"
            .Value = .Value
        End With
        With .Range("U2:U" & lastrow)
            .Formula = _
                "=IFERROR(SUMIFS(C[-6],C[-19],C[-19],C[-12],RC[-1])/" _
                & "COUNTIFS(C[-12],RC[-1],C[-19],RC[-19]),"""")"
            .Value = .Value
        End With
        With .Range("V2:V" & lastrow)
            .Formula = _
                "=IF(RC[-1]<>"""",IF(RC[-1]=RC[-7],""OK"",""VAR""),"""")"
            .Value = .Value
        End With
        With .Range("W2:W" & lastrow)
            .Formula = "=UPPER(IF(RC[-1]<>"""",RC[-1],R[-1]C))"
            .Value = .Value
        End With
    End With
    Range("S3").Select
    
    iCurrent = 2
    iSkip = 0

    Do
        If UCase(Range("V" & iCurrent).Value = _
            "OK" And Range("W" & iCurrent).Value = "OK" And Range("N" & iCurrent).Value <> "$") Then
            Range("X" & iCurrent).Value = _
                Cells(iCurrent, 2).Value & "**G#" & Cells(iCurrent, 9)
            Range("Y" & iCurrent).Value = Cells(iCurrent, 13) & _
                Cells(iCurrent, 14) & Cells(iCurrent, 15)
        End If
        
        If UCase(Range("W" & iCurrent).Value = "VAR" _
                And Range("M" & iCurrent).Value = "$") Then
            Range("X" & iCurrent).Value = _
                Cells(iCurrent, 2).Value & "**P#" & Cells(iCurrent, 9)
            Range("Y" & iCurrent).Value = "$" & Cells(iCurrent, 10)
        End If
        
        If UCase(Range("W" & iCurrent).Value = "VAR" _
                And Range("M" & iCurrent).Value <> "$") Then
            Range("X" & iCurrent).Value = _
                Cells(iCurrent, 2).Value & "**P#" & Cells(iCurrent, 6)
            Range("Y" & iCurrent).Value = Cells(iCurrent, 13) & _
                Cells(iCurrent, 14) & Cells(iCurrent, 15)
        End If
        
        iCurrent = iCurrent + 1
    Loop Until Range("D" & iCurrent).FormulaR1C1 = ""
    
    Columns("M:M").ColumnWidth = 5.71
    Columns("N:N").ColumnWidth = 4.71
    Columns("O:O").ColumnWidth = 7
    Columns("P:Q").EntireColumn.Hidden = True
    Columns("S:S").ColumnWidth = 6.43
    Columns("T:T").ColumnWidth = 5
    Columns("U:U").ColumnWidth = 5.43
    Columns("V:V").ColumnWidth = 3.86
    Columns("W:W").ColumnWidth = 3.86
    Columns("X:X").ColumnWidth = 20.33
    Columns("Y:Y").ColumnWidth = 8.29
    Range("X1:Y1").Value = Array("Combo", "Form")
    With Range("S1:Y1").Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent3
        .TintAndShade = 0.6
        .PatternTintAndShade = 0
    End With
    Range("S1:Y1").Font.Bold = True
    
    Columns("U:W").Hidden = True
    
End Sub
Sub trilogyNets()
    Dim FileToOpen As Variant
    Dim biaiWB As Variant
    Dim lastrow As Long
    Dim num As Long, rMove As Long, Y As Long
    Dim blank As Variant  'blank cell?
    Dim iCurrent As Long, iSkip As Long
    Dim cust As String, exp As String
    Dim dlPath              As String
    Dim drivePath           As String
    
    Application.ScreenUpdating = False
    
    drivePath = Workbooks("ToolBox.xlsm").Worksheets("Settings").Range("B2").Value
    dlPath = Workbooks("ToolBox.xlsm").Worksheets("Settings").Range("B3").Value
    
    If FileFolderExists(dlPath) Then
        chDrive drivePath & "\"
        chDir dlPath & "\"
    Else
        MkDir dlPath & "\"
        chDrive drivePath & "\"
        chDir dlPath & "\"
    End If
    
    'open BIAI file for processing
    FileToOpen = Application.GetOpenFilename _
        (Title:="Please select BIAI file for processing", _
        fileFilter:="All Files(*.csv; *.xls), *.csv; *.xls")
    If FileToOpen = False Then
        MsgBox "No file specified - A file must be selected to use this tool.", vbExclamation, _
            "Choose your BIAI file!!!"
    Exit Sub
    Else
        Workbooks.Open fileName:=FileToOpen
    End If
    biaiWB = ActiveWorkbook.Name
    
    Rows("1:1").AutoFilter
    lastrow = Range("A" & Rows.Count).End(xlUp).row
    
    Columns("R:S").Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Columns("Q:Q").TextToColumns Destination:=Range("Q1"), DataType:=xlFixedWidth, _
        OtherChar:="*", FieldInfo:=Array(Array(0, 1), Array(1, 1), Array(2, 1)), _
        TrailingMinusNumbers:=True
    
    On Error Resume Next     ' In case there are no blanks
    Columns("L:L").SpecialCells(xlCellTypeBlanks).EntireRow.Delete
    ActiveSheet.UsedRange 'Resets UsedRange for Excel 97
    
    num = 0
    rMove = 2
    
    lastrow = Range("A" & Rows.Count).End(xlUp).row 'reset lastrow
    Do While num < lastrow - 1
        If Range("Q" & rMove) = blank Then
            Range("N" & rMove).Copy Range("S" & rMove)
            Range("Q" & rMove & ":R" & rMove).Value = "$"
        End If
        rMove = rMove + 1
        num = num + 1
    Loop
    
    'remove SPEC pricing
    lastrow = Cells(Rows.Count, 1).End(xlUp).row
    For Y = lastrow To 2 Step -1
        If Cells(Y, "Q").Value = "S" Then
            Rows(Y).EntireRow.Delete
        End If
    Next Y
    
    lastrow = Cells(Rows.Count, 1).End(xlUp).row
    
    If Not Range("B" & lastrow) > 0 Then
        Rows(lastrow & ":" & lastrow).EntireRow.Delete
    End If
    'determine what needs to be done with the data
    Range("B:B,H:H,K:K,M:M,U:U,W:AB").Delete Shift:=xlToLeft
    Columns("D:E").ColumnWidth = 12.33
    Columns("D:E").Columns.Group
    Columns("C:C").ColumnWidth = 30.67
    Columns("F:F").ColumnWidth = 13
    Columns("H:H").ColumnWidth = 32.83
    Columns("G:H").Columns.Group
    Range("I1:O1").Value = Array("DG", "Net", "Cost", "List", "Bas", _
        "Op", "Mult")
    ActiveSheet.Outline.ShowLevels ColumnLevels:=1
    Cells.Select
    With Cells.Font
        .Name = "Calibri"
        .Size = 10
    End With
    Range("A1:R1").Font.Bold = True
    Range("A2").Select
    ActiveWindow.FreezePanes = True
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Clear
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Add _
        Key:=Range("B2:B" & lastrow), _
        SortOn:=xlSortOnValues, _
        Order:=xlAscending, DataOption:=xlSortNormal
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Add _
        Key:=Range("I2:I" & lastrow), _
        SortOn:=xlSortOnValues, _
        Order:=xlAscending, DataOption:=xlSortNormal
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Add _
        Key:=Range("F2:F" & lastrow), _
        SortOn:=xlSortOnValues, _
        Order:=xlAscending, DataOption:=xlSortNormal
    With ActiveWorkbook.ActiveSheet.Sort
        .SetRange Range("A1:R" & lastrow)
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    cust = Application.InputBox("Enter Customer Number.", "CUST #")
    exp = Application.InputBox("Enter Expiration Date as: 06.18.13.", "Date")
    
    If cust = vbNullString Then GoTo skipDate:
    With ActiveSheet
        lastrow = .Range("A" & Rows.Count).End(xlUp).row
        With .Range("B2:B" & lastrow)
            .Value = cust
        End With
    End With
skipDate:

    If exp = vbNullString Then GoTo skipExp:
    With ActiveSheet
        With .Range("U2:U" & lastrow)
            .Value = exp
        End With
    End With
skipExp:

    Range("S1:U1").Value = Array("Cust", "Net", "Exp")
    With ActiveSheet
        lastrow = .Range("A" & Rows.Count).End(xlUp).row
        With .Range("S2:S" & lastrow)
            .Formula = "=RC[-17]&""**P#""& RC[-13]"
            .Value = .Value
        End With
        With .Range("T2:T" & lastrow)
            .Formula = _
                "=""$""&RC[-10]"
            .Value = .Value
        End With
    End With
    Columns("C:C").ColumnWidth = 25.57
    Columns("J:L").ColumnWidth = 6.29
    Columns("M:N").ColumnWidth = 5.14
    Columns("O:O").ColumnWidth = 6.71
    Columns("S:S").ColumnWidth = 11.86
    Columns("S:S").ColumnWidth = 17.57
    Columns("S:S").ColumnWidth = 21
    Columns("T:T").ColumnWidth = 9.86
    Columns("U:U").ColumnWidth = 11.14
    Columns("U:U").HorizontalAlignment = xlCenter
    Columns("S:S").Insert Shift:=xlToRight

    With Range("T1:V1").Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent3
        .TintAndShade = 0.6
        .PatternTintAndShade = 0
    End With
    Range("T1:V1").Font.Bold = True
    Columns("A:V").RemoveDuplicates _
        Columns:=Array(20, 21, 22), _
        Header:=xlNo
End Sub


