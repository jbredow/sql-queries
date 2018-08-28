'working with files

Sub filename_test()
    Dim wbName                   As String
    Dim wb                      As Workbook
    
    Set wb = ActiveWorkbook
    wbName = wb.name
    
    Windows("test_saves.xlsx").Activate
    
    Windows(wbName).Activate
    
End Sub

' record macro and save a test file as different filetypes

' in vb editor hit F2 for Object Browser 
'  in search = SaveAs - then view GetSaveAsFilename

    ActiveWorkbook.SaveAs Filename:="C:\Users\AAA6863\Documents\test_saves.xlsx" _
        , FileFormat:=xlOpenXMLWorkbook, CreateBackup:=False
    ' ...  show main filetypes

' ================================================

Private Sub FileSaveAs()
    'Opens a File Save As window and offers an XLSX openXML format type
    Dim fName As Variant
    
    fName = Application.GetSaveAsFilename( _
                fileFilter:="Excel Workbooks (*.xlsx), *.xlsx", _
                title:="Save Name", _
                InitialFileName:="Initial Workbook")
    
    If fName = "" Then ' end on cancel
        ActiveWorkbook.SaveAs filename:=fName, _
        FileFormat:=xlWorkbookNormal
        Exit Sub
    End If
    
    On Error Resume Next
    ActiveWorkbook.SaveAs _
        FileFormat:=xlOpenXMLWorkbook, CreateBackup:=False
    If Err <> 0 Then
        'user cancelled
        Err.Clear
    End If
    On Error GoTo 0 ' clear error trapping

End Sub

' ========================================================

Private Sub rename_file()
' must be unopenned file
    Name "c:\dl\tester.xlsx" As "c:\dl\tester1.xlsx"
End Sub

' ========================================================

Public Function FileFolderExists(strFullPath As String) As Boolean
'Check if a file or folder exists
    On Error GoTo EarlyExit
    If Not Dir(strFullPath, vbDirectory) = vbNullString Then FileFolderExists = True
EarlyExit:
    On Error GoTo 0
End Function

Public Sub TestFolderExistence()
'Test if directory exists   ### uses above function
    If FileFolderExists("F:\Templates") Then
        MsgBox "Folder exists!"
    Else
        MsgBox "Folder does not exist!"
    End If
End Sub

Public Sub TestFileExistence()
'Test if directory exists   ### uses above function
    If FileFolderExists("F:\Test\TestWorkbook.xls") Then
        MsgBox "File exists!"
    Else
        MsgBox "File does not exist!"
    End If
End Sub

' ========================================================

Private Sub fileOpenDialog()
    Dim FileToOpen      As Variant
' single file open
    'Set directory for file selection
    ChDrive "C:"
    ChDir "C:\DL"
    
    FileToOpen = Application.GetOpenFilename _
        (title:="Please choose the previous month Nat Profit Tracker", _
        fileFilter:="All Files(*.csv; *.xls), *.csv; *.xls")
    
    If FileToOpen = False Then
        MsgBox "No file specified.", vbExclamation, "Select Nat Profit Tracker!!!"
    Exit Sub
    Else
        Workbooks.Open filename:=FileToOpen
    End If

End Sub

' ========================================================


Private Sub OpenMultipleFiles()
    Dim Filter As String, title As String, Msg As String
    Dim i As Integer, FilterIndex As Integer
    Dim filename As Variant
    ' File filters
    Filter = "Excel Files (*.xlsx),*.xlsx," & _
            "Text Files (*.csv),*.csv," & _
            "All Files (*.*),*.*"
    '   Default filter to *.*
        FilterIndex = 3
    ' Set Dialog Caption
    title = "Select File(s) to Open"
    ' Select Start Drive & Path
    ChDrive ("C")
    ChDir ("C:\DL")
    With Application
        ' Set File Name Array to selected Files (allow multiple)
        filename = .GetOpenFilename(Filter, FilterIndex, title, , True)
        ' Reset Start Drive/Path
        ChDrive (Left(.DefaultFilePath, 1))
        ChDir (.DefaultFilePath)
    End With
    ' Exit on Cancel
    If Not IsArray(filename) Then
        MsgBox "No file was selected."
        Exit Sub
    End If
    ' Open Files
    For i = LBound(filename) To UBound(filename)
        Msg = Msg & filename(i) & vbCrLf ' This can be removed
        Workbooks.Open filename(i)
    Next i
    MsgBox Msg, vbInformation, "Files Opened" ' This can be removed
End Sub

