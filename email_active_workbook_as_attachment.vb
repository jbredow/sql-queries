Sub EmailWorkbook()
'PURPOSE: Create email message with ActiveWorkbook attached
'SOURCE: www.TheSpreadsheetGuru.com
'https://www.thespreadsheetguru.com/blog/vba-guide-sending-excel-attachments-through-outlook

Dim SourceWB As Workbook
Dim DestinWB As Workbook
Dim OutlookApp As Object
Dim OutlookMessage As Object
Dim TempFileName As Variant
Dim ExternalLinks As Variant
Dim TempFilePath As String
Dim FileExtStr As String
Dim DefaultName As String
Dim UserAnswer As Long
Dim x As Long

Set SourceWB = ActiveWorkbook

'Check for macro code residing in
  If Val(Application.Version) >= 12 Then
    If SourceWB.FileFormat = 51 And SourceWB.HasVBProject = True Then
      UserAnswer = MsgBox("There was VBA code found in this xlsx file. " & _
        "If you proceed the VBA code will not be included in your email attachment. " & _
        "Do you wish to proceed?", vbYesNo, "VBA Code Found!")
     
    If UserAnswer = vbNo Then Exit Sub 'Handle if user cancels
  
    End If
  End If

'Determine Temporary File Path
  TempFilePath = Environ$("temp") & "\"

'Determine Default File Name for InputBox
  If SourceWB.Saved Then
    DefaultName = Left(SourceWB.Name, InStrRev(SourceWB.Name, ".") - 1)
  Else
    DefaultName = SourceWB.Name
  End If

'Ask user for a file name
  TempFileName = Application.InputBox("What would you like to name your attachment? (No Special Characters!)", _
    "File Name", Type:=2, Default:=DefaultName)
    
    If TempFileName = False Then Exit Sub 'Handle if user cancels
  
'Determine File Extension
  If SourceWB.Saved = True Then
    FileExtStr = "." & LCase(Right(SourceWB.Name, Len(SourceWB.Name) - InStrRev(SourceWB.Name, ".", , 1)))
  Else
    FileExtStr = ".xlsx"
  End If

'Optimize Code
  Application.ScreenUpdating = False
  Application.EnableEvents = False
  Application.DisplayAlerts = False

'Save Temporary Workbook
  SourceWB.SaveCopyAs TempFilePath & TempFileName & FileExtStr
  Set DestinWB = Workbooks.Open(TempFilePath & TempFileName & FileExtStr)

'Break External Links
  ExternalLinks = DestinWB.LinkSources(Type:=xlLinkTypeExcelLinks)

    'Loop Through each External Link in ActiveWorkbook and Break it
      On Error Resume Next
        For x = 1 To UBound(ExternalLinks)
          DestinWB.BreakLink Name:=ExternalLinks(x), Type:=xlLinkTypeExcelLinks
        Next x
      On Error GoTo 0
      
'Save Changes
  DestinWB.Save

'Create Instance of Outlook
  On Error Resume Next
    Set OutlookApp = GetObject(class:="Outlook.Application") 'Handles if Outlook is already open
  Err.Clear
    If OutlookApp Is Nothing Then Set OutlookApp = CreateObject(class:="Outlook.Application") 'If not, open Outlook
    
    If Err.Number = 429 Then
      MsgBox "Outlook could not be found, aborting.", 16, "Outlook Not Found"
      GoTo ExitSub
    End If
  On Error GoTo 0

'Create a new email message
  Set OutlookMessage = OutlookApp.CreateItem(0)

'Create Outlook email with attachment
  On Error Resume Next
    With OutlookMessage
     .To = ""
     .CC = ""
     .BCC = ""
     .Subject = TempFileName
     .Body = "Please see attached." & vbNewLine & vbNewLine & "Chris"
     .Attachments.Add DestinWB.FullName
     .Display
    End With
  On Error GoTo 0

'Close & Delete the temporary file
  DestinWB.Close SaveChanges:=False
  Kill TempFilePath & TempFileName & FileExtStr

'Clear Memory
  Set OutlookMessage = Nothing
  Set OutlookApp = Nothing
  
'Optimize Code
ExitSub:
  Application.ScreenUpdating = True
  Application.EnableEvents = True
  Application.DisplayAlerts = True

End Sub