    FileToOpen = Application.GetOpenFilename _
        (Title:="Please choose the data file", _
        fileFilter:="Excel Files *.xlsx (*.xlsx),")
    If FileToOpen = False Then
        MsgBox "File must be selected!" & Chr(10) & _
            "Select Monthly Reports data file when asked", _
             vbExclamation, "No file specified"
        On Error Resume Next
        Worksheets("Data").Delete
        Exit Sub
    Exit Sub
    
    Application.EnableEvents = False
    Application.ScreenUpdating = False
        
    Else
        Workbooks.Open fileName:=FileToOpen
    End If

    If WorksheetExists("at_a_glance_channel") Then
        Sheets("at_a_glance_channel").Select
    End If
        Sheets("writer_channel_new").Visible = False
        Sheets("gp_tracker_chan_qtr").Visible = False
        Sheets("sales_reps").Visible = False
        Sheets("bus_grps").Visible = False

'   userform code   ++++++++++++++++++++++++++++++++++++++++++++++++++
Option Explicit

Private Sub CommandButton2_Click()
    Unload UserForm01
    Application.Run "GPTracker"
End Sub

Private Sub CommandButton3_Click()
    Unload UserForm01
End Sub

'   select data sheet   ++++++++++++++++++++++++++++++++++++++++++++++
    If WorksheetExists("gp_tracker_chan_qtr") Then
        Sheets("gp_tracker_chan_qtr").Select
    End If
        'ActiveWorkbook.Sheets("gp_tracker_chan_qtr").Visible = xlSheetHidden
        ActiveWorkbook.Sheets("writer_channel_new").Visible = xlSheetHidden
        ActiveWorkbook.Sheets("bus_grps").Visible = xlSheetHidden
        ActiveWorkbook.Sheets("at_a_glance_channel").Visible = xlSheetHidden
        ActiveWorkbook.Sheets("sales_reps").Visible = xlSheetHidden

'   date functions   ++++++++++++++++++++++++++++++++++++++++++++++++
Private Function sMonth()
    MonthName = Format(DateSerial(Year(Now), Month(Now) - 1, 1), "MMMM")
End Function

Private Function sYear()
    'Dim mBefore  As Date
    Application.Volatile
    yearName = DatePart("YYYY", Format(DateAdd("m", -1, Date), "dd mmmm yyyy"))
End Function
